# Privacy Policy for TomeShelf

Last updated: October 18, 2026

TomeShelf is a client for [Audiobookshelf](https://www.audiobookshelf.org), a self-hosted audiobook and podcast server. It runs on iPhone, iPad and Mac (from the App Store) and on Linux (`tomeshelf-tui` and `tomeshelf-cli`). This policy covers all of them.

## The short version

- TomeShelf collects nothing for the developer. There are no analytics, no tracking, no ads, and no TomeShelf account or server.
- Your library, progress and downloads stay on your device and on the Audiobookshelf server you choose.
- Besides your server, TomeShelf contacts Apple's podcast directory when you use Discover, a podcast's own feed when you preview a show, and, on Linux only, GitHub to check for updates. Details below.

## What TomeShelf connects to

**Your Audiobookshelf servers.** Everything TomeShelf shows and plays comes from the servers you add: sign-in, library, covers, audio, ebooks, playback progress and listening sessions. Your server records your listening the way it does for any client, and TomeShelf identifies itself to it by its name, its version and the audio player it uses. What your server keeps is up to whoever runs it.

**Apple's podcast directory (itunes.apple.com).** Used only for finding podcasts: the Discover charts, and opening an Apple Podcasts link you paste. Chart requests include your region code (for example `us`), taken from your device's region setting, so you see your country's charts. Show artwork in those lists loads from Apple's servers. Searching for a podcast by name goes through your Audiobookshelf server, which asks Apple itself.

**A podcast's own feed.** When you open a show's page before subscribing, TomeShelf reads that show's RSS feed directly from the podcast's host to show its description and recent episodes, as any podcast app does.

**GitHub (Linux only).** While the Linux app is open, it checks github.com about once an hour for a newer TomeShelf release, and downloads one only when you choose to update. The check carries nothing about you or your library.

**Nothing else.** TomeShelf never contacts a server run by the developer. On Linux, the terminal app talks to its daemon over 127.0.0.1 with a key that changes on every run; the daemon is not reachable from the network.

## Apple devices

The App Store handles purchases and updates. If you have chosen to share analytics with app developers, Apple may pass the developer crash reports and aggregate usage figures. That is an Apple setting you can turn off: Settings › Privacy & Security › Analytics & Improvements on iPhone and iPad, and System Settings › Privacy & Security › Analytics & Improvements on Mac.

## What is stored, and where

**On iPhone, iPad and Mac**, everything stays in TomeShelf's own storage on the device: the library cache, cover images, downloaded audio and ebooks, and your settings. Sign-in tokens are kept in the Keychain.

**On Linux:**

- `~/.local/share/TomeShelf`: the library database, downloads and settings
- `~/.cache/tomeshelf`: cover thumbnails
- `~/.local/state/tomeshelf`: the daemon's log, which can include your server's address and the titles of what you play. It never leaves your computer.
- Sign-in tokens go in your desktop keyring (the Secret Service, such as GNOME Keyring or KWallet), labelled TomeShelf. If no keyring is running, they go in `secrets.json` in the data directory, as plain text readable only by your user account.

## Deleting your data

**Everywhere:** removing a server in TomeShelf deletes its sign-in tokens, its cached library and the audio downloaded from it. Signing out deletes only the tokens and keeps the rest. Turning off Offline Library deletes the downloaded books.

**iPhone, iPad and Mac:** deleting the app removes its data from the device. Apple devices can keep Keychain items after an app is deleted, so remove your servers first if you want the sign-in tokens gone straight away.

**Linux:** the uninstaller removes the program but not your data:

```bash
curl -fsSL https://raw.githubusercontent.com/Tuareg0xFFFF/TomeShelf-PUB-/main/install.sh | bash -s -- --uninstall
```

Then delete `~/.local/share/TomeShelf`, `~/.cache/tomeshelf` and `~/.local/state/tomeshelf`, and remove the TomeShelf entries from your keyring.

## Children's privacy

TomeShelf collects no data from anyone, including children under 13.

## Changes to this policy

Updates are posted on this page with a new date.

## Contact

Questions about this policy: open an issue at https://github.com/Tuareg0xFFFF/TomeShelf-PUB-/issues.
