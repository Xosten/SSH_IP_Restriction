#!/bin/bash
HOSTNAME=dyn.domain.tld
LOGFILE=$HOME/ufw.log
Current_IP=$(host $HOSTNAME | head -n1 | cut -f4 -d ' ')

if [ ! -f $LOGFILE ]; then
    /usr/sbin/ufw allow from $Current_IP to any port 22 proto tcp
    echo $Current_IP > $LOGFILE
else

    Old_IP=$(cat $LOGFILE)
    if [ "$Current_IP" = "$Old_IP" ] ; then
        echo IP address has not changed
    else
        /usr/sbin/ufw delete allow from $Old_IP to any port 22 proto tcp
        /usr/sbin/ufw allow from $Current_IP to any port 22 proto tcp comment 'Restrict ssh access from a specific ip'
        echo $Current_IP > $LOGFILE
        echo iptables have been updated
    fi
fi
