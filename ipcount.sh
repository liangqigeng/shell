#!/bin/bash

# 设置日志文件路径
LOG_FILES="/var/log/secure*"

# 检查是否有匹配的日志文件
if ! ls $LOG_FILES 1> /dev/null 2>&1; then
    echo "找不到匹配的日志文件"
    exit 1
fi

# 提取登录成功和失败的记录
SUCCESS_LOG=$(grep "Accepted password for" $LOG_FILES)
FAILED_LOG=$(grep "Failed password for" $LOG_FILES)

# 统计成功的登录次数
echo "成功登录次数："
echo "$SUCCESS_LOG" | awk '{for(i=1;i<=NF;i++) if ($i ~ /from/) print $(i+1)}' | sort | uniq -c | sort -nr | awk '{print $1", "$2}'

# 统计失败的登录次数
echo "失败登录次数："
echo "$FAILED_LOG" | awk '{for(i=1;i<=NF;i++) if ($i ~ /from/) print $(i+1)}' | sort | uniq -c | sort -nr | awk '{print $1", "$2}'

