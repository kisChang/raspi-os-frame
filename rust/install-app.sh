#add app
mkdir ${ROOTFS_PATH}/opt/oms/
cp ${INPUT_PATH}/hello_world ${ROOTFS_PATH}/opt/oms/rust_app

#add service
cat >> ${ROOTFS_PATH}/etc/init.d/test_app <<EOF
#!/sbin/openrc-run
# shellcheck shell=ash
# shellcheck disable=SC2034

command="/opt/oms/rust_app"
pidfile="/var/run/omshard.pid"
command_args=""
command_background=true

depend() {
	use logger dns
	need net
	after firewall
}
EOF
chroot_exec chmod u+x /etc/init.d/test_app
chroot_exec rc-update add test_app default