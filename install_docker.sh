#!/bin/bash

# 检查是否传递了用户名参数
if [ -z "$1" ]; then
  echo "请提供一个用户名作为参数！"
  echo "用法：./install_docker.sh <用户名>"
  exit 1
fi

USER_NAME=$1

# 更新 apt 包索引并安装依赖
echo "更新 apt 包索引并安装依赖..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# 添加 Docker 官方的 GPG 密钥
echo "添加 Docker 官方的 GPG 密钥..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 设置 Docker 存储库
echo "设置 Docker 存储库..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 更新 apt 包索引
echo "更新 apt 包索引..."
sudo apt update

# 安装 Docker
echo "安装 Docker..."
sudo apt install -y docker-ce

# 启动 Docker 并设置为开机启动
echo "启动 Docker 并设置为开机启动..."
sudo systemctl start docker
sudo systemctl enable docker

# 显示 Docker 版本
echo "安装完成，Docker 版本："
sudo docker --version

# 自动将指定用户添加到 docker 用户组
echo "将用户 '$USER_NAME' 添加到 docker 用户组..."
sudo usermod -aG docker "$USER_NAME"

# 立即生效用户组更改，避免重启或注销
echo "立即生效用户组更改..."
newgrp docker

# 完成安装
echo "Docker 安装完成，且用户 '$USER_NAME' 已添加到 docker 用户组！现在可以直接运行 Docker 命令。"

