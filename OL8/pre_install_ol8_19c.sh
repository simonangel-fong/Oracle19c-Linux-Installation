#!/bin/bash
# Created at: 2024/10/29 10:31
# Created by: Wenhao Fang
# Last modified at: 2024/10/29 10:31
# Description: This script automates the pre-installation and configuration steps required to set up Oracle Database 19c on a Linux server.
# Run the script as the root.

ORACLE_USER_PWD='Simon!23' # pwd of oracle user

# sudo dnf update -y
# echo $'\nUpdated packages.\n'

# install package for 19c
sudo dnf install -y oracle-database-preinstall-19c
# verify installation
id oracle # package will create a user oracle with different groups

echo "$ORACLE_USER_PWD" | sudo passwd --stdin oracle

sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Create the directories in which the Oracle software will be installed.

sudo mkdir -p /u01/app/oracle/product/19.0.0/dbhome_1
sudo mkdir -p /u02/oradata
sudo chown -R oracle:oinstall /u01 /u02
sudo chmod -R 775 /u01 /u02

sudo mkdir /home/oracle/scripts

sudo tee /home/oracle/scripts/setEnv.sh >/dev/null <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=ol9-19.localdomain
export ORACLE_UNQNAME=cdb
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/19.0.0/dbhome_1
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=cdb
export PDB_NAME=pdb1
export DATA_DIR=/u02/oradata

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

echo ". /home/oracle/scripts/setEnv.sh" | sudo tee -a /home/oracle/.bash_profile >/dev/null

sudo tee /home/oracle/scripts/start_all.sh >/dev/null <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME
EOF

sudo tee /home/oracle/scripts/stop_all.sh >/dev/null <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF

sudo chown -R oracle:oinstall /home/oracle/scripts
sudo chmod u+x /home/oracle/scripts/setEnv.sh
sudo chmod u+x /home/oracle/scripts/start_all.sh
sudo chmod u+x /home/oracle/scripts/stop_all.sh
