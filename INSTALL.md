# Installation and configuration

## Prerequisites

- A Mac running SmartSDR for Mac.
- HaliKey **MIDI** connected by USB.
- A Stream Deck+ configuration that sends MIDI to `IAC Driver Bus 1`.
- [RouteMIDI](https://github.com/gbevin/RouteMIDI), tested here with version 0.9.10.

HaliKey MIDI is USB class-compliant and should appear as `HaliKey MIDI` without an additional driver. Confirm that name before configuring the route.

## 1. Configure the macOS IAC Driver

1. Open **Audio MIDI Setup** (`/Applications/Utilities/Audio MIDI Setup.app`).
2. Choose **Window → Show MIDI Studio** if the MIDI devices are not visible.
3. Double-click **IAC Driver**.
4. Check **Device is online**.
5. In the Ports list, enable or add two ports. Their visible names should be:
   - `Bus 1`
   - `Bus 2`
6. Close the IAC Driver window. Applications will normally show them as `IAC Driver Bus 1` and `IAC Driver Bus 2`.

Do not use the generic IAC device name as the RouteMIDI output. Use the precise Bus 2 name.

## 2. Keep Stream Deck+ on Bus 1

In the Stream Deck MIDI plug-in or profile, leave its MIDI destination set to:

```text
IAC Driver Bus 1
```

This project does not require reprogramming the Stream Deck+.

## 3. Install RouteMIDI

RouteMIDI’s upstream project documents this Homebrew installation command:

```bash
brew install gbevin/tools/routemidi
```

Confirm the executable and ports:

```bash
which routemidi
routemidi list
```

The tested Apple Silicon Homebrew path is:

```text
/opt/homebrew/bin/routemidi
```

If `which routemidi` reports another path, update the AppleScript before saving it as an application.

## 4. Start the HaliKey route

For an initial test, run:

```bash
routemidi in "HaliKey MIDI" out "IAC Driver Bus 2"
```

RouteMIDI remains running while it forwards MIDI. Leave the command running for this test, then operate a HaliKey paddle and an assigned Stream Deck+ control.

If RouteMIDI cannot find a port, run `routemidi list` and use the names it reports. RouteMIDI supports case-insensitive substring matching, but exact displayed names make troubleshooting clearer.

## 5. Set SmartSDR to IAC Driver

In SmartSDR for Mac, open the MIDI controller configuration and set the MIDI device to:

```text
IAC Driver
```

Do **not** select `IAC Driver Bus 1` or `IAC Driver Bus 2` here if SmartSDR offers the parent device. The proven configuration selects the parent **IAC Driver** device, which receives traffic from both buses.

For HaliKey mappings, use SmartSDR’s MIDI mapping editor to map Button codes 20, 21, and 31 to CW left paddle, CW right paddle, and PTT Push respectively. Refer to the [HaliKey User Guide](https://halibut-electronics.github.io/HaliKey/User%20Guide.pdf) for its current product guidance.

## 6. Create the no-Terminal-window launcher

1. Open **Script Editor**.
2. Open [`Ham Radio MIDI Router.applescript`](Ham%20Radio%20MIDI%20Router.applescript) and paste its contents into a new Script Editor document.
3. Confirm `/opt/homebrew/bin/routemidi` is the correct path for your Mac; change only that path if `which routemidi` showed a different one.
4. Choose **File → Save**.
5. Name it `Ham Radio MIDI Router`.
6. Select **File Format: Application** and save it somewhere stable, such as `/Applications`.

The app runs RouteMIDI in the background, so it opens no Terminal window. It also checks for a running process named `routemidi` first, preventing accidental duplicates.

## 7. Launch automatically at login

1. Open **System Settings → General → Login Items & Extensions**.
2. Under **Open at Login**, click **+**.
3. Add `Ham Radio MIDI Router.app`.

The tested normal use case has both the HaliKey and Stream Deck+ connected before login. If the HaliKey is disconnected while the launcher runs, reconnect it and restart the launcher after stopping RouteMIDI; see troubleshooting.

## Verify

With SmartSDR running:

1. Operate a Stream Deck+ control. It should reach SmartSDR through Bus 1.
2. Operate each HaliKey paddle. It should reach SmartSDR through RouteMIDI and Bus 2.
3. In CW mode, confirm left/right paddle operation. In a phone mode, confirm the appropriate PTT behavior for your HaliKey wiring and SmartSDR mappings.

The launcher logs RouteMIDI’s standard output and errors to `/tmp/routemidi.log` for the current boot session.
