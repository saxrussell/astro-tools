# the problem is that when Commander gets enough errors from the mount, it attempts to restart itself, but in doing so, it only ends up at the connection method selection modal. N.I.N.A. and PHD2
# DO NOT recognize this as a problematic state and do not attempt to fix the problem.
# 
# the intent of this script is to run from task scheduler at the desired interval to catch errors from the mount and kill the process completely.
# both N.I.N.A. and/or PHD2 will then automatically restart the commander app into a functional state. in some cases, though, that won't happen - usually when Commander is started independently/manually rather than by one or the other application attempting a connection. In that case, the script will determine if Commander is not running and then start it directly.

$commander_dir = "${env:LOCALAPPDATA}\iOptronCommander2017" 

# the default log file path in under AppData\Local. change this if you have customized the log config.
$logpath = "${commander_dir}\logs"

# not complex logic here - just find the newest file in the logs directory
$latestLogFile = (gci "${logpath}" | sort LastWriteTime | select -last 1)

# if the latest file contains the string "ERROR: Received invalid response" on ANY LINE
if (Get-Content "${logpath}\${latestLogFile}" | select-string "ERROR: Received invalid response") {
    # make a backup copy of the log file for later analysis
    copy-item "${logpath}\${latestLogFile}" -Destination "${logpath}\ERROR-${latestLogFile}"

    # truncate the original log file (commander logs only roll daily, so if we don't do this, all subsequent executions will result in restarts until the next day)
    clear-content "${logpath}\${latestLogFile}"
    
    # kill the iOptron Commander 2017 process
    get-process | where-object -Property ProcessName -eq "iOptron Commander 2017" | stop-process
    
    # wait to see if N.I.N.A. restarts it on its own
    start-sleep -seconds 10

    # check if the new process is running
    $new_proc = (get-process | where-object -Property ProcessName -eq "iOptron Commander 2017")

    # if so, great! exit without any further action
    if ($new_proc) {
        exit 0
    # if not, go start it directly
    } else {
        cd ${commander_dir}
        invoke-item "${commander_dir}\iOptron Commander 2017.exe"
    }
}
