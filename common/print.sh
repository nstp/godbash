#！/bin/bash
printPath=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
source $printPath/common.sh

printLevel=4

debugLevel=4
infoLevel=3
warnLevel=2
errorLevel=1
fatalLevel=0

resetColor="\e[0m"
redColor="\e[1;31m"
greenColor="\e[1;32m"
yellowColor="\e[1;33m"
blueColor="\e[1;34m"
purpleColor="\e[1;35m"
azureColor="\e[1;36m"
whiteColor="\e[1;44;37m"

fatalColor=$purpleColor
errorColor=$redColor
warnColor=$yellowColor
infoColor=$blueColor
debugColor=$whiteColor

function PrintFatal()
{
	if [[ $printLevel -lt $fatalLevel ]];then
		return
	fi
	Now
	local time=$Ret
	echo -e "$time ${fatalColor}[F] $@$resetColor"
	exit 1
}

function PrintError()
{
	if [[ $printLevel -lt $errorLevel ]];then
		return
	fi
	Now
	local time=$Ret
	echo -e "$time ${errorColor}[E] $@$resetColor"
}

function PrintWarn()
{
	if [[ $printLevel -lt $warnLevel ]];then
		return
	fi
	Now
	local time=$Ret
	echo -e "$time ${warnColor}[W] $@$resetColor"
}

function PrintInfo()
{
	if [[ $printLevel -lt $infoLevel ]];then
		return
	fi
	Now
	local time=$Ret
	echo -e "$time ${infoColor}[I] $@$resetColor"
}

function PrintDebug()
{
	if [[ $printLevel -lt $debugLevel ]];then
		return
	fi
	Now
	local time=$Ret
	echo -e "$time ${debugColor}[D] $@$resetColor"
}

function SetPrintLevel()
{
	case ${1,,} in
		f|fatal) printLevel=$fatalLevel;;
		e|error) printLevel=$errorLevel;;
		w|warn)  printLevel=$warnLevel;;
		i|info)  printLevel=$infoLevel;;
		d|debug) printLevel=$debugLevel;;
		*) PrintWarn "invalid print level $1";;
	esac
}