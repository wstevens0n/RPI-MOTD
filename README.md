# RPI-MOTD

Save as /etc/motd.tcl and add "/etc/motd.tcl" to the end of your /etc/profile
You'll also need to:
  - sudo apt-get install tcl 
  - delete the contents of /etc/motd
  - sudo chmod 755 /etc/motd.tcl
  - comment out "uname -snrvm > /var/run/motd.dynamic" in /etc/init.d/motd 
  - change "PrintLastLog yes" to "PrintLastLog no" in /etc/ssh/sshd_conf


Referenced material

Reddit Show Me Your MOTD
https://www.reddit.com/r/raspberry_pi/comments/5tqeb4/show_me_your_motd/
