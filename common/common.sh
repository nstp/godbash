#！/bin/bash
commonPath=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

# 字符串转小写
function Lower()
{
	Ret=${1,,}
}

# 字符串转大写
function Upper()
{
	Ret=${1^^}
}

# 字符串首字母大写
function Capital()
{
	Ret=${1^}
}

# 获取当前时间
function Now()
{
	Ret=`date "+%F %T"`
}

# 过滤行首行尾空白字符
function TrimSpace()
{
	Ret=`echo "$*" | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g'`
}

# 过滤注释
function TrimComment()
{
	Ret=`echo "$*" | sed 's/#.*$//g'`
}

# 过去注释和行首行尾空白字符
function TrimLine()
{
	Ret=`echo "$*" | sed 's/#.*$//g' | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g'`
}

# 从字符串格式 key=val 中解析key和val
function ParseKeyVal()
{
	TrimLine "$*"
	local line="$Ret"
	local key=`echo "$line" | sed 's/=.*$//g'`
	local val=`echo "$line" | sed 's/.*=//g'`
	TrimSpace "$key"
	RetKey="$Ret"
	TrimSpace "$val"
	RetVal="$Ret"
}

# 获取文件指定行内容
function Line()
{
	local file=$1
	local line=$2
	Ret=`head -n $line $file | tail -n 1`
}

# 计算文件行数
function LineCount()
{
	local file=$1
	Ret=`sed -n '$=' $file`
}