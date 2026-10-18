# TomeShelf

[TomeShelf](https://apps.apple.com/us/app/tomeshelf/id6761666925) is an Linux, iOS, iPadOS and macOS client for your self-hosted [Audiobookshelf](https://www.audiobookshelf.org/) server. Linux version is free, Apple - universal one time purchase (one purchase covers all Apple targets),

This app, originally created for my private use, caters to my preferences (some are probably idiosyncratic):
- Native app with single codebase
- Modern UI design
- Automatic sync with ABS server
- Full-featured, transparent offline mode: if offline mode is selected (per-server setting), all books will be cached on device automatically. Regardless of offline mode switch, one can always download individual books or remove downloaded book from cache. Individual podcast episodes follow the same pattern - one has full control over caching.
- Podcasts section is a first class citizen. Podcast discovery is built in.
- In-app book collections management.
- Player control for night-time listening where interactions with the screen/keyboard/mouse should be minimal via playback control provided by airpods (single/double/triple presses).
- In-app podcast lookup, management, caching for offline use.
- Universal search covers both books and podcasts.
 
> Need help? See [Support](SUPPORT.md).

---

## Linux

Terminal app (`tomeshelf-tui`) over a background daemon (`tomeshelf-cli`) that plays the audio, downloads books and keeps the library. Same sync, offline library and progress as the Apple app. Cover art in terminals with an image protocol (kitty, Ghostty, WezTerm, foot, xterm); elsewhere covers are tiles with the title's initials.

### Install

No root:

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash
```

Installs under `~/.local/opt/tomeshelf` and links both commands into `~/.local/bin`. If that directory is not on your `$PATH`, the installer says so and prints the line to add. It also checks the system libraries the daemon needs and prints the install command for your distro.

### Start

```bash
tomeshelf-tui
```

Or open TomeShelf from your desktop's app menu; it runs in a terminal. The app starts its daemon, and on first run opens the form to add your server. One copy of the app runs at a time.

### Stop

Press `q`. The daemon the app started stops with it, so if something is playing the app asks first: *Playback will stop — quit? (y/n)*. Closing the terminal window stops both without asking.

To keep listening with the app closed, run the daemon yourself, in its own terminal or a tmux pane:

```bash
tomeshelf-cli serve
```

`tomeshelf-tui` then attaches to that daemon instead of starting one. Quitting the app leaves playback running, and opening it again picks up where it is. Stop the daemon with `Ctrl-C` in its terminal.

### Update

In the app: it checks for a new release every hour and names it in the footer. Press `U` (Shift-U) and confirm. It downloads the release, verifies its signature, installs it, and restarts the daemon and the app; playback stops during the restart.

From the command line, with the app closed:

```bash
tomeshelf-cli update           # install the latest release
tomeshelf-cli update --check   # only say whether there is one
```

`tomeshelf-tui --update` and re-running the install line do the same. These only replace the files: an app or daemon that is already running keeps the old version until it is started again.

### Uninstall

Quit the app, and stop any `tomeshelf-cli serve`, first.

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash -s -- --uninstall
```

Removes binaries, links and the launcher entry. Data stays in `~/.local/share/TomeShelf` (library, downloads, settings) and the daemon log in `~/.local/state/tomeshelf`; delete those to remove everything. Sign-in tokens: keyring entries labelled TomeShelf, or `secrets.json` in the data directory when no keyring is running.

### Details

Requirements: x86_64 or aarch64; glibc 2.39+ (Ubuntu 24.04+, Debian 13+, Fedora 40+, rolling distros); mpv, libsecret, sqlite, dbus. The installer itself needs curl, tar and sha256sum.

Releases carry one tarball per architecture (`bin/`, `VERSION`, `LICENSE`, `share/`), `SHA256SUMS`, and `SHA256SUMS.sig`. The updater verifies both. The installer always verifies the checksum, and the signature when `openssl` is installed.

`tomeshelf-cli help` lists the daemon's other commands (sign in, sync, listening sessions).

### Screenshots

<table>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-home.png" width="440" alt="Home"><br><b>Home</b></td><td align="center" width="50%"><img src="screenshots/linux/books-collections.png" width="440" alt="Collections"><br><b>Collections</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-player.png" width="440" alt="Player"><br><b>Player</b></td><td align="center" width="50%"><img src="screenshots/linux/books-miniplayer.png" width="440" alt="Mini player"><br><b>Mini player</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/books-stats.png" width="440" alt="Stats"><br><b>Stats</b></td><td align="center" width="50%"><img src="screenshots/linux/podcasts-home.png" width="440" alt="Podcasts home"><br><b>Podcasts home</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/podcasts-latest.png" width="440" alt="Latest episodes"><br><b>Latest episodes</b></td><td align="center" width="50%"><img src="screenshots/linux/podcasts-discover.png" width="440" alt="Discover"><br><b>Discover</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/linux/podcasts-player.png" width="440" alt="Episode player"><br><b>Episode player</b></td></tr>
</table>

---

## iPhone Duo screenshots

Taken on the iPhone Duo simulator. The folded cover screen first, then the inner screen held open like a book, where the player spreads across both pages.

<table>
<tr><td align="center" width="50%"><img src="screenshots/iphone-duo/books-01-home-folded.png" width="300" alt="Folded — Home"><br><b>Folded — Home</b></td><td align="center" width="50%"><img src="screenshots/iphone-duo/player-book-folded.png" width="300" alt="Folded — Player"><br><b>Folded — Player</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/iphone-duo/books-01-home-unfolded-sidebar.png" width="440" alt="Unfolded — Home with sidebar"><br><b>Unfolded — Home with sidebar</b></td><td align="center" width="50%"><img src="screenshots/iphone-duo/books-01-home-unfolded.png" width="440" alt="Unfolded — Home"><br><b>Unfolded — Home</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/iphone-duo/player-book-unfolded.png" width="440" alt="Unfolded — Player"><br><b>Unfolded — Player</b></td><td align="center" width="50%"><img src="screenshots/iphone-duo/player-podcast-unfolded.png" width="440" alt="Unfolded — Episode player"><br><b>Unfolded — Episode player</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/iphone-duo/podcasts-01-home-unfolded-sidebar.png" width="440" alt="Unfolded — Podcasts home"><br><b>Unfolded — Podcasts home</b></td><td align="center" width="50%"><img src="screenshots/iphone-duo/podcasts-02-library-unfolded-sidebar.png" width="440" alt="Unfolded — Podcasts library"><br><b>Unfolded — Podcasts library</b></td></tr>
<tr><td align="center" width="50%"><img src="screenshots/iphone-duo/podcasts-03-discover-unfolded.png" width="440" alt="Unfolded — Discover"><br><b>Unfolded — Discover</b></td></tr>
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
