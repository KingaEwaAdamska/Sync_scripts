#!/bin/bash

# Settings
REMOTE="Crypted_Gdrive_name:/sync/"                # Change Remote_name to the name of your rclone disk
MOUNT_POINT="/home/username/rclone_sync"           # Mount point
LOCAL_SYNC_DIRECTORY="/home/username/sync_directory"  # Local folder for synchronization
PING_TARGET="8.8.8.8"                              # Address to check internet connection

check_internet() {
    echo "Checking internet connection..."
    if ping -c 1 "$PING_TARGET" &> /dev/null; then
        echo "Internet connection OK."
        return 0
    else
        echo "No internet connection. Syncing locally..."
        return 1
    fi
}

if check_internet; then
    # Internet is available, proceed with mounting and remote sync

    # Check if the mount point exists
    if [ ! -d "$MOUNT_POINT" ]; then
        echo "Creating mount point: $MOUNT_POINT"
        mkdir -p "$MOUNT_POINT"
    fi

    # Mount the folder with Rclone
    echo "Mounting $REMOTE in $MOUNT_POINT..."
    rclone mount "$REMOTE" "$MOUNT_POINT" --daemon

    # Check if mounting was successful
    if mount | grep "$MOUNT_POINT" > /dev/null; then
        echo "Folder mounted successfully."
    else
        echo "Error mounting $REMOTE."
        exit 1
    fi

    # Synchronize using Unison (remote sync)
    echo "Synchronizing with the local directory $LOCAL_SYNC_DIRECTORY..."
    unison "$MOUNT_POINT" "$LOCAL_SYNC_DIRECTORY" -batch -confirmbigdel -auto -force "$MOUNT_POINT"

    # Unmount the folder
    echo "Unmounting $MOUNT_POINT..."
    fusermount3 -u "$MOUNT_POINT"

    echo "Operation completed successfully."
else
    # No internet, perform local sync only
    echo "Performing local synchronization..."
    unison "$LOCAL_SYNC_DIRECTORY" -batch -auto

    echo "Local sync completed successfully."
fi
