#!/usr/bin/env bash
# TomeShelf for Linux — install or update in one line, no root:
#
#   curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash
#
# Puts the latest release under ~/.local/opt/tomeshelf, links
# tomeshelf-cli and tomeshelf-tui into ~/.local/bin, and places the launcher
# entry and icon under ~/.local/share. Re-running updates; so does
# `tomeshelf-cli update` once installed. Every download is verified against
# the release's SHA256SUMS before anything on disk is touched, and the sums
# against the release's Ed25519 signature (SHA256SUMS.sig) when openssl is
# on the machine — the same key `tomeshelf-cli update` carries.
#
# Options (after `bash -s --` when piped, or as arguments to a saved copy):
#   --version vX.Y   a specific release instead of the latest
#   --from FILE      install a tarball already on disk instead of
#                    downloading one — nothing is fetched or verified; for
#                    a build of your own, or a release's acceptance test
#   --prefix DIR     install under DIR/opt, DIR/bin and DIR/share (default:
#                    ~/.local; or set TOMESHELF_PREFIX)
#   --uninstall      remove the binaries, links and launcher entry; your
#                    library, downloads and settings under
#                    ~/.local/share/TomeShelf stay
#
# Requires: x86_64 Linux, glibc 2.39+, curl, tar, sha256sum. The daemon also
# needs a few system libraries (mpv, libsecret, sqlite, dbus) that only your
# package manager can install; the script checks and prints the exact
# command for your distro.
set -euo pipefail

REPO="Tuareg0xFFFF/TomeShelf-PUB-"
PREFIX="${TOMESHELF_PREFIX:-$HOME/.local}"
WANT="${TOMESHELF_VERSION:-}"
FROM=""
UNINSTALL=0
GLIBC_FLOOR="2.39"
# The release signing key, raw Ed25519 as OpenSSL's SubjectPublicKeyInfo PEM.
# The same key SelfUpdate.releasePublicKeyHex carries in the daemon.
RELEASE_PUBLIC_KEY_PEM='-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEAUmbOIFVShsyWeBmh9F2cGMWafznJBlwDBP0tZ1ceR5M=
-----END PUBLIC KEY-----'

if [ -t 1 ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'; YELLOW=$'\033[33m'; GREEN=$'\033[32m'; RESET=$'\033[0m'
else
    BOLD=""; DIM=""; RED=""; YELLOW=""; GREEN=""; RESET=""
fi
say()  { printf '%s\n' "$*"; }
step() { printf '%s==>%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%s%swarning:%s %s\n' "$BOLD" "$YELLOW" "$RESET" "$*" >&2; }
die()  { printf '%s%serror:%s %s\n' "$BOLD" "$RED" "$RESET" "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
    case "$1" in
        --version) [ $# -ge 2 ] || die "--version needs a value"; WANT="$2"; shift 2 ;;
        --version=*) WANT="${1#--version=}"; shift ;;
        --from) [ $# -ge 2 ] || die "--from needs a file"; FROM="$2"; shift 2 ;;
        --from=*) FROM="${1#--from=}"; shift ;;
        --prefix) [ $# -ge 2 ] || die "--prefix needs a value"; PREFIX="$2"; shift 2 ;;
        --prefix=*) PREFIX="${1#--prefix=}"; shift ;;
        --uninstall) UNINSTALL=1; shift ;;
        -h|--help) sed -n '2,20p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) die "unknown option: $1" ;;
    esac
done

INSTALL_DIR="$PREFIX/opt/tomeshelf"
BIN_DIR="$PREFIX/bin"
SHARE_DIR="$PREFIX/share"

# ---------------------------------------------------------------- uninstall

