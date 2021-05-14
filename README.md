# Автостарт. Пошаговая инструкция.

## Шаг 1. Обеспечить наличие скрипта запуска из /opt/boris без параметров

/opt/boris/startBoris.sh

Не забудьте добавить прав на исполнение
```bash
# chmod +x /opt/boris/startBoris.sh
```
При остановке сервиса будет прибиваться этот скрипт.

## Шаг 2. Скрипт запуска/остановки в /etc/init.d

В директории ```/etc/init.d``` необходимо создать скрипт (не забудьте дать ему прав на исполнение).

Например, пусть это будет *boris* . Этот скрипт принимает единственный аргумент.
```
boris {start|stop|restart}
```

В скрипте в зависимости от значения единственного аргумента вы производите то или иное действие
```bash
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
```
Если автозапуск необходимо производить от имени рута, то замените
```bash
su boris -c "./startBoris.sh" &
```
на
```bash
./startBoris.sh &
```

## Шаг 3. Ссылка скрипта в директории автозапуска

В директории ```/etc/rc3.d``` необходимо создать симолическую ссылку на скрипт ```/etc/init.d/boris```:
```bash
# cd /etc/rc3.d
# ln -s ../init.d/boris S02boris
```
Обратите внимание на ```S02``` перед именем. Это ```S``` и число из двух цифр - приоритет. Если он больше приоритетов всех других ссылок и скриптов в директории ```rc3.d```, то ваш скрипт запустится после всех остальных.

Все скрипты в ```rc3.d``` запускаются до запуска XWindow сервера, но после того, как проинициализировалась сеть.

** ГОТОВО **

Останлось только перезагрузиться.

## Запуск/Останов сервиса

При старте операционной системы *startBoris.sh* будет запускаться автоматически, после инициализации сети и до запуска иксов.

Остановить так:
```bash
$ service boris stop
```

Запустить так:
```bash
$ service boris start
```

Перезапустить так:
```bash
$ service boris restart
```
