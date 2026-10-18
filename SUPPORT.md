# TomeShelf Support

TomeShelf is an Audiobookshelf client for iPhone, iPad, Mac and Linux. Here is how to get help, report a problem, or ask for a feature.

Last updated: October 18, 2026

## Getting help

Open an issue on GitHub:

**https://github.com/Tuareg0xFFFF/TomeShelf-PUB-/issues**

## Before you open an issue

Most problems turn out to be connection or server-side issues. Please check:

1. Your Audiobookshelf server is reachable from the same device: open its address in a browser on the same network.
2. Your username, password or API key, and the server address, are correct.
3. You are running a supported Audiobookshelf version (see https://www.audiobookshelf.org).
4. You have the latest TomeShelf: from the App Store on Apple devices, or `tomeshelf-cli update --check` on Linux.

## Reporting a bug

Please include:

- **TomeShelf version:** shown at the bottom of the sidebar. On Linux, `tomeshelf-tui --version` prints it too.
- **Device and system:** iOS, iPadOS or macOS version and device model; on Linux, the distribution, the CPU (x86_64 or aarch64) and your terminal.
- **Audiobookshelf server version**
- **Steps to reproduce**, what you expected, and what happened
- **Screenshots or a screen recording**, if they help
- **On Linux**, for playback, download or sync problems: the relevant lines from `~/.local/state/tomeshelf/daemon.log`

Do **not** post your server address, username, password, API key or sign-in token in a public issue. Logs can contain your server's address, so replace it before pasting.

## Frequently asked questions

**Does TomeShelf work without an Audiobookshelf server?**
No. TomeShelf is a client for Audiobookshelf and needs a running server. Learn more at https://www.audiobookshelf.org.

**What does it cost?**
On Apple devices, one purchase (US $3.99) covers iPhone, iPad and Mac. The Linux version is free.

**Which Linux systems does it run on?**
x86_64 or aarch64 with glibc 2.39 or newer: Ubuntu 24.04+, Debian 13+, Fedora 40+, and rolling distributions such as Arch. It needs mpv, libsecret, sqlite and dbus; the installer checks for them and tells you what to install. Installing, updating and removing are covered in the [README](README.md#linux).

**Can I use more than one server?**
Yes. Add as many as you like; each keeps its own library and downloads.

**Can I keep listening with the Linux app closed?**
Yes. Run `tomeshelf-cli serve` in its own terminal or tmux pane. The app attaches to it, and quitting the app leaves playback running.

**Does TomeShelf send my data anywhere?**
Only to your Audiobookshelf server, plus Apple's podcast directory when you use Discover, a podcast's feed when you preview a show, and GitHub for update checks on Linux. See [PRIVACY.md](PRIVACY.md).

**How do I delete my data?**
Remove the server in TomeShelf. The details for each platform are in [PRIVACY.md](PRIVACY.md#deleting-your-data).

**Where do I find my server's address?**
Whoever set up your Audiobookshelf server chose it. If that isn't you, ask them.

## Feature requests

Open an issue whose title starts with "Feature request:", and describe what you are trying to do.

## Privacy

See [PRIVACY.md](PRIVACY.md) for the privacy policy.
