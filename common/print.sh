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

function printFatal()
{
	if [[ $printLevel -lt $fatalLevel ]];then
		return
	fi
	local t=`now`
	echo -e "$t ${fatalColor}[F] $@$resetColor"
	exit 1
}

function printError()
{
	if [[ $printLevel -lt $errorLevel ]];then
		return
	fi
	local t=`now`
	echo -e "$t ${errorColor}[E] $@$resetColor"
}

function printWarn()
{
	if [[ $printLevel -lt $warnLevel ]];then
		return
	fi
	local t=`now`
	echo -e "$t ${warnColor}[W] $@$resetColor"
}

function printInfo()
{
	if [[ $printLevel -lt $infoLevel ]];then
		return
	fi
	local t=`now`
	echo -e "$t ${infoColor}[I] $@$resetColor"
}

function printDebug()
{
	if [[ $printLevel -lt $debugLevel ]];then
		return
	fi
	local t=`now`
	echo -e "$t ${debugColor}[D] $@$resetColor"
}

function setPrintLevel()
{
	case ${1,,} in
		f|fatal) printLevel=$fatalLevel;;
		e|error) printLevel=$errorLevel;;
		w|warn)  printLevel=$warnLevel;;
		i|info)  printLevel=$infoLevel;;
		d|debug) printLevel=$debugLevel;;
		*) printWarn "invalid print level $1";;
	esac
}