#!/bin/sh

ROM_VER=0.0.1

# 1. init input
rm -rf ./input
mkdir ./input
cp frame-img-custom.sh ./input/

# 2. add myself app (主要修改此处)
./java/init.sh

# 3. clear output
rm -rf ./output
mkdir ./output

# 4. build firmware
# ALPINE_MIRROR、RPI_FIRMWARE_GIT 用了国内镜像服务加速
# SIZE_ROOT_FS 调整文件系统大小，存放JRE
# DEFAULT_KERNEL_MODULES 增加brcmfmac等wifi模块
docker pull ghcr.io/raspi-alpine/builder:latest
docker run --rm -it \
 -v $PWD/output:/output \
 -v $PWD/input:/input \
 -e ARCH=aarch64 \
 -e DEFAULT_TIMEZONE=Asia/Shanghai \
 -e DEFAULT_KERNEL_MODULES="ipv6 af_packet rfkill cfg80211 brcmutil brcmfmac rpi-poe-fan" \
 -e CUSTOM_IMAGE_SCRIPT=frame-img-custom.sh \
 -e ALPINE_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/alpine \
 -e RPI_FIRMWARE_GIT=https://github.com.cnpmjs.org/raspberrypi/firmware \
 -e DEFAULT_HOSTNAME=kisiot \
 -e DEFAULT_ROOT_PASSWORD=pi \
 -e SIZE_ROOT_FS=250M \
 -e IMG_NAME=raspi-kisiot-${ROM_VER} \
 ghcr.io/raspi-alpine/builder
