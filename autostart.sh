#!/bin/bash

readonly tt=/opt/boris/startBoris.sh.pid

function start {
	pushd /opt/boris
		if [ ! -f $tt ]
		then
			su boris -c "./startBoris.sh" &
			echo $! > startBoris.sh.pid
		fi
	popd
}

function stop {
	echo stop
	if [ -r $tt ]
	then
		kill $(cat $tt) && rm $tt
	fi
}

function restart {
	stop && start
}

for oVar in start stop restart
do
	if [ "$1" == $oVar ]
	then
		$1
		exit 0
	fi
done

echo "Usage: /etc/init.d/$(basename $0) {start|stop|restart}"
