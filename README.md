memmon
======

An sqlite database populated by cron, ps and awk

Made easy with writable views

Designed to be loaded into grafana (see the .json files herein)

Pic related

![get you some](https://github.com/teodesian/memmon/blob/master/example.jpg?raw=true)

Installation
------------

Plop the contents into /opt/memmon

add a crontab entry to run it (I do every minute like so):

```
* * * * * /opt/memmon/gather_rss.sh
```
