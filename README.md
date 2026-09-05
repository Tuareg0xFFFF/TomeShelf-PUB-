# TomeShelf

[TomeShelf](https://apps.apple.com/us/app/tomeshelf/id6761666925) is an Linux, iOS, iPadOS and macOS client for your self-hosted [Audiobookshelf](https://www.audiobookshelf.org/) server.

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

TomeShelf also runs on Linux as a terminal app (`tomeshelf-tui`) over a playback daemon (`tomeshelf-cli`), with the same sync, offline library and progress as the Apple app, on x86_64 and ARM machines alike. Cover art is drawn in terminals with an image protocol (kitty, Ghostty, WezTerm, foot). Install or update with one line, no root:

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash
```

Then:

```bash
tomeshelf-tui
```

It starts its daemon and, on first run, opens the form to add your server. The daemon is also a command line (`tomeshelf-cli help`) for a machine with no terminal in front of it.

`tomeshelf-cli update` updates it, and so does `U` in the TUI once its footer says a newer release is out: it installs the release and restarts. To remove it:

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash -s -- --uninstall
```

That removes the binaries, the links and the launcher entry. Your library, downloads and settings stay in `~/.local/share/TomeShelf`; delete that directory to remove them, and `~/.local/state/tomeshelf` for the daemon log. Sign-in tokens are keyring entries labelled TomeShelf when a keyring is running, otherwise `secrets.json` inside that directory.

Requirements: x86_64 or aarch64 — an ARM server, a Raspberry Pi 5, a Mac running Asahi — with glibc 2.39 or later (Ubuntu 24.04+, Debian 13+, Fedora 40+, rolling distros), and the system libraries mpv, libsecret, sqlite and dbus, which the installer names for your distro. Downloads are checked against the release's `SHA256SUMS`, and the sums against the release signature (`SHA256SUMS.sig`) when `openssl` is installed.

Each [release](https://github.com/Tuareg0xFFFF/TomeShelf-PUB-/releases) also carries the tarballs themselves, one per architecture, and the installer picks the one for your machine: `bin/`, `VERSION`, `LICENSE`, and a launcher entry under `share/`. Both are built and tested natively.

### Screenshots

<table>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-home.png" width="440" alt="Home"><br><b>Home</b><br>The book library's home: Continue Listening, Reading List, Recently Added and Recent Series as rows of covers, with the selected book's details beside them.</td><td align="center" width="50%"><img src="screenshots/linux/books-collections.png" width="440" alt="Collections"><br><b>Collections</b><br>Each collection as a row, with its length in books and hours.</td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-player.png" width="440" alt="Player"><br><b>Player</b><br>The player over the library: cover, a scrubber with the chapter marks, transport, and the chapter list.</td><td align="center" width="50%"><img src="screenshots/linux/books-miniplayer.png" width="440" alt="Mini player"><br><b>Mini player</b><br>The player put away: one line above the footer with the position, while the library stays in front.</td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-stats.png" width="440" alt="Stats"><br><b>Stats</b><br>Listening time all time, today and this week, recent days and weekdays as bars, most-listened titles, and what the cache holds.</td><td align="center" width="50%"><img src="screenshots/linux/podcasts-home.png" width="440" alt="Podcasts home"><br><b>Podcasts home</b><br>Continue Listening, Newest Episodes and Listen Again for the podcast library.</td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/podcasts-latest.png" width="440" alt="Latest episodes"><br><b>Latest episodes</b><br>Every podcast's newest episodes in one list, newest first, with the star for favourites and the download state on each row.</td><td align="center" width="50%"><img src="screenshots/linux/podcasts-discover.png" width="440" alt="Discover"><br><b>Discover</b><br>Apple's charts by genre, with each show's own description; a search field takes a name or an RSS feed URL.</td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/podcasts-player.png" width="440" alt="Episode player"><br><b>Episode player</b><br>The player for an episode: its artwork, the scrubber, and the show notes with their links.</td></tr>
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
