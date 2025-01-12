logpath = "${HOME}\AppData\Local\iOptronCommander2017\logs"

latestLogFile = (gci "${logpath}" | sort LastWriteTime | select -last 1)

if (Get-Content $latestLogFile | select-string "ERROR: Received invalid response") {
    get-process | where-object -Property ProcessName -eq "iOptron Commander 2017" | stop-process
}
