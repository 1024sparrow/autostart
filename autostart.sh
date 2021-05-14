#!/bin/bash

function start {
	echo start
}

function stop {
	echo stop
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
