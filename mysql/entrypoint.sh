#!/bin/bash
set -e

# set -x

if [ -z "$(ls -A /var/lib/mysql)" -a "${1%_safe}" = 'mysqld' ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	
	# These statements _must_ be on individual lines, and _must_ end with
	# semicolons (no line breaks or comments are permitted).
	# TODO proper SQL escaping on ALL the things D:
	TEMP_FILE='/tmp/mysql-first-time.sql'
	cat > "$TEMP_FILE" <<-EOSQL
		DELETE FROM mysql.user ;
		CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
		DROP DATABASE IF EXISTS test ;
	EOSQL
	
	if [ "$MYSQL_DATABASE" ]; then
		echo -n "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE " >> "$TEMP_FILE"
		if [ "$MYSQL_DATABASE_SPEC" ]; then
			echo -n "$MYSQL_DATABASE_SPEC" >> "$TEMP_FILE"
		fi
		echo ";" >> "$TEMP_FILE"
	fi
	
	if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
		echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$TEMP_FILE"
		
		if [ "$MYSQL_DATABASE" ]; then
			echo "GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' ;" >> "$TEMP_FILE"
		fi
	fi
	
	echo 'FLUSH PRIVILEGES ;' >> "$TEMP_FILE"
	
	set -- "$@" --init-file="$TEMP_FILE"
fi

chown -R mysql:mysql /var/lib/mysql
exec "$@"
