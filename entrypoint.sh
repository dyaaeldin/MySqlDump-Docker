#!/usr/bin/env sh
echo "$MYSQL_CRON_PATTERN /usr/local/bin/mysqldump.sh" >> /etc/crontabs/root 
chmod a+x /usr/local/bin/*
crond -f 
