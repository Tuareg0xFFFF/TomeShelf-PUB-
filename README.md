# TomeShelf

[TomeShelf](https://apps.apple.com/us/app/tomeshelf/id6761666925) is an Linux, iOS, iPadOS and macOS client for your self-hosted [Audiobookshelf](https://www.audiobookshelf.org/) server. Linux version is free, Apple - universal one time purchase (one purchase covers all Apple targets),

This app, originally created for my private use, caters to my preferences (some are probably idiosyncratic):
- Native app with single codebase
- Modern UI design
- Automatic sync with ABS server
- Full-featured, transparent offline mode: if offline mode is selected (per-server setting), all books will be cached on device automatically. Regardless of offline mode switch, one can always download individual books or remove downloaded book from cache. Individual podcast episodes follow the same pattern - one has full control over caching.
- Podcasts are as important as books.
- In-app book collections management
- Player control for night-time listening where interactions with the screen/keyboard/mouse should be minimal via playback control provided by airpods (single/double/triple presses)
- In-app podcast lookup, management, caching for offline use
- Universal search that includes both books and podcasts
 
> Need help? See [Support](SUPPORT.md).

---

## Linux

Terminal app (`tomeshelf-tui`) over a playback daemon (`tomeshelf-cli`). Same sync, offline library and progress as the Apple app. Cover art in terminals with an image protocol (kitty, Ghostty, WezTerm, foot).

Install or update, no root:

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash
```

Run:

```bash
tomeshelf-tui
```

Starts the daemon; on first run, opens the add-server form. `tomeshelf-cli help` lists the daemon's own commands.

Updates: the app checks hourly and names a new release in the footer. `U` downloads it, verifies the signature, installs it and restarts the app and the daemon. `tomeshelf-cli update` does the same from the command line.

Uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash -s -- --uninstall
```

Removes binaries, links and the launcher entry. Data stays in `~/.local/share/TomeShelf` and the daemon log in `~/.local/state/tomeshelf`. Sign-in tokens: keyring entries labelled TomeShelf, or `secrets.json` in the data directory when no keyring is running.

Requirements: x86_64 or aarch64; glibc 2.39+ (Ubuntu 24.04+, Debian 13+, Fedora 40+, rolling distros); mpv, libsecret, sqlite, dbus. The installer names the packages for the distro.

Releases carry one tarball per architecture (`bin/`, `VERSION`, `LICENSE`, `share/`), `SHA256SUMS`, and `SHA256SUMS.sig`. The installer and the updater verify both.

### Screenshots

<table>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-home.png" width="440" alt="Home"><br><b>Home</b></td><td align="center" width="50%"><img src="screenshots/linux/books-collections.png" width="440" alt="Collections"><br><b>Collections</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-player.png" width="440" alt="Player"><br><b>Player</b></td><td align="center" width="50%"><img src="screenshots/linux/books-miniplayer.png" width="440" alt="Mini player"><br><b>Mini player</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-stats.png" width="440" alt="Stats"><br><b>Stats</b></td><td align="center" width="50%"><img src="screenshots/linux/podcasts-home.png" width="440" alt="Podcasts home"><br><b>Podcasts home</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/podcasts-latest.png" width="440" alt="Latest episodes"><br><b>Latest episodes</b></td><td align="center" width="50%"><img src="screenshots/linux/podcasts-discover.png" width="440" alt="Discover"><br><b>Discover</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/podcasts-player.png" width="440" alt="Episode player"><br><b>Episode player</b></td></tr>
</table>

---

## iOS and iPadOS screenshots

Taken on an iPad Mini.

### Getting started

#### Add a server
<img src="screenshots/01-add-server.png" width="320" alt="Add Server">

Server configuration window pops up automatically. Multiple servers are supported.

---

### Books

#### Home

<img src="screenshots/02-home.png" width="320" alt="Home">

Notice ABS server version and status displayed in the bottom part of the sidebar, along with the app version.

<img src="screenshots/03-home-now-playing.png" width="320" alt="Home with mini player">

#### Continue Listening shelf

<img src="screenshots/04-continue-listening.png" width="320" alt="Continue Listening">

<img src="screenshots/05-continue-listening-grid.png" width="320" alt="Continue Listening grid">

#### Book details

<img src="screenshots/06-book-details.png" width="320" alt="Book details">

#### Player

<img src="screenshots/07-player.png" width="320" alt="Player">

Notice chapter marks in the progress bar.

#### Player — chapters

<img src="screenshots/08-player-chapters.png" width="320" alt="Player chapters">

#### Listening stats

<img src="screenshots/09-stats.png" width="320" alt="Listening stats">

---

### Podcasts

#### Podcasts home

<img src="screenshots/10-podcasts-home.png" width="320" alt="Podcasts home">

<img src="screenshots/11-podcasts-home-wide.png" width="320" alt="Podcasts home wide">

#### Latest episodes

<img src="screenshots/12-latest-episodes.png" width="320" alt="Latest episodes">

#### Episode player

<img src="screenshots/13-episode-player.png" width="320" alt="Episode player">

#### Episode notes

<img src="screenshots/14-episode-notes.png" width="320" alt="Episode notes">

#### Podcasts — now playing

<img src="screenshots/15-podcasts-now-playing.png" width="320" alt="Podcasts with mini player">

#### Podcasts library

<img src="screenshots/16-podcasts-library.png" width="320" alt="Podcasts library">

#### Podcast detail

<img src="screenshots/17-podcast-detail.png" width="320" alt="Podcast detail">

#### Podcast favorites

<img src="screenshots/18-favorites.png" width="320" alt="Favorites">

#### Podcast search

<img src="screenshots/19-add-podcast-search.png" width="320" alt="Add podcast search">

In-app search for new podcasts

<img src="screenshots/20-add-podcast-detail.png" width="320" alt="Add podcast details">

---

### Search

#### Library search

<img src="screenshots/21-search.png" width="320" alt="Library search">

Search is global, notice how Sean Carrol's books and podcasts are picked up.
