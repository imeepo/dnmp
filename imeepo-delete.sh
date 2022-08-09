#!/usr/bin/env bash

docker rm -f $(docker ps -a | grep -o '[0-9,a-f]\{8\}')
echo ""
echo "+ ----------------- +"
echo ""
echo "    已删除全部容器"
echo ""
echo "+ ----------------- +"
echo ""
docker rmi $(docker images -q -a | xargs)
echo ""
echo "+ ----------------- +"
echo ""
echo "    已删除全部镜像"
echo ""
echo "+ ----------------- +"