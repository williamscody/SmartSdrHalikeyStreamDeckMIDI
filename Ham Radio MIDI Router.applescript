-- Merge HaliKey MIDI and the Stream Deck+ IAC Bus 1 into IAC Bus 2.
-- This single launcher supports both SmartSDR for Mac and AetherSDR for Mac.
-- Launch RouteMIDI invisibly and avoid duplicate router processes.
-- Tested with RouteMIDI installed by Homebrew at /opt/homebrew/bin/routemidi.

if (do shell script "pgrep -x routemidi || true") is "" then
	do shell script "/opt/homebrew/bin/routemidi in \"HaliKey MIDI\" in \"IAC Driver Bus 1\" out \"IAC Driver Bus 2\" > /tmp/routemidi.log 2>&1 &"
end if
