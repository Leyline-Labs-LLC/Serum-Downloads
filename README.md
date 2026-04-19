# Serum Downloads

Installable builds of [Serum](https://serum.leylinelabs.io) for anyone
who wants to try it before it's on the App Store / Play Store. The app
source lives in a private repo; this one exists so builds can be public.

Every green build of `main` in the source repo overwrites the files
here. If you edit anything directly in this repo, expect it to be
wiped on the next push.

## Android

Download [`serum.apk`](serum.apk) and open it. You may need to enable
"Install unknown apps" for your browser in Android settings first.

Works on Android 8.0 and up.

## iOS

Download [`serum-ios-unsigned.zip`](serum-ios-unsigned.zip). The build
inside is unsigned, which means Apple won't install it directly. You
have two options.

### Option 1: Sideloadly or AltStore (easiest)

No command line, no Xcode. Both tools sign the app with your Apple ID
as you install it.

1. Install [Sideloadly](https://sideloadly.io/) (Windows, macOS, or
   Linux) or [AltStore](https://altstore.io/) (macOS / Windows).
2. Open the downloaded `serum-ios-unsigned.zip` with the tool.
3. Sign in with your Apple ID when prompted.
4. Plug in your iPhone and hit Install.

First time you launch Serum on your device, you'll need to trust the
developer profile: **Settings -> General -> VPN & Device Management ->
tap your profile -> Trust**.

Apple signs sideloaded apps with a 7-day certificate by default (free
account) or 1-year (paid $99/yr Apple Developer Program). When it
expires, re-install the same way.

### Option 2: Command line (`sign_ios.sh`)

If you're already comfortable on a Mac terminal and have Xcode
command-line tools installed:

```bash
git clone https://github.com/Leyline-Labs-LLC/Serum-Downloads.git
cd Serum-Downloads

# List your Apple signing identities
security find-identity -v -p codesigning

# Sign with one of them
chmod +x sign_ios.sh
./sign_ios.sh "Apple Development: you@example.com (ABCDE12345)"
```

`sign_ios.sh` produces `Serum.ipa`. Install it any of these ways:

- Drag onto Sideloadly or AltStore.
- `xcrun devicectl device install app --device <uuid> Serum.ipa`
- `ideviceinstaller -i Serum.ipa` (requires libimobiledevice)

## License

These builds are distributed under the same license as the upstream
Serum project.
