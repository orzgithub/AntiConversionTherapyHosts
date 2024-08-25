#/bin/bash
## 使用提示
if [[ ($# == 0) || ($1 == "-h") || ($1 == "--help") ]]; then
	echo "脚本使用帮助"
	echo -e "$0 [参数] [路径]"
	echo -e "参数列表："
	echo -e "--help\t-h\t查看这条帮助"
	echo -e "路径说明："
	echo -e "请输入机构列表的下载链接（请使用CSV-PLAIN的链接）。或者当前目录如果存在source.txt，可以输入local以使用该文件。"
	exit 0
fi
## 下载机构列表
# 从传入的参数所指定的链接下载机构列表，用于后续处理。传入参数为local则使用当前目录下的source.txt。
if [ $1 == "local" ]; then
	if [ ! -f source.txt ]; then
		echo "当前目录不存在名为source.txt的文件。转换已终止。"
		exit 1
	fi
else
	donloadnum=0
	while [ -f source${donloadnum}.txt ]
	do
		((donloadnum++))
	done
	echo -e "下载机构列表中"
	wget -O source${donloadnum}.txt $1
	if [ $? == 0 ]; then
		echo -e "下载完成"
		if [ -f source.txt ]; then
			rm source.txt
		fi
		mv source${donloadnum}.txt source.txt
	else
		echo -e "下载失败，转换已终止。"
		rm source${donloadnum}.txt
		exit 1
	fi
fi
## 生成host文件
# 站点白名单。请使用"(站点1域名)|(站点2域名)|…|(站点n域名)"的格式编写。
host_whitelist_basic="(www.jjerw.com)|(www.qianxuew.com)|(www.guanwenw.com)|(www.peixun123.com)|(www.100jiaoyu.com)"
host_whitelist_medium="(jinan.dzwww.com)"
host_whitelist_strict="(www.douyin.com)|(www.kuaishou.com)|(weibo.com)|(space.bilibili.com)"
# 该方式产生的host文件可以对对应站点进行屏蔽。但由于部分该类机构采用在微博宣传、与公共网站（也可能是作为机构伪装的普通公司）合作宣传等方式，若屏蔽会牵连其本身所在公共站点而影响使用和降低隐蔽性，故加入白名单，不作屏蔽。
echo "生成HOST中…"
cat source.txt | awk -F"," '{ print $3}' | grep -oaE "http[s]?://[a-zA-Z0-9.-]+" | awk -F"/" '{ print $3}' | grep -vaE ${host_whitelist_basic}"|"${host_whitelist_medium}"|"${host_whitelist_strict} | sed "s/^/127.0.0.1\t&/g" > hostfile.txt
echo "HOST已保存为hostfile.txt。"
# 该方式产生的host文件可以对对应站点进行屏蔽。该级别屏蔽了几个有较高确信度由机构自己掌控，伪装成普通站点的网站。
echo "生成中等屏蔽级别HOST中…"
cat source.txt | awk -F"," '{ print $3}' | grep -oaE "http[s]?://[a-zA-Z0-9.-]+" | awk -F"/" '{ print $3}' | grep -vaE ${host_whitelist_medium}"|"${host_whitelist_strict} | sed "s/^/127.0.0.1\t&/g" > hostfile_medium.txt
echo "HOST已保存为hostfile_medium.txt。"
# 该方式产生的host文件可以对对应站点进行屏蔽。该级别除了上述内容外，还屏蔽了普及度有限但不太可能直接归属于机构（而是和机构合作在其内部建站）的站点。
echo "生成更严格的HOST中…"
cat source.txt | awk -F"," '{ print $3}' | grep -oaE "http[s]?://[a-zA-Z0-9.-]+" | awk -F"/" '{ print $3}' | grep -vaE ${host_whitelist_strict} | sed "s/^/127.0.0.1\t&/g" > hostfile_strict.txt
echo "严格的HOST已保存为hostfile_strict.txt。"
## 生成ABP规则
# 该方式产生的ABP规则可以对对应站点和页面进行屏蔽，可以针对特定的网站地址进行屏蔽。但该类规则需要搭配浏览器支持使用，比如使用AdGuard、ADBlock Plus插件的Chrome、Firefox、Safari，或者带有内建广告屏蔽规则支持的浏览器等。AdGuardHome建议使用HOST，其使用DNS拦截的机制，无法使用该规则中的页面拦截。
# 建议和HOST一起使用，作为HOST的补充。uBlock Origin对于域名拦截有直接的提示且不会强制阻止。其余拦截程序也表现不佳，不能完全阻止对站点访问。
echo "生成ABP规则中…"
cat source.txt | awk -F"," '{ print $3}' | grep -oaE "http[s]?://[a-zA-Z0-9./-]+" | sed "s|^http://||g" | sed "s|^https://||g" | sed "s|/$||g" | sed "s/^/||/g" | sed "s/$/^/g" > abprules.txt
echo "规则已保存为abprules.txt。"