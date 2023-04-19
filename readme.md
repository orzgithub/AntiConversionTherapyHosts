# “戒网瘾”（可能含扭转机构）机构列表屏蔽规则转换

## 说明
这是一个可以将推特用户[@FuncSir](https://twitter.com/FuncSir "@FuncSir的推特主页")所制作的 [“戒网瘾”（可能含扭转机构）机构列表](https://github.com/FunctionSir/TransDefenseProject "GitHub Repo链接")（[推特原项目](https://twitter.com/FuncSir/status/1640740300086714373 "推文链接")）当中对应机构的官网转换成屏蔽列表的简单的Shell脚本。感谢他的努力。这份列表是为了所有的人，希望不再有人被送进那样糟糕的披着“戒网瘾”、“扭转治疗”的违法机构。虽然可能这样的建议不太道德，但如果认为自己父母有把自己送进去的风险，还是找机会接触到他们的手机，把这样的机构官网预先屏蔽掉比较好，这是保护自己的重要方式。

## 使用方法
进入一个类Unix系统，需要系统支持wget、awk、grep、sed指令。绝大多数操作系统应该已经内置了这些东西。同时Windows下可以选择使用MSYS，MSYS2，Cygwin或WSL执行该脚本。<br>
```
脚本使用帮助：
./makeit.sh [参数] [路径]
参数列表：
--help  -h      查看这条帮助
路径说明：
请输入机构列表的下载链接（请使用CSV-PLAIN的链接）。或者当前目录如果存在source.txt，可以将路径输入为local以使用该文件。
```

## 屏蔽列表的说明
该脚本会产生三个文件，hostfile.txt、hostfile_strict.txt、abprules.txt。作用如下：<br>
hostfile.txt：生成的一个hosts文件。这个版本只屏蔽了域名即其官网的类型，而部分机构将其官网设置在其它网站之内（例如济南大众网下藏着济南市宏开教育培训学校的官网，如果屏蔽机构官网则济南大众网也会一起屏蔽。），由此影响正常网站（虽然在底下还藏这种机构官网，想必这些主站也不会是无辜的“正常网站吧”…）的访问，为避免这样的影响未对此类网站作出屏蔽。<br>
hostfile_strict.txt：一个更加严格版本的hosts文件，这个版本屏蔽了上述将官网设置在其它网站之内情况的域名，以达到更好的屏蔽效果。但有部分机构将宣传仅设置在微博等平台上，由于该类平台较为常用，屏蔽后较影响正常使用，不作处理。<br>
abprules.txt：用于ADBlock Plus等类似广告屏蔽工具的规则，对所有的站点进行针对性屏蔽，但需要浏览器支持，不能对设备全局生效。另外似乎广告屏蔽插件效果表现不佳，很多页面仍能加载出一小部分，表现出布局混乱，有时甚至完全不起作用。建议搭配hosts文件使用。<br>

## 使用方式
hosts文件：<br>
Windows系统的hosts位于``C:\Windows\System32\drivers\etc\hosts``，MacOS和Linux系统的hosts位于``/etc/hosts``，Android系统的hosts位于``/system/etc/hosts``。将生成的hosts文件中的内容复杂并粘贴于对应系统hosts文件尾部即可。不过由于权限问题，对于没有了解的人可能有些难度，在此不适合拿出大篇幅讲述权限问题的处理。具体可以搜索了解。<br>
AdBlock Plus规则：<br>
可以在浏览器的插件商店中找到诸如AdBlock Plus、uBlock Origin、AdGuard等广告屏蔽插件，其中有设置自定义规则的地方可供输入，将生成的规则复制进去即可。或者，本仓库依托于GitHub提供一个规则订阅，地址为：[https://github.com/orzgithub/AntiConversionTherapyHosts/raw/master/abprules.txt](https://github.com/orzgithub/AntiConversionTherapyHosts/raw/master/abprules.txt)。考虑到国内网络环境，提供一个由[ghproxy](https://ghproxy.com)提供的代理加速链接，取决于代理的服务提供稳定性，该链接不保证持续可用。[https://ghproxy.com/https://raw.githubusercontent.com/orzgithub/AntiConversionTherapyHosts/master/abprules.txt](https://ghproxy.com/https://raw.githubusercontent.com/orzgithub/AntiConversionTherapyHosts/master/abprules.txt)。将订阅规则添加到规则订阅即可。<br>
考虑到在手机上使用的不便性，或许需要有志愿者建设一个ADGuardHome服务器或类似的东西，将该服务器设定为设备使用的私人DNS服务器即可起到等同于HOSTS的功能。限于自己条件不足，仅能在此提起建议。<br>
