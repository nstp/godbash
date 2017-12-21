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

# 打印函数
function Print()
{
	local level=''
	local color=''
	local tag=''
	case ${1,,} in
		f|fatal)
			level=$fatalLevel
			color=$fatalColor
			tag=F;;
		e|error)
			level=$errorLevel
			color=$errorColor
			tag=E;;
		w|warn)
			level=$warnLevel
			color=$warnColor
			tag=W;;
		i|info)
			level=$infoLevel
			color=$infoColor
			tag=I;;
		d|debug)
			level=$debugLevel
			color=$debugColor
			tag=D;;
		*)
			PrintWarn "invalid print level $1"
			return 1
	esac
	shift
	# 只打印级别小于等于printLevel的消息
	if [[ $level -gt $printLevel ]];then
		return
	fi
	Now
	local time=$Ret
	echo -e "$time $color[$tag] $@$resetColor"	
}

# 打印数组
function PrintArray()
{
	local name=$1
	local level=$2
	local keys=$(eval "echo \${!$name[*]}")
	local key=''
	local val=''
	for key in $keys;do
		val=$(eval "echo \${$name[$key]}")
		Print $level "$name[$key] = $val"
		if [[ $? != 0 ]];then
			return 1
		fi
	done
}

function PrintFatal()
{
	Print fatal $@
	exit 1
}

function PrintError()
{
	Print error $@
}

function PrintWarn()
{
	Print warn $@
}

function PrintInfo()
{
	Print info $@
}

function PrintDebug()
{
	Print debug $@
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