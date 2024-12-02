#!/bin/bash

echo
echo "This script needs to be run as 'root' user"
echo
echo "Please switch to your 'la-UserID' (Ex. la-skodinariya) account and then 'sudo su' to become 'root' "
echo

if [ "`whoami`" != "root" ]
then
        echo "This script needs to be run as 'root' user, please switch the accounts and run again"
        echo
        exit
else

 # Installing wazuh agent on ATS domain joined Ubuntu systems

 cd /usr/local/src

 echo
 echo "Installing Wazuh Agent"
 echo

 curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

 echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list

 apt-get update

 WAZUH_MANAGER="wazuh.peratonlabs.com" WAZUH_REGISTRATION_SERVER="wazuh.peratonlabs.com" WAZUH_REGISTRATION_PASSWORD="Ftl6QHdOrKEJ7Oqlp21wmfIGbb73nkp5" WAZUH_AGENT_GROUP="ats-ubuntu" apt-get install wazuh-agent -y

 echo "wazuh-agent hold" | dpkg --set-selections

 systemctl daemon-reload
 systemctl enable wazuh-agent
 systemctl start wazuh-agent

 # Installing ocs inventory agent

 echo
 echo "Installing dependency packages for OCS inventory"
 echo

 apt install -y make gcc libmodule-install-perl dmidecode libxml-simple-perl libcompress-zlib-perl openssl libnet-ip-perl libwww-perl libdigest-md5-perl libdata-uuid-perl libcrypt-ssleay-perl libnet-snmp-perl libproc-pid-file-perl libproc-daemon-perl net-tools libsys-syslog-perl pciutils smartmontools read-edid nmap libnet-netmask-perl

 echo "Downloading Ocsinventory file"

 wget https://github.com/OCSInventory-NG/UnixAgent/releases/download/v2.10.2/Ocsinventory-Unix-Agent-2.10.2.tar.gz

 echo "installing Ocsinventory Agent"


 chown root:root Ocsinventory-Unix-Agent-2.10.2.tar.gz
 tar xzf Ocsinventory-Unix-Agent-2.10.2.tar.gz
 chown -R root:root Ocsinventory-Unix-Agent-2.10.2
 cd Ocsinventory-Unix-Agent-2.10.2
 env PERL_AUTOINSTALL=1 perl Makefile.PL
 make; make install

 echo "Running OcsInventory Agent"

# ocsinventory-agent --nosoftware --server http://ocs.peratonlabs.com/ocsinventory

 echo "Updating crontab to run OcsInventory Agent"

 # Set random time between 10:00 to 15:59
 hr=$(( RANDOM % 6 + 10 ))  # 10, 11, 12, 13, 14, 15
 min=$(( RANDOM % 60 ))     # 0 to 59

 crontab <<EOF
# Creating Base Crontab
EOF
 if ! crontab -l | grep -q "ocsinventory"; then
        echo "$min $hr * * 1-5 /usr/local/src/Ocsinventory-Unix-Agent-2.10.2/ocsinventory-agent --nosoftware --server http://ocs.peratonlabs.com/ocsinventory" | crontab -
 fi

fi
