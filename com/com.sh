#！/bin/bash
comPath=$(cd `dirname ${BASH_SOURCE[0]}` && pwd)

function lower()
{
	echo ${1,,}
}

function upper()
{
	echo ${1^^}
}

function capital()
{
	echo ${1^}
}