#!/bin/bash
cmdPath=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)
source $cmdPath/common.sh
source $cmdPath/print.sh

rootCmd="
	Command:
	Options:
		-l,--level printLevel 打印级别 default=debug
		-c,--config configFile 配置文件
	"

testCmd="
	Command: orderer add
	Options:
		-n,--number number 序号 default=1
		-c,--content content 内容
	"
	
# 注册命令名
function RegisterCmdName()
{
	local name="$*"
}
	
# 注册命令
function RegisterCmd()
{
	local cmd=$1
	local 

}

LineNum "$rootCmd"
echo $Ret
Line "$rootCmd" 3
echo $Ret
