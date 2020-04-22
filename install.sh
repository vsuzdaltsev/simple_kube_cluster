#cloud-boothook
#!/bin/bash
systemctl disable --now apt-daily{,-upgrade}.{timer,service}
pkill -9 -f apt
rm -f /var/lib/dpkg/lock-frontend
apt-get remove unattended-upgrades

