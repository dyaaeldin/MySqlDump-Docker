#!/usr/bin/env sh
for dir in mnt tmp; do 
  if [ ! -d "/$dir/$WSO2_BACKUP_DIR" ]; then
   mkdir /$dir/$WSO2_BACKUP_DIR
  fi
done
mysqldump -h "$WSO2_MYSQL_SERVICE_NAME" -P "$WSO2_MYSQL_PORT" -u "$WSO2_MYSQL_USER" -p"$WSO2_MYSQL_PASSWORD" $WSO2IS_DB > /tmp/"$WSO2_BACKUP_DIR"/wso2is-db-$(date +%Y%m%d-%H%M).sql
mysqldump -h "$WSO2_MYSQL_SERVICE_NAME" -P "$WSO2_MYSQL_PORT" -u "$WSO2_MYSQL_USER" -p"$WSO2_MYSQL_PASSWORD" $WSO2UM_DB > /tmp/"$WSO2_BACKUP_DIR"/wso2um-db-$(date +%Y%m%d-%H%M).sql

cd /tmp
tar cvf wso2-db-$(date +%Y%m%d-%H%M).tar $WSO2_BACKUP_DIR/
cp wso2-db-*.tar /mnt/$WSO2_BACKUP_DIR/
if [ "$REMOTE_BACKUP" = "true" ]; then
scp -o StrictHostKeyChecking=no -P $REMOTE_SERVER_PORT -i $KEY_PATH /tmp/wso2-db-*.tar $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR_WSO2
fi
rm -rf wso2-db-*.tar /tmp/$WSO2_BACKUP_DIR/
find /mnt -mindepth 1 -mtime +$BACKUP_TIME -delete
