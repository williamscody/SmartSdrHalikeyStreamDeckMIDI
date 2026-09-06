-- Launch RouteMIDI invisibly and avoid duplicate router processes.
-- Tested with RouteMIDI installed by Homebrew at /opt/homebrew/bin/routemidi.

set routerProcesses to (do shell script "pgrep -x routemidi || true")

if routerProcesses is "" then
	do shell script "/opt/homebrew/bin/routemidi in \"HaliKey MIDI\" out \"IAC Driver Bus 2\" > /tmp/routemidi.log 2>&1 &"
end if
