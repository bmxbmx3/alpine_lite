#!/bin/bash 

# 配置 Docker 镜像源
echo "配置 Docker 镜像源..."
DOCKER_CONFIG_FILE="/etc/docker/daemon.json"
DOCKER_MIRROR_URL="https://docker-0.unsee.tech"

# 创建 Docker 配置文件目录（如果不存在）
mkdir -p /etc/docker

# 写入镜像源配置
cat > "$DOCKER_CONFIG_FILE" <<EOF
{
  "registry-mirrors": ["$DOCKER_MIRROR_URL"]
}
EOF

# 重载 Docker 配置并重启服务
systemctl daemon-reload
systemctl restart docker

# 检查 Docker 镜像源配置是否生效
if docker info | grep -q "$DOCKER_MIRROR_URL"; then
  echo "Docker 镜像源配置成功，使用加速器：$DOCKER_MIRROR_URL"
else
  echo "Docker 镜像源配置失败，请检查配置。"
  exit 1
fi

# 检查是否提供了容器名称作为参数
if [ -z "$1" ]; then
  echo "请提供容器名称作为参数"
  exit 1
fi

# 设置容器名称和镜像名
CONTAINER_NAME="$1"
IMAGE_NAME="alpine"
CUSTOM_IMAGE_NAME="alpine_custom"

# 拉取 alpine 镜像
echo "拉取 $IMAGE_NAME 镜像..."
docker pull "$IMAGE_NAME"

# 获取 alpine 镜像的架构
ARCHITECTURE=$(docker inspect --format='{{.Os}}/{{.Architecture}}' "$IMAGE_NAME" | cut -d '/' -f2)

# 根据架构设置平台
case $ARCHITECTURE in
    amd64)
        PLATFORM="linux/amd64"
        ;;
    arm64)
        PLATFORM="linux/arm64"
        ;;
    armv7)
        PLATFORM="linux/arm/v7"
        ;;
    ppc64le)
        PLATFORM="linux/ppc64le"
        ;;
    s390x)
        PLATFORM="linux/s390x"
        ;;
    *)
        echo "不支持此架构: $ARCHITECTURE"
        exit 1
        ;;
esac

# 输出检测到的架构
echo "检测到 $IMAGE_NAME 镜像架构: $ARCHITECTURE"
echo "使用平台: $PLATFORM"

# 停止并删除已存在的同名容器（如果有）
if docker ps -a --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
  echo "发现同名容器，正在停止..."
  docker stop "$CONTAINER_NAME"  # 显式停止容器
  echo "正在删除容器..."
  docker rm "$CONTAINER_NAME"    # 删除容器
fi

# 检查是否存在同名镜像，如果存在则删除
if docker images --format '{{.Repository}}' | grep -q "$CUSTOM_IMAGE_NAME"; then
  echo "发现同名镜像，正在删除..."
  docker rmi -f "$CUSTOM_IMAGE_NAME"
fi

# 构建 alpine_custom 镜像
echo "构建 $CUSTOM_IMAGE_NAME 镜像..."
docker build --build-arg PLATFORM=$PLATFORM -t "$CUSTOM_IMAGE_NAME" .

# 检查是否构建成功
if [ $? -ne 0 ]; then
  echo "构建镜像失败！"
  exit 1
fi

# 运行 Docker 容器，并暴露容器内的所有端口
# 使用 -P 会将所有暴露的端口映射到宿主机的随机端口
echo "启动容器 $CONTAINER_NAME..."
docker run -d -t --name "$CONTAINER_NAME" -P "$CUSTOM_IMAGE_NAME"

# 显示容器的端口映射
docker port "$CONTAINER_NAME"

# 进入容器内部并打开一个交互式 shell
echo "进入容器 $CONTAINER_NAME..."
docker exec -it "$CONTAINER_NAME" /bin/bash

