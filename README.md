# Docker MS SQL Server Operations 
---

A collection that contains some of the common operations on a MSSQL Service that's running on Docker. This is also based on the article, **[Dokcer Operations For MSSQL Server](https://informingtechies.blogspot.com/2020/03/micro-services-using-thorntail.html)** which gives you insight on what's happening in the script. 


## Technologies & Tools Stack Used

1. Unix Shell (Bash / ZSH)
2. Maven 3.6.2
3. IntelliJ IDEA *(You may use an IDE of your choice)*


## Setting Up

```bash
# import the scipt on your terminal
source ~/where-ever/you/cloned/the/script/docker-mssql.sh
```


## Testing                     

```bash
# Backing Up 
dockerMSSQLBackupDatabase DatabaseName BackupFilePrefix

# Restoring
dockerMSSQLRestoreDatabase DatabaseName /path/to/your/BackupFile.bak
```

All Done! Enjoy.
