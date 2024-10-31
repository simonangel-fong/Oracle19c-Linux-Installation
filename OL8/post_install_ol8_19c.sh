#!/bin/bash
# Created at: 2024/10/29 10:31
# Created by: Wenhao Fang
# Last modified at: 2024/10/29 10:31
# Description: This script run the script after installing 19c.
# Run the script as the root.

su - root
sudo bash /u01/app/oraInventory/orainstRoot.sh
sudo bash /u01/app/oracle/product/19.0.0/dbhome_1/root.sh

sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=1521/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