if [ "$UNINSTALL" = 1 ]; then
    step "Removing TomeShelf from $INSTALL_DIR"
    for exe in tomeshelf-cli tomeshelf-tui; do
        link="$BIN_DIR/$exe"
        # Only links that point into this install: never someone else's binary.
        if [ -L "$link" ] && [[ "$(readlink -f "$link")" == "$INSTALL_DIR"/* ]]; then
            rm -f "$link"
        fi
    done
    rm -rf "$INSTALL_DIR"
    rm -f "$SHARE_DIR/applications/tomeshelf.desktop" "$SHARE_DIR/pixmaps/tomeshelf.png"
    say "Removed. Your library, downloads and settings are untouched in ~/.local/share/TomeShelf."
    exit 0
fi

# ------------------------------------------------------------------- checks

[ "$(uname -s)" = "Linux" ] || die "this installer is for Linux (the Apple app is on the App Store)"
arch="$(uname -m)"
[ "$arch" = "x86_64" ] || die "no build is published for $arch yet — only x86_64"

for tool in tar sha256sum; do
    command -v "$tool" >/dev/null 2>&1 || die "$tool is required and not on \$PATH"
done
[ -n "$FROM" ] || command -v curl >/dev/null 2>&1 || die "curl is required and not on \$PATH"

glibc="$(getconf GNU_LIBC_VERSION 2>/dev/null | awk '{print $2}')"
if [ -n "$glibc" ] && [ "$(printf '%s\n%s\n' "$GLIBC_FLOOR" "$glibc" | sort -V | head -1)" != "$GLIBC_FLOOR" ]; then
    die "glibc $glibc found; TomeShelf needs $GLIBC_FLOOR or later (Ubuntu 24.04+, Debian 13+, Fedora 40+, any rolling distro)"
fi

if [ "$(id -u)" = 0 ] && [ -z "${TOMESHELF_PREFIX:-}" ]; then
    warn "running as root installs under /root/.local — run as your own user; no sudo is needed"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# -------------------------------------------------------------- from a file

if [ -n "$FROM" ]; then
    [ -f "$FROM" ] || die "$FROM does not exist"
    step "Unpacking $FROM"
    tar -xzf "$FROM" -C "$tmp" || die "could not unpack $FROM"
    [ -x "$tmp/tomeshelf/bin/tomeshelf-cli" ] && [ -x "$tmp/tomeshelf/bin/tomeshelf-tui" ] \
        || die "the tarball is not laid out as expected"
    [ -f "$tmp/tomeshelf/VERSION" ] || die "the tarball carries no VERSION"
    version="$(tr -d '[:space:]' < "$tmp/tomeshelf/VERSION")"
    say "    $version, unverified — a local file is trusted as given"
    refresh_only=0
else

# ----------------------------------------------------------------- resolve

step "Finding the release"
if [ -n "$WANT" ]; then
    case "$WANT" in v*) tag="$WANT" ;; *) tag="v$WANT" ;; esac
else
    # releases/latest redirects to releases/tag/<tag>. No API call, so no
    # unauthenticated rate limit to hit.
    landed="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")" \
        || die "could not reach github.com/$REPO"
    tag="${landed##*/}"
fi
case "$tag" in
    v[0-9]*) ;;
    *) die "could not determine the latest release (got '$tag')" ;;
esac
version="${tag#v}"
say "    $tag"

if [ -f "$INSTALL_DIR/VERSION" ] && [ "$(tr -d '[:space:]' < "$INSTALL_DIR/VERSION")" = "$version" ]; then
    say "    already installed at $INSTALL_DIR"
    refresh_only=1
else
    refresh_only=0
fi

# ---------------------------------------------------------------- download

if [ "$refresh_only" = 0 ]; then
    asset="tomeshelf-$version-linux-$arch.tar.gz"
    base="https://github.com/$REPO/releases/download/$tag"

    step "Downloading $asset"
    curl -fsSL --progress-bar -o "$tmp/$asset" "$base/$asset" \
        || die "$asset is not in release $tag"
    curl -fsSL -o "$tmp/SHA256SUMS" "$base/SHA256SUMS" \
        || die "release $tag publishes no SHA256SUMS — refusing an unverifiable download"

    step "Verifying"
    # The signature is what makes the sums mean something: they come from
    # the same release, over the same TLS, as the tarball. Checked when the
    # release has one and openssl is here to check it; the daemon's own
    # updater checks it always.
    if curl -fsSL -o "$tmp/SHA256SUMS.sig" "$base/SHA256SUMS.sig" 2>/dev/null; then
        if command -v openssl >/dev/null 2>&1; then
            printf '%s\n' "$RELEASE_PUBLIC_KEY_PEM" > "$tmp/release-key.pem"
            openssl pkeyutl -verify -pubin -inkey "$tmp/release-key.pem" -rawin \
                -in "$tmp/SHA256SUMS" -sigfile "$tmp/SHA256SUMS.sig" >/dev/null 2>&1 \
                || die "release $tag's SHA256SUMS does not verify against the TomeShelf release key — refusing it"
            say "    signature ok"
        else
            warn "openssl is not installed, so the release signature was not checked (the checksum still is)"
        fi
    else
        warn "release $tag is not signed (releases before v2.14 were not); only the checksum is checked"
    fi
    expected="$(awk -v name="$asset" '{ n = $2; sub(/^\*/, "", n); if (n == name) print $1 }' "$tmp/SHA256SUMS")"
    [ -n "$expected" ] || die "$asset is not listed in SHA256SUMS"
    actual="$(sha256sum "$tmp/$asset" | awk '{print $1}')"
    [ "$actual" = "$expected" ] || die "checksum mismatch for $asset — expected $expected, got $actual"
    say "    sha256 ok"

    tar -xzf "$tmp/$asset" -C "$tmp"
    [ -x "$tmp/tomeshelf/bin/tomeshelf-cli" ] && [ -x "$tmp/tomeshelf/bin/tomeshelf-tui" ] \
        || die "the tarball is not laid out as expected"
    # Older tarballs carry no VERSION; it is what makes the install
    # recognisable to `tomeshelf-cli update` later.
    [ -f "$tmp/tomeshelf/VERSION" ] || printf '%s\n' "$version" > "$tmp/tomeshelf/VERSION"
