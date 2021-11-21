#!/usr/bin/bash

MONITOR_DIR=ready2download
COMMAND=aliyunpan

# Program validation
if ! command -v $COMMAND &> /dev/null; then
    echo "$COMMAND 未安装，退出程序"
    exit 1
fi

# account validation
if ! $COMMAND who | grep -q "UID" ; then
    echo "未找到有效帐号，退出程序"
    exit 1
fi

# check if the directory being monitored exists
if ! $COMMAND ls "$MONITOR_DIR" | grep -q "文件大小"; then
    echo "$ 目录不存在，退出程序"
    exit 1
fi

# FILES=$($COMMAND ls "$MONITOR_DIR" |  head -n -2 | tail -n +2)
FILES=$($COMMAND ls "$MONITOR_DIR" | awk 'BEGIN{RS="\n" ;FS=" "; NF=5}/[0-9]{2}:[0-9]{2}:[0-9]{2}/{print $5}')

IFS=$'\n'
for FILE in $FILES; do
    # FILE=$(echo $LINE | awk 'BEGIN{FS=" "}{print $5}')
    # FILE="${FILE%%+( )}"
    # echo "${FILE%%/*}"
    if [ -n "$FILE" ] && [ "$FILE" != " " ];then
        echo "[Download]: $MONITOR_DIR/${FILE%%+([ \t])}"
        $COMMAND d "$MONITOR_DIR/${FILE%%+( )}" && $COMMAND rm "$MONITOR_DIR/${FILE%%+( )}"
    fi
done
