#!/usr/bin/env bash

# 定义颜色
BLUE_COLOR="\033[36m"
RED_COLOR="\033[31m"
GREEN_COLOR="\033[32m"
VIOLET_COLOR="\033[35m"
RES="\033[0m"

chmod +x imeepo-start.sh
chmod +x imeepo-delete.sh

# Mysql
chmod -R 777 ./logs/mysql57
chmod -R 777 ./logs/mysql80

cp .env.example .env
cp docker-compose-example.yml docker-compose.yml
cp ./services/redis/redis.conf.example ./services/redis/redis.conf

echo -e ""
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e "${BLUE_COLOR}+        ${GREEN_COLOR}配置文件初始化完毕${BLUE_COLOR}           +${RES}"
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e "${BLUE_COLOR}+        请根据自己的需求修改：       +${RES}"
echo -e "${BLUE_COLOR}+        ${VIOLET_COLOR}.env${BLUE_COLOR}                         +${RES}"
echo -e "${BLUE_COLOR}+        ${VIOLET_COLOR}docker-compose.yml${BLUE_COLOR}           +${RES}"
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e ""