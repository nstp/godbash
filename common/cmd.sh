#!/bin/bash
cmdPath=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
source $cmdPath/common.sh
source $cmdPath/print.sh

rootUsage="
	Command:
	Options:
		-l,--level printLevel 打印级别 default=debug
		-c,--config configFile 配置文件
	"

testUsage="
	Command: orderer add
	Options:
		-n,--number number 序号 default=1
		-c,--content content 内容
	"



# 注册命令
function RegisterCmd()
{
	Lower "$1"
	local cmd=$Ret
	local type=`echo "$cmd" | cut -d ':' -f 1`
	local names=`echo "$cmd" | cut -d ':' -f 2`
	TrimLine $type
	type=$Ret
	if [[ $type != names ]];then
		PrintError "invalid command definition: $1"
		return 1
	fi
	TrimLine $names
	names=$Ret
	if [[ -z $names ]];then
		names=root
	fi
	declare -gA 
}
	
# 注册用法
function RegisterUsage()
{
	local cmd=$1
	LineNum "$cmd"
	local num=$Ret
	local i=0
	local line=''
	local type=command
	for((i=1;i<=$num;i++))
	{
		Line "$cmd" $i
		TrimLine "$Ret"
		line=$Ret
		if [ -z $line ];then
			continue
		fi
		if [[ $type ==  command ]];then
			RegisterCommand "$line"
			if [[ $? != 0 ]];then
				PrintError "RegisterCommand \"$line\" failed"
				return 1
			fi
			type=options
		else
			RegisterOption "$line"
			if [[ $? != 0 ]];then
				PrintError "RegisterOption \"$line\" failed"
				return 1
			fi
		fi
	}
}

# 解析命令行参数
function ParseArgs()
{
	
}

# 重置命令行参数
function ResetArgs()
{
	# 用于保存父命令名
	unset cmdParent
	declare -gA cmdParent
	# 用于保存命令的参数名
	unset cmdOption
	declare -gA cmdOption
}