#!/usr/bin/env bash
    
 # @author: Thabo Lebogang Matjuda
 # @since: 2020-03-10
 # @email: <a href="mailto:thabo@anylytical.co.za">Anylytical Technologies</a> 
 #         <a href="mailto:tl.matjuda@gmail.com">Personal GMail</a>
  


# ===========================================================================================================
# CONFIGURATIONS

# Don't change these

# Uncomment for [ Bash ] Get the current script path
DOCKER_MSSQL_SERVER_SHELL_SCRIPT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

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