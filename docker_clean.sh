#!/bin/bash

# 停止所有正在运行的容器
echo "停止所有正在运行的容器..."
docker stop $(docker ps -q)

# 删除所有容器
echo "删除所有容器..."
docker rm $(docker ps -a -q)

# 删除所有镜像
echo "删除所有镜像..."
docker rmi $(docker images -q)

# 清理未使用的 Docker 资源（包括未使用的容器、镜像、网络、卷）
echo "清理未使用的 Docker 资源..."
docker system prune -a --volumes -f

echo "所有容器和镜像已删除，Docker 系统已清理完毕。"

