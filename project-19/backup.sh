#!/bin/bash

BUCKET="likitha-project19-backup-590507089733"
SOURCE="$HOME/project/project-19/logs/system.log"
DATE=$(date +%Y-%m-%d-%H-%M-%S)

aws s3 cp "$SOURCE" "s3://$BUCKET/backups/system-$DATE.log"

if [ $? -eq 0 ]; then
    echo "Backup uploaded successfully at $(date)"
else
    echo "Backup upload failed at $(date)"
fi
