# astro-tools
collection of scripts and whatnot that have helped solve problems with astrophotography software

## restart_commander.ps1

### The problem

I run a iOptron CEM70G on a pier at a remote observatory. At varying intervals, the `iOptron Commander 2017` app (which is a combination of UI and ASCOM driver) will start logging `ERROR: Received invalid response:` and attempt to restart itself after enough of them accumulate in a given time span. The problem is that it restarts to the connection selection modal rather than reestablishish a functional connection that is usable by control software (N.I.N.A. and PHD2, in my case). The other side of the problem is that N.I.N.A. and PHD2, while they have functionality to automatically restart the failed Commander app, DO NOT recognize this state as problematic and take no action to correct it. When the app is in this state, neither N.I.N.A. nor PHD2 can send slew commands which, as most astrophotographers know, means, in the best case, a bunch of bad frames and lost time or, in the worst case, crashing your very expensive rig into a pier or tripod. I've been fortunate to avoid the latter, but I've lost at least 100 hours worth of subs to this issue over the last 6 months.

Also, I never had this problem when running the mount at home and recognize that something could have been jostled loose during transport to the observatory, but consider this to be unlikely as I transported the equipment myself and the whole trip was extremely smooth.

Since functionality can be correctly restored (in most cases) by fully stopping and restarting the Commander application, I've cobbled together a very simple script to do so when errors are found in the Commander logs.

Before reaching this point, I have tried everything short of sending the mount to iOptron for service. Most of the various testimonials I've read indicate that such service calls can take weeks or months to complete and I am highly resistant to the idea of paying monthly pier rent for an unusable rig. Given the popularity of said observatory, the wait list for a pier is also quite long and I'm not inclined to lose the pier I currently occupy. Solutions I tried:

* Replaced the stock 5A CEM70G power supply with a 10A aftermarket unit
* Replaced the generic power strip I originally had installed with a heavier-duty/higher-capacity one.
* Replaced all USB cables with the shortest possible versions (this is related to another problem where the USB connection dies after a few minutes and becomes unusable)
* Tried [every version of Commander]{https://www.ioptron.com/Articles.asp?ID=337} all the way back to v6.4.0 and had this issue with all of them
* Followed [the instructions]{https://www.ioptron.com/v/ASCOM/Commander_Not_Start.pdf} to whitelist the Commander files in Windows security/antivirus
* Set the Commander application to always run as administrator
* Upgraded the mount firmware to the latest version (V230305)
* Installed the FTDI driver specific to Windows 11
* Offered blood sacrifices to the old gods

...and continue to have these problems. I've worked around the USB problem by operating the mount over its WiFi connection which, aside from the errors causing the app fault, has worked a treat. So after all that, I banged out a few sloppy lines of powershell and run it as a scheduled task every 5 minutes.

This solution works for me and it might work for you, too, but is not a professional product and does not come with any guarantees, support, or warranty. Feel free to use it, but do so at your own risk.
