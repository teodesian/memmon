#!/bin/bash
sqlite3 /opt/memmon/rss.db < /opt/memmon/mem.sql
ps -ely | tail -n "+2" | awk '{ print "INSERT OR IGNORE INTO procsummary (name,rss) VALUES (\""$13"\","$8");"}' > /opt/memmon/update.sql
sqlite3 /opt/memmon/rss.db < /opt/memmon/update.sql
mv /opt/memmon/update.sql /opt/memmon/update.sql.last
