#!/bin/sh

set -u

command="/usr/bin/qlcplus"
params="-m"

if [ ! -z $OPERATE_MODE ]
then
	params="$params -p"
fi
if [ ! -z $QLC_WEB_SERVER ]
then
	params="$params -w"
fi
if [ ! -z $WORKSPACE_FILE ]
then
	params="$params -o $WORKSPACE_FILE"
fi

echo "Run command: $command $params"

start_qlc() {
	$command $params
}

echo "starting QLC+..."
start_qlc
