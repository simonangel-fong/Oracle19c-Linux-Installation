#!/bin/bash
# Created at: 2024/10/28 03:24
# Created by: Wenhao Fang
# Last modified at: 2024/10/28 03:24
# Description: This script automates the pre-installation and configuration steps required to set up Oracle Database 19c on a Linux server.
# Run the script as the root.

ORACLE_USER_PWD='Simon!23' # pwd of oracle user

# sudo yum upgrade -y
# echo $'\nUpdated packages.\n'

# install package for 19c
sudo yum install -y oracle-database-preinstall-19c
# verify installation
id oracle # package will create a user oracle with different groups
echo $'\nInstalled package for 19c.\n'

# Set the password for the oracle user
echo "$ORACLE_USER_PWD" | sudo passwd --stdin oracle
echo $'\nChanged user oralce password.\n'

# create directory where the Oracle software will be installed
sudo mkdir -p /u01/app/oracle/product/19.0.0/dbhome_1
sudo mkdir -p /u02/oradata

# Change ownership of directories to user oracle and group oinstall
sudo chown -R oracle:oinstall /u01 /u02

# Change permission of directories
# owner and group can read, write, and execute.
# others can read and execute, but cannot write.
chmod -R 775 /u01 /u02
echo $'\nCreated directories.\n'

# Create a "scripts" directory.
sudo mkdir /home/oracle/scripts

# Create an environment file called "setEnv.sh".
sudo cat >/home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=localhost.localdomain
export ORACLE_UNQNAME=orcl
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/19.0.0/dbhome_1
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=orcl
export PDB_NAME=pdb1
export DATA_DIR=/u02/oradata

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib
EOF

# Add a reference to the “setEnv.sh” file at the end of the “/home/oracle/.bash_profile” file.
echo ". /home/oracle/scripts/setEnv.sh" >>/home/oracle/.bash_profile

echo $'\nCreated Environment variables.\n'

# Create a “start_all.sh” and “stop_all.sh” script that can be called from a startup/shutdown service.
cat >/home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME
EOF

echo $'\nCreated start_all.sh.\n'

cat >/home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF

echo $'\nCreated stop_all.sh.\n'

# Make sure the ownership and permissions are correct.
sudo chown -R oracle:oinstall /home/oracle/scripts
sudo chmod u+x /home/oracle/scripts/*.sh

echo $'\nPre-installation completed.\n'
