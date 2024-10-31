#!/bin/bash
# Created at: 2024/10/28 03:31
# Created by: Wenhao Fang
# Last modified at: 2024/10/28 03:31
# Description: This script creates the databases in 19c.
# Important: Run the script as the oracle. It might take time.

su - oracle

GDB_SYS_PWD='welcome1'
GDB_SYSTEM_PWD='welcome1'
PDB_ADMIN_PWD='welcome1'

# Database Creation
# Silent mode.
dbca -silent -createDatabase \
    -templateName General_Purpose.dbc \
    -gdbname ${ORACLE_SID} -sid ${ORACLE_SID} -responseFile NO_VALUE \
    -characterSet AL32UTF8 \
    -sysPassword ${GDB_SYS_PWD} \
    -systemPassword ${GDB_SYSTEM_PWD} \
    -createAsContainerDatabase true \
    -numberOfPDBs 1 \
    -pdbName ${PDB_NAME} \
    -pdbAdminPassword ${PDB_ADMIN_PWD} \
    -databaseType MULTIPURPOSE \
    -memoryMgmtType auto_sga \
    -totalMemory 2000 \
    -storageType FS \
    -datafileDestination "${DATA_DIR}" \
    -redoLogFileSize 50 \
    -emConfiguration NONE \
    -ignorePreReqs

lsnrctl start