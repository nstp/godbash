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


# 重置用法
function ResetUsage()
{
	# 用于保存父命令名：OrdererAdd -> Orderer
	unset cmdParent
	declare -gA cmdParent
	# 用于保存命令的参数名
	unset optName optInfo optDefault
	declare -gA optName optInfo optDefault
}

# 注册用法，入参必须用引号引起来
function RegisterUsage()
{
	local cmd=$1
	LineNum "$cmd"
	local num=$Ret
	local i=0
	local line=''
	local type=TYPE_COMMAND
	local cmdName=''
	for((i=1;i<=$num;i++))
	{
		Line "$cmd" $i
		TrimLine "$Ret"
		line=$Ret
		if [ -z "$line" ];then
			continue
		fi
		if [[ $type == TYPE_COMMAND ]];then
			# 先注册命令
			RegisterCommand "$line"
			if [[ $? != 0 ]];then
				PrintError "RegisterCommand \"$line\" failed"
				return 1
			fi
			cmdName=$Ret
			type=TYPE_OPTION
		else
			# 再注册选项
			RegisterOption $cmdName "$line"
			if [[ $? != 0 ]];then
				PrintError "RegisterOption \"$line\" failed"
				return 1
			fi
		fi
	}
}

# 注册命令，入参必须用引号引起来
function RegisterCommand()
{
	# 先统一转成小写
	Lower "$1"
	local cmd=$Ret
	local type=`echo "$cmd" | cut -d ':' -f 1`
	local names=`echo "$cmd" | cut -d ':' -f 2`
	# 判断类型，必须是command
	TrimSpace $type
	type=$Ret
	if [[ $type != command ]];then
		PrintError "invalid command definition: $1"
		return 1
	fi
	PrintDebug "command declare line"
	# 获取命令名，支持嵌套，根命令定义为Root
	TrimSpace "$names"
	names=$Ret
	PrintDebug "names: $names"
	local parent=Root
	local child=''
	local name=''
	# 设置命令名，并为每一层命令保存父命令名
	for name in $names;do
		Capital $name
		child=$child$Ret
		cmdParent[$child]=$parent
		parent=$child
	done
	# 返回当前命令名
	Ret=$parent
}

# 解析选项，入参必须用引号引起来
function ParseOption()
{
	local option=$1
	local type=''
	local field=''
	RetSets=''
	RetName=''
	RetInfo=''
	RetDefault=''
	for field in ${option//,/ };do
		PrintDebug "parse option field: $field"
		if [[ -z $type ]];then
			TrimSpace $field
			field=$Ret
			Lower $field
			# 设置不区分大小写
			if [[ "$Ret" =~ ^-[-]?[a-z]+$ ]];then
				# 先匹配设置，接下去继续匹配设置，或者匹配变量名
				type=TYPE_SET_OR_NAME
				RetSets="$RetSets $Ret"
			else
				PrintError "invalid option set: $field"
				return 1
			fi
		elif [[ $type == TYPE_SET_OR_NAME ]];then
			TrimSpace $field
			field=$Ret
			Lower $field
			# 设置不区分大小写，变量名区分大小写
			if [[ "$Ret" =~ ^-[-]?[a-z]+$ ]];then
				# 仍然匹配到设置
				RetSets="$RetSets $Ret"
			elif [[ "$field" =~ ^[a-zA-Z]+$ ]];then
				# 匹配到变量名，接下去匹配信息
				RetName=$field
				type=TYPE_INFO
			else
				PrintError "invalid option set or name: $field"
				return 1
			fi
		elif [[ $type == TYPE_INFO ]];then
			TrimSpace $field
			RetInfo=$Ret
			type=TYPE_DEFAULT
		elif [[ $type == TYPE_DEFAULT ]];then
			ParseKeyVal "$field"
			Lower $RetKey
			if [[ -z "$Ret" ]];then
				PrintDebug "option no default"
				return
			fi
			if [[ "$Ret" != default ]];then
				PrintWarn "invalid option default: $field"
				return
			fi
			RetDefault=$RetVal
			type=TYPE_NONE
		else
			PrintWarn "too many field in option: $field"
		fi
	done
}

# 注册选项，入参必须用引号引起来
function RegisterOption()
{
	local cmdName=$1
	local option=$2
	local type=`echo "$option" | cut -d ':' -f 1`
	TrimSpace "$type"
	Lower "$Ret"
	type=$Ret
	PrintInfo "cmd:$cmdName type:$type option:$option"
	# 选项说明行不包含选项信息
	if [[ $type == options ]];then
		PrintDebug "options declare line"
		return
	fi
	# 解析选项
	ParseOption "$option"
	if [[ $? != 0 ]];then
		PrintError "parse option failed"
		return 1
	fi
	# 设置选项信息到关联数组
	local set=''
	if [[ -n ${optInfo[$RetName]} ]];then
		PrintError "option name $RetName duplicated"
		return
	fi
	for set in $RetSets;do
		if [[ -n ${optName[$set]} ]];then
			PrintError "option set $set duplicated"
			return
		fi
		optName[$set]=$RetName
		optInfo[$RetName]=$RetInfo
		optDefault[$RetName]=$RetDefault
	done
}

# 解析命令行参数
function ParseArgs()
{
	echo test
}