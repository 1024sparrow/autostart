# Автостарт. Пошаговая инструкция.

## Шаг 1. Обеспечить наличие скрипта запуска из /opt/boris без параметров

/opt/boris/startBoris.sh

## Шаг 2. Скрипт запуска/остановки в /etc/init.d

В директории ```/etc/init.d``` необходимо создать скрипт (не забудьте дать ему прав на исполнение).

Например, пусть это будет *hmr9logger* . Этот скрипт принимает единственный аргумент.
```
hmr9logger {start|stop|restart}
```

В скрипте в зависимости от значения единственного аргумента вы производите то или иное действие
```bash
#!/bin/bash

function start {
	pushd /opt/boris
		su user -c "./startBoris.sh"
	popd
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
```


В директории ```/etc/rc3.d``` необходимо создать 

Для того, чтобы 
