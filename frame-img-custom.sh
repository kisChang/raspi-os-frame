#!/bin/sh
#
# INPUT_PATH	Path to input directory
# ROOTFS_PATH	Path to new root filesystem
# BOOTFS_PATH	Path to new boot filesystem
# DATAFS_PATH	Path to new data filesystem
#

# ---------------------- BASE OS START ----------------------
chroot_exec apk update

#1. enable serial console
echo 'dtoverlay=miniuart-bt' >> ${BOOTFS_PATH}/config.txt
sed -e "s/#ttyS0/ttyAMA0/" -e "s/ttyS0/ttyAMA0/" -i ${ROOTFS_PATH}/etc/inittab
sed "s/serial0/ttyAMA0/" -i ${BOOTFS_PATH}/cmdline.txt

#2. add wifi support
chroot_exec apk add --no-cache wireless-tools wpa_supplicant wireless-regdb iw
#chroot_exec rc-update add wpa_supplicant default #暂不需要，直接加到了interfaces中
echo "brcmfmac" >> ${ROOTFS_PATH}/etc/modules

cat >> ${ROOTFS_PATH}/etc/network/interfaces.alpine-builder <<EOF

auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
pre-up wpa_supplicant -Dnl80211 -iwlan0 -c /data/etc/network/wpa_supplicant.conf -B
EOF
cp ${ROOTFS_PATH}/etc/network/interfaces.alpine-builder ${DATAFS_PATH}/etc/network/interfaces

cat >> ${DATAFS_PATH}/etc/network/wpa_supplicant.conf <<EOF
country=CN
network={
    ssid="wifissid"
    psk="wifipasswd"
}
EOF
#issue 暂不支持
#chroot_exec sh -c "wpa_passphrase wifissid wifipasswd > /data/etc/network/wpa_supplicant.conf"

# 3. wifi ap support
chroot_exec apk add bridge hostapd dnsmasq
# 4. avahi
chroot_exec apk add dbus avahi
# 5. bluetooth
chroot_exec apk add bluez bluez-deprecated
sed -i '/bcm43xx/s/^#//' ${ROOTFS_PATH}/etc/mdev.conf

# ---------------------- BASE OS END ----------------------
#1. add jre
#chroot_exec apk add openjdk8-jre

echo 'run custom success'