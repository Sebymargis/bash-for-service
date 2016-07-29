#!/bin/sh
#
# /etc/init.d/servicename
#
# chkconfig: 1234 95 05
# description: Service web python script daemon - stops and starts the service
#
# source function library
. /etc/init.d/functions

LockFile=/var/lock/subsys/servicename
PidFile=/var/run/servicename.pid
Prog=servicename

Cmd='/opt/anaconda/bin/python3.5 /var/lib/servicelocation/webapp.py > /dev/null 2>&1 & disown'

RETVAL=0

case "$1" in
  start)
    # Starting daemon
    echo -n "Starting Service "
    daemon --user="serviceuser" --pidfile=$PidFile "$Cmd"
    RETVAL=$?
    [ $RETVAL = 0 ] && touch $LockFile
        pid=`ps -ef | grep 'serviceuser' | grep -v grep | awk '{ print $2 }'`
    echo $pid > $PidFile
    echo
    ;;
  stop)
    echo -n "Stopping Service"
    killproc $Prog
    RETVAL=$?
    echo
    [ $RETVAL = 0 ] && rm -f $LockFile $PidFile
    ;;
  reload)
    echo -n "Reloading $Prog"
    killproc $Prog
    RETVAL=$?
    echo
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  status)
    status $Prog
    RETVAL=$?
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|reload|status}"
    RETVAL=2
esac

exit $RETVAL
