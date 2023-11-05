# Variables (CHANGE AS NEEDED!)
$bitlockerDrive = "P:"
$backupFolder = "P:\WindowsImageBackup"
$recoveryKey = "insert bitlocker recovery key of external drive here"
$logFilePath = "C:\temp\BackupLogs\BackupLog.txt"

# Start logging
Start-Transcript -Path $logFilePath -Append

# 1. Unencrypt the BitLocker-encrypyed drive
Unlock-BitLocker -MountPoint $bitlockerDrive -RecoveryPassword $recoveryKey

# 2. Delete previous backup
Remove-Item -Path $backupFolder -Recurse -Force

# 3. Take a full backup and write it to the external drive 
wbadmin start backup -backupTarget:P: -include:C:,F: -quiet -allCritical -vssCopy

# 4. Re-encrypt the drive
sleep 10 # 10 second grace period in case any processes need to finish up
Lock-BitLocker -MountPoint $bitlockerDrive

# Stop logging
Stop-Transcript
