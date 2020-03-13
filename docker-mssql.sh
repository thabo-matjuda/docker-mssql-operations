#!/usr/bin/env bash
    
 # @author: Thabo Lebogang Matjuda
 # @since: 2020-03-10
 # @email: <a href="mailto:thabo@anylytical.co.za">Anylytical Technologies</a> 
 #         <a href="mailto:tl.matjuda@gmail.com">Personal GMail</a>
  


# ===========================================================================================================
# CONFIGURATIONS

# Don't change these

# Uncomment for [ Bash ] Get the current script path
# DOCKER_MSSQL_SERVER_SHELL_SCRIPT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

# Uncomment for [ ZSH ] Get the current script path
DOCKER_MSSQL_SERVER_SHELL_SCRIPT_PATH=${0:a:h}

# Change these for your environment
MSSQL_HOME_DIR="/var/opt/mssql/data"
MSSQL_CONTAINER_NAME="mssql-server-2017"
MSSQL_SERVER_IP="localhost"
MSSQL_SERVER_PORT="1433"
MSSQL_SA_USERNAME="SA"
MSSQL_SA_PASSWORD="exe1Hou!"
# ===========================================================================================================


# Copy file [ TO ] the home path of SQL On the container.
# Example :
#   dockerMSSQLCopyToVM /the/file/you/want/to/copy.bak
function dockerMSSQLCopyToVM() {
    sourceFilePath=$1
    docker cp $sourceFilePath $MSSQL_CONTAINER_NAME:$MSSQL_HOME_DIR
}


# Copy file [ FROM ] the home path of SQL On the container.
# Example :
#   dockerMSSQLCopyFromVM nameOfFileThatsOnDocker.bak ~/Downloads
function dockerMSSQLCopyFromVM() {
    fileName=$1
    destinationFilePath=$2
    docker cp $MSSQL_CONTAINER_NAME:$MSSQL_HOME_DIR"/"$fileName $destinationFilePath
}


# [ 1 ] - full file path including file name to remove
function dockerRemoveFileFromContainer() {
    pathOfFileToRemove=$1
    docker exec $MSSQL_CONTAINER_NAME rm -rf $pathOfFileToRemove
}


# ===========================================================================================================
# Used to [ BACKUP ] the database.
# Example :
#   dockerMSSQLBackupDatabase AlimdaadSystem BackupFilePrefix
function dockerMSSQLBackupDatabase() {

    # Validate that we have our parameters.
    if [[ -n $1 || -n $2 ]]; then
        databaseName=$1                                    # The MS SQL Server Database you want to back up.
        backupDate=$(date +%F)                             # Get the current date of the file.
        fileName=$2"_"$backupDate".bak"                    # Final name with the extention and date appended to it.
        completeBackupFilePath=$MSSQL_HOME_DIR"/"$fileName # Complete path where to store the result backup file.

        # Time to execute the command against the docker container
        # This is to run the
        echo "[ Docker Backup ] Backing up your file to $completeBackupFilePath ..."
        docker exec -it $MSSQL_CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd \
            -S $MSSQL_SERVER_IP \
            -U $MSSQL_SA_USERNAME \
            -P $MSSQL_SA_PASSWORD \
            -Q '
        BACKUP DATABASE '${databaseName}'
        TO DISK = '\'$completeBackupFilePath\''
        WITH FORMAT, INIT,
        MEDIANAME = '\'$databaseName\'' ,
        NAME = '\'$databaseName\'',
        SKIP, REWIND, NOUNLOAD,  STATS = 10'

        # Call the copy function to copy the backup to my local machine into the Downloads folder.
        echo "[ Docker Backup ] Downloading your $fileName ... "
        dockerMSSQLCopyFromVM $fileName $HOME/Downloads

        # Then remove the file we have just copied over to docker
        dockerRemoveFileFromContainer $MSSQL_CONTAINER_NAME $completeBackupFilePath
        echo "[ Docker Backup ] Backup complete!"
    else
        echo "[ERROR] Please pass parameters (arg1) = [DatabaseName] and also the (arg 2) = [FileNamePrefix]"
    fi
}


# Used to [ RESTORE ] the backup file.
# Example :
#   dockerMSSQLRestoreDatabase AlimdaadSystem /path/to/your/BackupFile.bak
function dockerMSSQLRestoreDatabase() {

    # Validate that we have our parameters.
    if [[ -n $1 || -n $2 ]]; then
        databaseName=$1     # The MS SQL Server Database to restore to.
        backupFilePath=$2   # Get the full path of the source backup file
        backupFileName=$2:t # File name and extension to restore from

        # Copy the back up file to the docker machine
        echo "[ Docker Restore ] Copying your file $backupFileName over to your container ..."
        dockerMSSQLCopyToVM $backupFilePath

        # This will be where the docker will backup from after copying the file over to docker
        dockerBackupFilePath=$MSSQL_HOME_DIR"/"$backupFileName

        # Time to execute the command against the docker container
        # This is to run the MSSQL Statement to restore our database now that we have all the info we need
        echo "[ Docker Restore ] Now restoring from $dockerBackupFilePath ..."

        docker exec -it $MSSQL_CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd \
            -S $MSSQL_SERVER_IP \
            -U $MSSQL_SA_USERNAME \
            -P $MSSQL_SA_PASSWORD \
            -Q '
            RESTORE DATABASE '${databaseName}'
            FROM DISK = '\'$dockerBackupFilePath\''
            WITH REPLACE,
            NOUNLOAD,
            STATS = 5'

        # Then remove the file we have just copied over to docker
        echo "[ Docker Restore ] Removing your backup from the container "
        dockerRemoveFileFromContainer $MSSQL_CONTAINER_NAME $dockerBackupFilePath
        echo "[ Docker Restore ] Restore complete!"
    else
        echo "[ERROR] Please pass parameters (arg1) = [DatabaseName] and also the (arg 2) = [/backup/file/fle/path.bak]"
    fi
}