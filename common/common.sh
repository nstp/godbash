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
	# 为避免出现参数是-n或者-e时echo无法打印的bug，在字符串前面加个空格
	Ret=`echo " $1" | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g'`
}

# 过滤注释
function TrimComment()
{
	Ret=`echo " $1" | sed 's/#.*$//g'`
}

# 过去注释和行首行尾空白字符
function TrimLine()
{
	Ret=`echo " $1" | sed 's/#.*$//g' | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g'`
}

# 从字符串格式 key=val 中解析key和val
function ParseKeyVal()
{
	TrimLine "$1"
	local line="$Ret"
	local key=`echo "$line" | sed 's/=.*$//g'`
	local val=`echo "$line" | sed 's/.*=//g'`
	TrimSpace "$key"
	RetKey="$Ret"
	TrimSpace "$val"
	RetVal="$Ret"
}

# 计算字符串行数
function LineNum()
{
	local str=$1
	Ret=`echo " $str" | sed -n '$='`
}

# 获取字符串指定行内容
function Line()
{
	local str=$1
	local line=$2
	Ret=`echo " $str" | head -n $line | tail -n 1`
}

# 计算文件行数
function FileLineNum()
{
	local file=$1
	Ret=`sed -n '$=' $file`
}

# 获取文件指定行内容
function FileLine()
{
	local file=$1
	local line=$2
	Ret=`head -n $line $file | tail -n 1`
}

# 是否包含指定值
function Contain()
{
	local str=$1
	local val=$2
	local tmp=''
	for tmp in $str;do
		if [[ $val == $tmp ]];then
			Ret=1
			return
		fi
	done
	Ret=0
}
