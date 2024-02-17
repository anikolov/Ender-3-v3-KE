# Setting up Ender 3 v3 KE to enable sftpd on port 24
# based on the script provided by Guilouz https://github.com/Guilouz/Creality-K1-and-K1-Max

# INSTALLING entware
# Ender 3 v3 KE has MIPS architecture in little-endian flavour, so we install the MIPSEL version (mipselsf-k3.4)
# URL http://bin.entware.net/mipselsf-k3.4/installer
# mirror URL http://mirrors.bfsu.edu.cn/entware/mipselsf-k3.4/installer

rm -rf /opt /usr/data/opt
mkdir -p /usr/data/opt
ln -nsf /usr/data/opt /opt

mkdir -p /opt/bin
mkdir -p /opt/etc
mkdir -p /opt/lib/opkg
mkdir -p /opt/tmp
mkdir -p /opt/var/lock
mkdir -p /opt/

wget http://bin.entware.net/mipselsf-k3.4/installer/opkg -O /opt/bin/opkg
chmod 755 /opt/bin/opkg
wget http://bin.entware.net/mipselsf-k3.4/installer/opkg.conf -O /opt/etc/opkg.conf

/opt/bin/opkg update
/opt/bin/opkg install entware-opt

# Fix for multiuser environment
chmod 777 /opt/tmp

ln -sf /etc/passwd /opt/etc/passwd
ln -sf /etc/group /opt/etc/group
ln -sf /etc/shells /opt/etc/shells
ln -sf /etc/shadow /opt/etc/shadow
ln -sf /etc/localtime /opt/etc/localtime

# Adding /opt/bin and /opt/sbin to the start of the PATH in the system profile...
echo 'export PATH="/opt/bin:/opt/sbin:$PATH"' > /etc/profile.d/entware.sh

# Adding startup script...
echo -e '#!/bin/sh\n/opt/etc/init.d/rc.unslung "$1"' > /etc/init.d/S50unslung
chmod 755 /etc/init.d/S50unslung

# !IMPORTANT: Log out and log back in

opkg install openssh-sftp-server
opkg install openssh-server

echo "sshd:x:74:" >> /etc/group
echo "sshd:x:74:74:Privilege-separated SSH:/var:/bin/false" >> /etc/passwd

/opt/bin/ssh-keygen -f /opt/etc/ssh/ssh_host_rsa_key
/opt/bin/ssh-keygen -t ed25519 -f /opt/etc/ssh/ssh_host_ed25519_key

# test it like this in debug mode - ONLY ONE SESSION ALLOWED
/opt/sbin/sshd -d -o Port=24 -o PermitRootLogin=yes

# once it is working correctly, kill it (ctrl+c) and run it like this
/opt/sbin/sshd -o Port=24 -o PermitRootLogin=yes

# go to your sftp client and modify /opt/etc/ssh/ssh_config
# put lines:
Port 24
PermitRootLogin yes

# stop sshd and this time you should be able to run it with 
cd /opt/etc/init.d
./S40sshd start


