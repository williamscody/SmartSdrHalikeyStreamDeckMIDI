# Troubleshooting and removal

## SmartSDR does not react to either controller

1. Open **Audio MIDI Setup** and verify **IAC Driver** is online.
2. Verify both `Bus 1` and `Bus 2` are enabled.
3. In SmartSDR, select **IAC Driver** as the MIDI device.
4. Restart SmartSDR after changing its MIDI device selection.

The critical tested behavior is that SmartSDR receives the two IAC buses when its device is the parent **IAC Driver**. If the application selects or displays a different device, return to that setting first.

## Stream Deck+ works but HaliKey does not

This usually means Bus 1 and SmartSDR are correct, but the HaliKey route is not running.

Check the process:

```bash
pgrep -x routemidi
```

If it prints no process ID, start the route manually:

```bash
/opt/homebrew/bin/routemidi in "HaliKey MIDI" out "IAC Driver Bus 2"
```

If that reports a missing port, inspect the available names:

```bash
/opt/homebrew/bin/routemidi list
```

Confirm the HaliKey is connected and appears as `HaliKey MIDI`; then confirm the output is `IAC Driver Bus 2`.

## HaliKey is connected after login or after the launcher starts

The basic launcher starts RouteMIDI once. If the HaliKey was absent at that point, stop the existing router and launch the app again after connecting the HaliKey.

To stop it:

```bash
pkill -x routemidi
```

Then double-click `Ham Radio MIDI Router.app`, or run the route command again. Ensure you stop the existing process before relaunching because the included launcher intentionally protects against duplicates.

## The launcher does nothing

Read its log:

```bash
tail -n 50 /tmp/routemidi.log
```

Typical causes:

- RouteMIDI is not installed at `/opt/homebrew/bin/routemidi`.
- The HaliKey or IAC bus has a different name.
- A prior `routemidi` process is already running.

Use `which routemidi` to find the installed executable, update the AppleScript path if necessary, then save the application again.

## More than one RouteMIDI process is running

The launcher prevents new duplicate processes, but manually launched processes can still leave multiples. See them with:

```bash
pgrep -alf routemidi
```

Stop all RouteMIDI processes:

```bash
pkill -x routemidi
```

Then launch only `Ham Radio MIDI Router.app` once.

## HaliKey maps incorrectly

The route preserves HaliKey messages; it does not assign SmartSDR actions. In SmartSDR’s MIDI mapping editor, verify these are **Button** mappings:

| Code/control | Action |
| --- | --- |
| 20 | Trigger CW left paddle |
| 21 | Trigger CW right paddle |
| 31 | PTT Push |

The current [HaliKey User Guide](https://halibut-electronics.github.io/HaliKey/User%20Guide.pdf) is the authoritative source for the device’s mappings and normal SmartSDR setup.

## RouteMIDI virtual output appears, but SmartSDR does not work with it

This project intentionally does not use `vout`. RouteMIDI virtual ports are legitimate features, but the proven SmartSDR configuration uses macOS IAC buses and selects **IAC Driver** in SmartSDR. Use:

```bash
routemidi in "HaliKey MIDI" out "IAC Driver Bus 2"
```

## Uninstall or revert

1. Remove `Ham Radio MIDI Router.app` from **System Settings → General → Login Items & Extensions**.
2. Stop the active route, if any:

   ```bash
   pkill -x routemidi
   ```

3. Delete the saved launcher application if you no longer want it.
4. In Audio MIDI Setup, disable or remove `Bus 2` if no other application uses it.
5. In SmartSDR, choose the controller setup you used before this project.

You may leave `Bus 1` in place if the Stream Deck+ continues to use it. RouteMIDI can be removed separately using the installation method you chose (for the Homebrew installation, `brew uninstall routemidi`).
