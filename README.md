# SmartSDR for Mac + HaliKey MIDI + Stream Deck+ (or Stream Deck)

Use a HaliKey MIDI keyer and a Stream Deck+ together with SmartSDR for Mac by routing each source through a separate macOS IAC bus. The included launcher now uses the merged route also verified with AetherSDR for Mac, so one startup application satisfies both radios.

This is a tested, practical configuration for a Mac where the Stream Deck+ is already sending MIDI to `IAC Driver Bus 1`. It adds HaliKey MIDI on `IAC Driver Bus 2` without changing the Stream Deck configuration.

> **Key discovery:** Selecting **IAC Driver** in SmartSDR receives MIDI arriving through both `IAC Driver Bus 1` and `IAC Driver Bus 2`. SmartSDR does not need a separate MIDI-device selection for each bus.

## Architecture

```text
HaliKey MIDI ───────────┐
                        ├── RouteMIDI ──→ IAC Driver Bus 2 ──→ AetherSDR
Stream Deck+ → Bus 1 ───┘                                      (Bus 2)
       │
       └──────────────────────────→ SmartSDR for Mac (IAC Driver)
```

`IAC Driver Bus 1` remains the Stream Deck+ destination. RouteMIDI merges HaliKey MIDI and Bus 1 into `IAC Driver Bus 2`. macOS presents both buses under the IAC Driver device that SmartSDR uses, while AetherSDR receives the merged traffic on Bus 2.

## What this solves

HaliKey MIDI normally works as a direct SmartSDR MIDI controller. That is the right choice when it is the only controller. In the tested setup, the Stream Deck+ already uses an IAC bus, so this configuration keeps both controllers available through SmartSDR’s single **IAC Driver** device choice.

It is specifically for **HaliKey MIDI**, not HaliKey Serial.

## Quick setup

1. In **Audio MIDI Setup**, enable the IAC Driver and create/enable:
   - `Bus 1` for Stream Deck+
   - `Bus 2` for HaliKey MIDI
2. Keep the Stream Deck+ MIDI destination set to **IAC Driver Bus 1**.
3. In SmartSDR for Mac, select **IAC Driver** as the MIDI device.
4. Install RouteMIDI and start this exact merged route:

   ```bash
   routemidi in "HaliKey MIDI" in "IAC Driver Bus 1" out "IAC Driver Bus 2"
   ```

5. Use the included background AppleScript application to launch that route automatically, without a Terminal window. It supports both SmartSDR for Mac and AetherSDR for Mac.

See [INSTALL.md](INSTALL.md) for the complete procedure and [TROUBLESHOOTING.md](TROUBLESHOOTING.md) if a controller does not respond.

## HaliKey event mappings

The current HaliKey MIDI guide identifies these button-event mappings for SmartSDR:

| Code/control | SmartSDR action |
| --- | --- |
| 20 | Trigger CW left paddle |
| 21 | Trigger CW right paddle |
| 31 | PTT Push |

Map the actions in SmartSDR’s MIDI mapping editor as appropriate for the controller configuration. The tested route forwards these events unchanged; it does not translate or filter them.

## Why RouteMIDI `vout` is not used

RouteMIDI can create a virtual output with `vout`. It is useful for software that can select that virtual endpoint directly. In this tested SmartSDR configuration, the working device selection is **IAC Driver**; the HaliKey is therefore forwarded to the existing macOS IAC bus with `out "IAC Driver Bus 2"`. Do not select a RouteMIDI virtual port as the SmartSDR device for this setup.

## Included launcher

[`Ham Radio MIDI Router.applescript`](Ham%20Radio%20MIDI%20Router.applescript) starts RouteMIDI in the background and prevents a second `routemidi` process from being launched accidentally. The tested Homebrew executable path is `/opt/homebrew/bin/routemidi`.

## Tested configuration

This arrangement was functionally tested with:

- macOS IAC Driver, with Bus 1 for Stream Deck+ and Bus 2 for HaliKey MIDI
- SmartSDR for Mac, MIDI device set to `IAC Driver`
- HaliKey MIDI
- Stream Deck+
- RouteMIDI 0.9.10
- RouteMIDI command: `routemidi in "HaliKey MIDI" in "IAC Driver Bus 1" out "IAC Driver Bus 2"`

The test verified that HaliKey and Stream Deck+ events controlled both SmartSDR for Mac and AetherSDR for Mac. Hardware, macOS, radio software, Stream Deck plug-in, and RouteMIDI releases can change; retest after major updates.

## References

- [RouteMIDI documentation](https://github.com/gbevin/RouteMIDI) — routing syntax, existing ports, and virtual MIDI ports.
- [HaliKey product page](https://electronics.halibut.com/product/halikey/) — HaliKey MIDI compatibility and documentation.
- [HaliKey User Guide (PDF)](https://halibut-electronics.github.io/HaliKey/User%20Guide.pdf) — HaliKey MIDI events and SmartSDR mapping guidance.

## License

This project is available under the [MIT License](LICENSE).
