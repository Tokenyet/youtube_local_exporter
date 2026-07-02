# YouTube Local Exporter

YouTube Local Exporter is a Windows-first Chromium MV3 extension for exporting authorized YouTube videos, audio, and subtitles through a local native messaging host.

The extension UI runs in the browser. Downloading, remuxing, audio extraction, subtitle export, and Whisper fallback transcription run locally through the native host.

## Features

- Export a YouTube video as MP4 with a selected maximum quality.
- Export audio as m4a, mp3, opus, wav, or best.
- Export subtitles as SRT or VTT.
- Prefer YouTube subtitles and fall back to local Whisper when no subtitle track is available.
- Force local Whisper subtitle generation.
- Keep all generated files under a local output folder.
- Store only extension settings in `chrome.storage.sync`.

Use this only for videos you own or are authorized to export.

## Install

Requirements:

- Windows 10 or 11.
- Chrome, Edge, Chromium, or Vivaldi.
- PowerShell.
- Python 3.11 or newer, unless you build and install the native host executable.

Clone the repository:

```powershell
git clone https://github.com/Tokenyet/youtube_local_exporter.git
cd youtube_local_exporter
```

Package the extension runtime:

```powershell
.\scripts\package.ps1
```

Load the extension in your browser:

1. Open `chrome://extensions`, `edge://extensions`, or the equivalent extensions page for your browser.
2. Enable Developer mode.
3. Choose `Load unpacked`.
4. Select `dist\unpacked\youtube-local-exporter`.
5. Copy the generated extension ID.

Install the native messaging host for that extension ID:

```powershell
.\scripts\install-native.ps1 -ExtensionId <extension-id> -Browser chrome
```

Use `-Browser edge`, `-Browser chromium`, `-Browser vivaldi`, or omit `-Browser` to register all supported browser registry paths.

Download the local tools used by the native host:

```powershell
.\scripts\update-tools.ps1
```

This installs `yt-dlp`, Deno for yt-dlp JavaScript challenge solving, FFmpeg/FFprobe, whisper.cpp, and the selected Whisper model into `%LOCALAPPDATA%\YouTubeLocalExporter\tools`.

Open a YouTube watch page, click the extension icon, choose the export mode and output folder, then start the export.

To uninstall the native host registration:

```powershell
.\scripts\uninstall-native.ps1 -Browser chrome
```

Add `-RemoveFiles` if you also want to remove `%LOCALAPPDATA%\YouTubeLocalExporter`.

## Optional Native Host EXE

The default installer creates a launcher that runs the Python native host. To install a standalone host executable instead, install `uv`, build the executable, then run the installer again:

```powershell
.\scripts\build-native.ps1
.\scripts\install-native.ps1 -ExtensionId <extension-id> -Browser chrome
```

When `native-host\dist\youtube-local-exporter-host.exe` exists, the installer copies and registers that executable.

## Development Setup

Generate icons:

```powershell
.\scripts\generate-icons.ps1
```

Load the extension:

1. Open `chrome://extensions`.
2. Enable Developer mode.
3. Choose `Load unpacked`.
4. Select `dist\unpacked\youtube-local-exporter`.
5. Copy the generated extension ID.

Install the native messaging host for that extension ID:

```powershell
.\scripts\install-native.ps1 -ExtensionId <extension-id>
```

Download local tools into `%LOCALAPPDATA%\YouTubeLocalExporter\tools`:

```powershell
.\scripts\update-tools.ps1
```

This installs `yt-dlp`, Deno for yt-dlp JavaScript challenge solving, FFmpeg/FFprobe, whisper.cpp, and the selected Whisper model.

## Validation

GitHub Actions runs the same validation on Windows for pushes and pull requests.

```powershell
node --check src\background.js
node --check src\content.js
node --check popup\popup.js
node --check options\options.js
node scripts\smoke-test.mjs
python -m unittest discover -s native-host\tests
```

Package the extension runtime:

```powershell
.\scripts\package.ps1
```

The ZIP contains only `manifest.json`, `src`, `popup`, `options`, `icons`, and `_locales`.

## Native Host

The host name is `com.dowen.youtube_local_exporter`.

The installer writes a native messaging manifest to:

```text
%LOCALAPPDATA%\YouTubeLocalExporter\com.dowen.youtube_local_exporter.json
```

and registers it under HKCU native messaging host registry paths.

For development, the installer creates a `.cmd` launcher that runs the Python host. For release builds, run:

```powershell
.\scripts\build-native.ps1
.\scripts\install-native.ps1 -ExtensionId <extension-id>
```

When `native-host\dist\youtube-local-exporter-host.exe` exists, the installer uses that executable instead of the Python launcher.

## Scope

This project is built for local sideload/private use. It is not a Chrome Web Store release target in v1. It does not support playlists, batch jobs, DRM bypassing, paywall bypassing, or cloud transcription.
