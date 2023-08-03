#!/bin/bash

SOURCE="/etc/init.d/vboxinit"

if [ ! -f ${SOURCE} ]; then
	echo "${RED}ERROR:${WHITE} vboxinit not found. Locating..${RESTORE}"
	for F in $(locate vboxinit); do
		SIZE=$( stat -c %s ${F} )
		[ ${SIZE} -lt 1000 ] && continue

		cp ${F} ${SOURCE}
		break
	done
fi

if [ ! -x ${SOURCE} ]; then
	chmod +x ${SOURCE}
fi

for I in 1 6
do
	DIR="/etc/rc.d/rc${I}.d"
	PREFIX=$(echo "$(basename /etc/rc.d/rc${I}.d/*vboxautostart-service)" | sed -rn 's/([KS][0-9]+).*/\1/p')
	TARGET="${DIR}/${PREFIX}vboxinit"

	echo -n "${YELLOW} shutdown link:${WHITE} ${SOURCE} ${TARGET} ${RESTORE}"
	ls -s "${SOURCE}" "${TARGET} > /dev/null 2>&1" \
	&& { echo "${LGREEN}SUCCESS${RESTORE}"; } \
	|| { echo "${RED}FAILED${RESTORE}"; }
done

for I in 2 3 4 5
do
	DIR="/etc/rc.d/rc${I}.d"
	PREFIX=$(echo "$(basename /etc/rc.d/rc${I}.d/*vboxautostart-service)" | sed -rn 's/([KS][0-9]+).*/\1/p')
	TARGET="${DIR}/${PREFIX}vboxinit"

	echo -n "${YELLOW} shutdown link:${WHITE} ${SOURCE} ${TARGET} ${RESTORE}"
	ls -s "${SOURCE}" "${TARGET} > /dev/null 2>&1" \
	&& { echo "${LGREEN}SUCCESS${RESTORE}"; } \
	|| { echo "${RED}FAILED${RESTORE}"; }
done
