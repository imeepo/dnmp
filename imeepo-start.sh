#!/usr/bin/env bash

# 定义颜色
BLUE_COLOR="\033[36m"
RED_COLOR="\033[31m"
GREEN_COLOR="\033[32m"
VIOLET_COLOR="\033[35m"
RES="\033[0m"

docker-compose up -d

echo -e ""
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e "${BLUE_COLOR}+              ${VIOLET_COLOR}查看容器${BLUE_COLOR}               +${RES}"
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e ""

docker ps -a

echo -e ""
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e "${BLUE_COLOR}+              ${GREEN_COLOR}构建完成${BLUE_COLOR}               +${RES}"
echo -e "${BLUE_COLOR}# =================================== #${RES}"
echo -e ""