fi

fi  # --from

# ------------------------------------------------------------------ install

if [ "$refresh_only" = 0 ]; then
    step "Installing to $INSTALL_DIR"
    mkdir -p "$PREFIX/opt" "$BIN_DIR"
    # Stage beside the destination so the final move is one rename on one
    # filesystem; the old tree is kept until the new one is in place.
    staging="$PREFIX/opt/.tomeshelf.new.$$"
    rm -rf "$staging"
    mv "$tmp/tomeshelf" "$staging" 2>/dev/null || { cp -r "$tmp/tomeshelf" "$staging"; }
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR.old"
        mv "$INSTALL_DIR" "$INSTALL_DIR.old"
    fi
    mv "$staging" "$INSTALL_DIR" || { mv "$INSTALL_DIR.old" "$INSTALL_DIR" 2>/dev/null; die "could not move the new install into place"; }
    rm -rf "$INSTALL_DIR.old"
else
    mkdir -p "$BIN_DIR"
fi

# Relative links, so the whole prefix can move. The TUI finds its daemon
# through /proc/self/exe, which resolves the link, so the two stay siblings.
for exe in tomeshelf-cli tomeshelf-tui; do
    ln -sfn "../opt/tomeshelf/bin/$exe" "$BIN_DIR/$exe"
done

# The launcher entry and icon the tarball carries under share/, placed where
# a desktop looks for a user's own — $PREFIX/share is ~/.local/share by
# default, which is XDG_DATA_HOME. Older tarballs have no share/; fine.
if [ -f "$INSTALL_DIR/share/tomeshelf.desktop" ]; then
    install -Dm644 "$INSTALL_DIR/share/tomeshelf.desktop" "$SHARE_DIR/applications/tomeshelf.desktop"
    install -Dm644 "$INSTALL_DIR/share/tomeshelf.png" "$SHARE_DIR/pixmaps/tomeshelf.png"
fi

# ------------------------------------------------------------ dependencies

missing="$(ldd "$INSTALL_DIR/bin/tomeshelf-cli" 2>/dev/null | awk '/not found/ {print $1}' | sort -u | tr '\n' ' ')"
if [ -n "$missing" ]; then
    id=""; like=""
    if [ -r /etc/os-release ]; then
        id="$(. /etc/os-release && printf '%s' "${ID:-}")"
        like="$(. /etc/os-release && printf '%s' "${ID_LIKE:-}")"
    fi
    case " $id $like " in
        *" arch "*|*" manjaro "*|*" endeavouros "*)
            hint="sudo pacman -S --needed mpv sqlite libsecret dbus libxml2-legacy" ;;
        *" debian "*|*" ubuntu "*)
            hint="sudo apt install libmpv2 libsecret-1-0 libsqlite3-0 libdbus-1-3 libcurl4t64 libxml2" ;;
        *" fedora "*|*" rhel "*)
            hint="sudo dnf install mpv-libs libsecret sqlite-libs dbus-libs libcurl libxml2   # mpv-libs is in RPM Fusion" ;;
        *)
            hint="install the packages that provide: $missing" ;;
    esac
    say ""
    warn "installed, but the daemon cannot start until these libraries are present:"
    say "    $missing"
    say "    $hint"
fi

# -------------------------------------------------------------------- done

say ""
say "${BOLD}TomeShelf $version${RESET} is installed at $INSTALL_DIR"
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
        say ""
        warn "$BIN_DIR is not on your \$PATH. Add it to your shell profile:"
        say "    export PATH=\"$BIN_DIR:\$PATH\""
        ;;
esac
say ""
say "Next:"
say "    tomeshelf-tui"
say "${DIM}It starts its daemon and opens the form to add your server.${RESET}"
say "${DIM}Update later with: tomeshelf-cli update   (or re-run this script)${RESET}"
