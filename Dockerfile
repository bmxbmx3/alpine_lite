# 使用外部传入的参数 PLATFORM 来决定构建的平台
ARG PLATFORM
FROM --platform=${PLATFORM} alpine:latest

# 配置为阿里云镜像源并更新apk包
RUN echo "配置为阿里云镜像源..." && \
    echo "http://mirrors.aliyun.com/alpine/v3.11/main" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/v3.11/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache bash tzdata python3 py3-pip

# 设置环境变量
ENV LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIPENV_PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple \
    PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

# 安装 pipenv
RUN pip3 install --no-cache pipenv

# 设置时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 清理不必要的时区文件以减小镜像体积
RUN rm -rf /usr/share/zoneinfo/Africa /usr/share/zoneinfo/Antarctica /usr/share/zoneinfo/Arctic /usr/share/zoneinfo/Asia /usr/share/zoneinfo/Atlantic /usr/share/zoneinfo/Australia /usr/share/zoneinfo/Europe /usr/share/zoneinfo/Indian /usr/share/zoneinfo/Mexico /usr/share/zoneinfo/Pacific /usr/share/zoneinfo/Chile /usr/share/zoneinfo/Canada

# 升级pip和setuptools，并清理apk缓存
RUN python3 -m ensurepip --upgrade && \
    pip3 install --no-cache --upgrade pip setuptools && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# 默认命令
CMD ["/bin/bash"]

