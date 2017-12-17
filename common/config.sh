#！/bin/bash
configPath=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
source $configPath/common.sh
source $configPath/print.sh

function LoadConfig()
{
	local file=$1
	if [ -z $file ];then
		PrintError "config file empty"
		return 1
	fi
	if [ ! -f $file ];then
		PrintError "config file not exist"
		return 1
	fi
	FileLineNum $file
	local num=$Ret
	local i=0
	local line=''
	local key=''
	local val=''
	PrintDebug "load config: $file:$num"
	for((i=1;i<=$num;i++))
	{
		# 获取指定行
		FileLine $file $i
		line="$Ret"
		# 过滤注释
		TrimLine "$line"
		line="$Ret"
		if [ -z "$line" ];then
			continue
		fi
		# 获取Key，Val组合
		PrintDebug "parse key value line: $line"
		ParseKeyVal "$line"
		key="$RetKey"
		val="$RetVal"
		PrintDebug "get key:$key value:$val"
		# 设置变量值，优先级低于环境变量
		eval ": \${$key:=$val}"
	}
}