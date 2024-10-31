#!/bin/bash
# Created at: 2024/10/28 03:30
# Created by: Wenhao Fang
# Last modified at: 2024/10/28 03:30
# Description: This script run the script after installing 19c.
# Run the script as the root.

su - root
. /u01/app/oraInventory/orainstRoot.sh
. /u01/app/oracle/product/19.0.0/dbhome_1/root.sh

firewall-cmd --zone=public --add-port=1521/tcp --permanent
firewall-cmd --reload

firewall-cmd --list-all
