#! /bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/reboothelper* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/reboothelper* >/dev/null 2>&1
		exit 1
	;;
esac

# 安装插件
cp -rf /tmp/reboothelper/scripts/* /koolshare/scripts/
cp -rf /tmp/reboothelper/webs/* /koolshare/webs/
cp -rf /tmp/reboothelper/res/* /koolshare/res/
cp -rf /tmp/reboothelper/uninstall.sh /koolshare/scripts/uninstall_reboothelper.sh

chmod +x /koolshare/scripts/reboothelper*
chmod +x /koolshare/scripts/uninstall_reboothelper.sh
[ ! -L "/koolshare/init.d/S99Reboothelper.sh" ] && ln -sf /koolshare/scripts/reboothelper_config.sh /koolshare/init.d/S99Reboothelper.sh
chmod +x /koolshare/init.d/*

# 离线安装用
dbus set reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_description="解决重启Bug"
dbus set softcenter_module_reboothelper_install="1"
dbus set softcenter_module_reboothelper_name="reboothelper"
dbus set softcenter_module_reboothelper_title="重启助手"

# 完成
echo_date "重启助手安装完毕！"
rm -rf /tmp/reboothelper* >/dev/null 2>&1
exit 0
