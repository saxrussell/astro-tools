# the problem is that when Commander gets enough errors from the mount, it attempts to restart itself, but in doing so, it only ends up at the connection method selection modal. N.I.N.A. and PHD2
# DO NOT recognize this as a problematic state and do not attempt to fix the problem.
# 
# the intent of this script is to run from task scheduler at the desired interval to catch errors from the mount and kill the process completely.
# both N.I.N.A. and/or PHD2 will then automatically restart the commander app into a functional state.

# the default log file path in under AppData\Local. change this if you have customized the log config.
$logpath = "${env:LOCALAPPDATA}\iOptronCommander2017\logs"

# not complex logic here - just find the newest file in the logs directory
$latestLogFile = (gci "${logpath}" | sort LastWriteTime | select -last 1)

# if the latest file contains the string "ERROR: Received invalid response" on ANY LINE, take the following actions:
#   1. make a backup copy of the log file for later analysis
#   2. truncate the original log file (commander logs only roll daily, so if we don't do this, all subsequent executions will result in restarts until the next day)
#   3. kill the iOptron Commander 2017 process

if (Get-Content "${logpath}\${latestLogFile}" | select-string "ERROR: Received invalid response") {
    copy-item "${logpath}\${latestLogFile}" -Destination "${logpath}\ERROR-${latestLogFile}"
    clear-content "${logpath}\${latestLogFile}"
    get-process | where-object -Property ProcessName -eq "iOptron Commander 2017" | stop-process
}
