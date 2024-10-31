#!/bin/bash
# Created at: 2024/10/29 10:31
# Created by: Wenhao Fang
# Last modified at: 2024/10/29 10:31
# Description: This script automates the installation of Oracle 19c in silent mode.
# Run the script as the oracle.

su - oracle

# verify
echo $ORACLE_HOME # /u01/app/oracle/product/19.0.0/dbhome_1

# Unzip software.
cd $ORACLE_HOME
unzip -oq /home/oracle/LINUX.X64_193000_db_home.zip
unzip -t /home/oracle/LINUX.X64_193000_db_home.zip

# Fake Oracle Linux 7.
export CV_ASSUME_DISTID=OEL7.6

# Silent mode.
./runInstaller -ignorePrereq -waitforcompletion -silent \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp \
    oracle.install.option=INSTALL_DB_SWONLY \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME} \
    UNIX_GROUP_NAME=oinstall \
    INVENTORY_LOCATION=${ORA_INVENTORY} \
    SELECTED_LANGUAGES=en,en_GB \
    ORACLE_HOME=${ORACLE_HOME} \
    ORACLE_BASE=${ORACLE_BASE} \
    oracle.install.db.InstallEdition=EE \
    oracle.install.db.OSDBA_GROUP=dba \
    oracle.install.db.OSBACKUPDBA_GROUP=dba \
    oracle.install.db.OSDGDBA_GROUP=dba \
    oracle.install.db.OSKMDBA_GROUP=dba \
    oracle.install.db.OSRACDBA_GROUP=dba \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
    DECLINE_SECURITY_UPDATES=true
