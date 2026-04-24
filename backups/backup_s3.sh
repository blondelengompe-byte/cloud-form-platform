#!/bin/sh

# Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/backups"
S3_PATH="s3://${S3_BUCKET_NAME}/manual"
mkdir -p ${BACKUP_DIR}

echo "Starting backup at ${TIMESTAMP}..."

# 1. Database Backup
export PGPASSWORD=${POSTGRES_PASSWORD}
pg_dump -h db -U ${POSTGRES_USER} ${POSTGRES_DB} > ${BACKUP_DIR}/db_backup_${TIMESTAMP}.sql

# 2. Configuration Backup
tar -czf ${BACKUP_DIR}/config_backup_${TIMESTAMP}.tar.gz /etc/nginx/conf.d /etc/prometheus /etc/loki

# 3. Upload to S3
aws s3 cp ${BACKUP_DIR}/db_backup_${TIMESTAMP}.sql ${S3_PATH}/db/
aws s3 cp ${BACKUP_DIR}/config_backup_${TIMESTAMP}.tar.gz ${S3_PATH}/config/

# 4. Cleanup
rm -rf ${BACKUP_DIR}/*

echo "Backup completed and uploaded to S3."
