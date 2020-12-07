#!/bin/bash
set -e

if [ -z "$1" ]; then
	echo "Usage: $0 gpioPinNumber <value>"
	echo
	echo 'Value is optional. Use 0 or 1. If not specified, the value is toggled'
	echo
	echo '0 = off (low  0v)'
	echo '1 = on  (high 3.3v)'
	exit 1
fi

PIN="/sys/class/gpio/gpio$1"

if [ ! -d "$PIN" ]; then
	echo "$1" > '/sys/class/gpio/export'
fi

if [ $(cat "$PIN/direction") != 'out' ]; then
	echo 'out' > "$PIN/direction"
fi

if [ -n "$2" ]; then
	val="$2"
else
	val=$(cat "$PIN/value")

	if [ "$val" = '0' ]; then
		val='1'
	else
		val='0'
	fi

	echo "Setting to: $val"
fi

echo "$val" > "$PIN/value"