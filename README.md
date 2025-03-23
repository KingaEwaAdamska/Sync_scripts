# Sync_scripts


These scripts are used for synchronizing files between my PC and notebook using an encrypted folder on Google Drive.  

The scripts require **rclone** (properly configured). You can find setup instructions [here](https://rclone.org/drive/), as well as **Unison** for synchronization.  

## How It Works  

Synchronization is based on two directories in your home folder:  

- `sync_directory` – The local folder where you store files that should be kept in sync across both devices.  
- `rclone_sync` – The mount point for your encrypted Google Drive, used during synchronization.  

## ⚠ Warning  

This script performs **one-way synchronization**:  
- Running `sync_begin` will **overwrite or delete files** on the current device to match the remote storage.  
- Running `sync_end` will **overwrite or delete files** on the remote disk to match the local storage.  

Use with caution to avoid accidental data loss! 