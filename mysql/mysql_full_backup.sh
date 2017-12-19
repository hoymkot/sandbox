#!/bin/sh

source /data/mysqldata/scripts/mysql_env.ini

DATA_PATH=/data/mysqldata/backup/mysql_full_bytables
DATA_FILE=${DATA_PATH}/dbfullbak_by_tables_`date +%F`.sql.gz
LOG_FILE=${DATA_PATH}/dbfullbak_`date +%F`.log
MYSQL_PATH=/usr/local/mysql/bin
MYSQL_CMD="${MYSQL_PATH}/mysql -u${MYSQL_USER} -P${MYSQL_PASS} -S /data/mysqldata/${HOST_PORT}/mysql.sock -A --R -x default-character-set=utf8"
MYSQL_DUMP="${MYSQL_PATH}/mysqldump -u${MYSQL_USER} -p${MYSQL_PASS} -S /data/mysqldata/${HOST_PORT}/mysql.sock -A -R -x --default-character-set=utf8"

echo > $LOG_FILE
echo -e "=== Jobs started at `date +%F' ' %T ' ' %w` ===\n" >> $LOG_FILE
echo -e "*** Executed command:${MYSQL_DUMP} | gzip > ${DATA_FILE}" >> $LOG_FILE
${MYSQL_DUMP} | gzip > $DATE_FILE
echo -e "**** Executed finished at `date +%F' '%T' '%w` ====" >> $LOG_FILE
echo -e "**** Backup file size: ` du -sh ${DATA_FILE}` ====\n" >> ${LOGFILE}


echo -e "---- Find expired backup and delete those files ----" >> ${LOG_FILE}
for tfile in $(/usr/bin/find $DATA_PATH/ -mtime +6)
do
	if [ -d $tfile ] ; then
		rmdir $tfile
	elif [ -f $tfile] ; then
		rm -f $tfile
	fi
	echo -e "---- Delete file: $tfile ----" >> ${LOG_FILE}
done

echo -e "\n==== Jobs ended at `date +%F' '%T' '%w` ====\n" >> $LOG_FILE
