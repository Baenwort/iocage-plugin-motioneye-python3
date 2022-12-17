#!/bin/sh

# Install Python3 (should already be done in motioneye.json
# env ASSUME_ALWAYS_YES=YES pkg install python3

# Create symlinks for python (should already be done by python3 package
#ln -s /usr/local/bin/python3 /usr/local/bin/python3
#ln -s /usr/local/bin/python3 /usr/local/bin/python

# Install  py311-pip (should already be installed)
curl -sSfO 'https://bootstrap.pypa.io/get-pip.py'
python3 get-pip.py

# Create symlinks for pip (should not be needed any longer)
#ln -s /usr/local/bin/pip2.7 /usr/local/bin/pip-2.7

# Create symlink for sha1sum to allow file uploading to function
ln -s /usr/local/bin/shasum /usr/local/bin/sha1sum

# Install motioneye (dev branch for Python3 support. Switch when 0.43 released)
python3 -m pip install 'https://github.com/motioneye-project/motioneye/archive/dev.tar.gz'

# Enable motioneye
sysrc -f /etc/rc.conf motioneye_enable="YES"

# Create folders
mkdir /usr/local/etc/motioneye /var/{run,log,db}/motioneye 2>/dev/null
mkdir -p /usr/local/etc/motioneye /var/lib/motioneye

# Get initial configuration
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /usr/local/etc/motioneye/motioneye.conf
sed -i.old 's|^conf_path .*|conf_path /usr/local/etc/motioneye|' /usr/local/etc/motioneye/motioneye.conf
sed -i.old 's|^log_path .*|log_path /var/log/motioneye|' /usr/local/etc/motioneye/motioneye.conf
sed -i.old 's|^run_path |#run_path |' /usr/local/etc/motioneye/motioneye.conf
rm -f /usr/local/etc/motioneye/motioneye.conf.old

# Create motioneye user and group
pw useradd -q -n motioneye -c "The motioneye user" -d /nonexistent -s /sbin/nologin
chown -R motioneye:motioneye /usr/local/etc/motioneye /var/{run,log,db}/motioneye

# Start the service
service motioneye start

exit 0
