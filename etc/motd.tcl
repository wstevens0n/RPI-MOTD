#!/usr/bin/env tclsh
# MOTD script original? / mod mewbies.com

# Save as /etc/motd.tcl and add "/etc/motd.tcl" to the end of your /etc/profile
# You'll also need to:
#   - sudo apt-get install tcl 
#   - delete the contents of /etc/motd
#   - sudo chmod 755 /etc/motd.tcl
#   - comment out "uname -snrvm > /var/run/motd.dynamic" in /etc/init.d/motd 
#   - change "PrintLastLog yes" to "PrintLastLog no" in /etc/ssh/sshd_config

# * Variables
set var(user) $env(USER)
set var(path) $env(PWD)
set var(home) $env(HOME)

# * Check if we're somewhere in /home
if {![string match -nocase "/home*" $var(path)] && ![string match -nocase "/usr/home*" $var(path)] } {
  return 0
}

# * Calculate last login
set lastlog [exec -- lastlog -u $var(user)]
set ll(1)  [lindex $lastlog 7]
set ll(2)  [lindex $lastlog 8]
set ll(3)  [lindex $lastlog 9]
set ll(4)  [lindex $lastlog 10]
set ll(5)  [lindex $lastlog 6]


# * Calculate current system uptime
set uptime    [exec -- /usr/bin/cut -d. -f1 /proc/uptime]
set up(days)  [expr {$uptime/60/60/24}]
set up(hours) [expr {$uptime/60/60%24}]
set up(mins)  [expr {$uptime/60%60}]
set up(secs)  [expr {$uptime%60}]

# * Calculate usage of home directory
set usage [lindex [exec -- /usr/bin/du -ms $var(home)] 0]
set total_disk [lindex [exec -- df -H | grep "/dev/root" | cut -c18-21] 0]
set system_usage [lindex [exec -- df -H | grep "/dev/root" | cut -c22-27] 0]


# * Calculate SSH logins:
set logins    [lindex [exec -- who -q | grep "users" | cut -c9-10] 0]

# * Calculate processes
set psu [lindex [exec -- ps U $var(user) h | wc -l] 0]
set psa [lindex [exec -- ps -A h | wc -l] 0]

# * Calculate current system load
set loadavg     [exec -- /bin/cat /proc/loadavg]
set sysload(1)  [lindex $loadavg 0]
set sysload(5)  [lindex $loadavg 1]
set sysload(15) [lindex $loadavg 2]

# * Calculate Memory
set memory  [exec -- free -m]
set mem_total  [lindex $memory 7]
set mem(u)  [lindex $memory 8]
set mem(f)  [lindex $memory 9]
set mem(c)  [lindex $memory 16]
set mem(s)  [lindex $memory 19]
set mem_nf [expr {($mem_total - $mem(c))}]
set mem_percentage  [expr {($mem_nf*100)/$mem_total}]

# * display kernel version
set uname [exec -- /bin/uname -snrvm]
set unameoutput0 [lindex $uname 0]
set unameoutput [lindex $uname 1]
set unameoutput2 [lindex $uname 2]
set unameoutput3 [lindex $uname 3]
set unameoutput4 [lindex $uname 4]

# * boarderline
set boarderLine {━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━}
set boarderBlank {┃                                                                         ┃}
set boarderTopLeft {┏}
set boarderTopRight {┓}
set boarderBottomLeft {┗}
set boarderBottomRight {┛}

# * ascii leaf
set leaf1 {       .~~.   .~~.                                                       }
set leaf2 {      '. \ ' ' / .'                                                      }

# * ascii berry
set head1 {       .~ .~~~..~.                      _                          _     }
set head2 {      : .~.'~'.~. :     ___ ___ ___ ___| |_ ___ ___ ___ _ _    ___|_|    }
set head3 {     ~ (   ) (   ) ~   |  _| .'|_ -| . | . | -_|  _|  _| | |  | . | |    }
set head4 {    ( : '~'.~.'~' : )  |_| |__,|___|  _|___|___|_| |_| |_  |  |  _|_|    }
set head5 {     ~ .~ (   ) ~. ~               |_|                 |___|  |_|        }
set head6 {      (  : '~' :  )                                                      }
set head7 {       '~ .~~~. ~'                                                       }
set head8 {           '~'                                                           }

# * Print Results
puts "\033\[00;35;5;35m$boarderTopLeft$boarderLine$boarderTopRight"
puts "\033\[00;35;5;35m$boarderBlank"
puts "\033\[00;35;5;35m┃\033\[00;32;5;32m$leaf1\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;32;5;32m$leaf2\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head1\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head2\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head3\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head4\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head5\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head6\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head7\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;31;5;31m$head8\033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Name.........:\033\[00;33;5;33m $unameoutput                                            \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   System.......:\033\[00;33;5;33m $unameoutput0 $unameoutput $unameoutput2 $unameoutput3 $unameoutput4                  \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Last Login...:\033\[00;33;5;33m $ll(1) $ll(2) $ll(3) $ll(4) from $ll(5)                  \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Uptime.......:\033\[00;33;5;33m $up(days) days $up(hours) hours $up(mins) minutes $up(secs) seconds                    \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Load.........:\033\[00;33;5;33m $sysload(1) (1 minute) $sysload(5) (5 minutes) $sysload(15) (15 minutes)     \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Memory.......:\033\[00;33;5;33m $mem_percentage%  Total: ${mem_total}M Free: $mem(f)M Cached: $mem(c)M  Swap: $mem(s)M     \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Disk Usage...:\033\[00;33;5;33m Using ${usage}M out of ${total_disk}, System usage is ${system_usage}            \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   SSH Logins...:\033\[00;33;5;33m Currently $logins user(s) logged in.                         \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m┃\033\[00;38;5;36m   Processes....:\033\[00;33;5;33m Running ${psu}, Total Running: ${psa}                         \033\[00;35;5;35m┃"
puts "\033\[00;35;5;35m$boarderBlank"
puts "\033\[00;35;5;35m$boarderBottomLeft$boarderLine$boarderBottomRight"

if {[file exists /etc/changelog]&&[file readable /etc/changelog]} {
  puts " . .. More or less important system informations:\n"
  set fp [open /etc/changelog]
  while {-1!=[gets $fp line]} {
    puts "  ..) $line"
  }
  close $fp
  puts ""
}
