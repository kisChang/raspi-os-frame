#add jre and app
chroot_exec apk add openjdk8-jre


mkdir ${ROOTFS_PATH}/opt/oms/
cp ${INPUT_PATH}/app.jar ${ROOTFS_PATH}/opt/oms/
mkdir ${ROOTFS_PATH}/opt/oms/lib
mkdir ${ROOTFS_PATH}/opt/oms/page
cp ${INPUT_PATH}/lib/* ${ROOTFS_PATH}/opt/oms/lib
cp -R ${INPUT_PATH}/page/* ${ROOTFS_PATH}/opt/oms/page

cat >> ${ROOTFS_PATH}/etc/init.d/test_app <<EOF
#!/sbin/openrc-run
# shellcheck shell=ash
# shellcheck disable=SC2034

command="/usr/bin/java"
pidfile="/var/run/java-app.pid"
command_args="-jar /opt/oms/app.jar"
command_background=true

depend() {
	use logger dns
	need net
	after firewall
}
EOF
chroot_exec chmod u+x /etc/init.d/test_app
chroot_exec rc-update add test_app default