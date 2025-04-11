# 🚀 Docker 环境配置与清理脚本

一套简洁易用的 Docker 脚本，帮助你快速配置 Docker 镜像源、清理 Docker 环境，并构建自定义 Docker 镜像，优化在中国大陆的使用体验。

---

## 📂 项目文件

### 1. `docker_clean.sh` - 清理 Docker 环境
该脚本用于清理 Docker 资源：

- 停止所有正在运行的容器
- 删除所有容器（包括停止的容器）
- 删除所有 Docker 镜像
- 清理未使用的 Docker 资源（包括网络、卷等）

### 2. `docker_run.sh` - 配置并运行 Docker 容器
该脚本用于：

- 配置 Docker 使用国内镜像源，提升镜像拉取速度
- 拉取 Alpine 镜像，构建自定义镜像，并运行容器
- 停止并删除已有的同名容器
- 启动新的容器并暴露所有端口，提供交互式终端

### 3. `Dockerfile` - 自定义 Alpine 镜像
用于 `docker_run.sh` 构建自定义 Docker 镜像，基于轻量级的 Alpine 镜像，适用于快速构建和运行容器。

---

## ⚡ 特性

- **国内镜像源加速**：自动配置 Docker 使用国内加速镜像源，提升镜像拉取速度。
- **自动清理 Docker 资源**：一键清理所有容器、镜像和未使用的资源，释放磁盘空间。
- **自定义 Docker 镜像构建**：基于 Alpine 镜像，快速构建并运行自定义 Docker 镜像。
- **简单易用**：清晰的脚本流程，适合新手和有经验的用户使用。

---

## 🛠️ 安装与配置

### 1. **克隆项目到本地**：

```bash
git clone https://github.com/bmxbmx3/alpine_lite.git
```

### 2. **进入项目目录**：

```bash
cd your-repository-name
```

### 3. **给脚本添加执行权限**：

```bash
chmod +x docker_clean.sh docker_run.sh
```

---

## 🚀 使用说明

### 1. 清理 Docker 资源

建议首先清理 Docker 环境，释放空间：

```bash
sudo ./docker_clean.sh
```

此命令会：

- 停止所有运行中的容器

- 删除所有容器（包括停止的容器）

- 删除所有 Docker 镜像

- 清理未使用的 Docker 资源

###  2. 配置并运行 Docker 容器
清理完成后，运行以下命令配置 Docker 镜像源，并启动容器：

```bash
sudo ./docker_run.sh my_container
```

此命令会：

- 配置 Docker 使用国内镜像源（docker-0.unsee.tech）

- 拉取 Alpine 镜像并构建自定义镜像

- 停止并删除已有同名容器（如 my_container）

- 启动新的容器，暴露所有端口，并提供交互式终端

## 🏠 使用国内镜像源
在中国，Docker Hub 镜像拉取速度可能较慢。该脚本会自动配置 Docker 使用加速镜像源（如 docker-0.unsee.tech），提升镜像拉取速度。如果需要使用其他镜像源，可以编辑 docker_run.sh 文件中的 DOCKER_MIRROR_URL 变量。

## 🔧 许可证
该项目采用 MIT 许可证 - 详情见 [LICENSE](https://github.com/bmxbmx3/alpine_lite/blob/main/LICENSE) 文件。
