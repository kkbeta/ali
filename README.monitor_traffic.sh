【脚本】阿里云免费CDT实例自动检测流量进行限制，并相应增加/删除 dns 记录 。[应该能适应各种流量限制场景][其他小鸡也可以使用][广泛参数设置]
在https://www.nodeseek.com/post-127477-1，“她说是晒黑的楼主”这位大佬的基础上增加改ip记录


apt-get install -y iptables bc vnstat

chmod +x monitor_traffic.sh

bash monitor_traffic.sh 190 3

(crontab -l ; echo "* * * * * /root/monitor_traffic.sh 190 1 4 eth0 > /root/脚本日志.txt") | crontab -

以下是这四个命令的详细解释和使用：

apt-get install -y iptables bc vnstat

这个命令用于安装 iptables，bc 和 vnstat 这三个软件包。iptables 是用于配置 Linux 内核防火墙的工具，bc 是一个任意精度的计算器语言，vnstat 是一个控制台下的网络流量监控工具。-y 参数表示在安装过程中自动回答所有提示为 'yes'。

chmod +x monitor_traffic.sh

这个命令用于给 monitor_traffic.sh 脚本添加执行权限。chmod 是用于改变文件权限的命令，+x 表示添加执行权限。

bash monitor_traffic.sh 190

这个命令用于运行 monitor_traffic.sh 脚本，并将 190 作为参数传递给脚本，表示流量限制是190GB。bash 是一种 Unix shell，用于运行 shell 脚本。

(crontab -l ; echo "* * * * * /root/monitor_traffic.sh 190 3 > /root/脚本日志.txt")  | crontab -

这个命令用于将 monitor_traffic.sh 脚本添加到 crontab，使其每分钟运行一次，并将脚本的输出重定向到 /root/脚本日志.txt 文件。

crontab -l 命令用于列出当前用户的 crontab 文件内容。

echo "* * * * * /root/monitor_traffic.sh 190 3 > /root/脚本日志.txt" 命令将创建一个新的 crontab 任务，任务内容是每分钟运行一次 monitor_traffic.sh 脚本，并将脚本的输出重定向到 /root/脚本日志.txt 文件。

| crontab - 命令将前面的输出设置为当前用户的 crontab 文件内容。

* * * * * 表示每分钟运行一次任务，你可以根据需要修改这个设置。例如，如果你想每5分钟运行一次任务，你可以将其修改为 */5 * * * *。如果你想每小时的第30分钟运行任务，你可以将其修改为 30 * * * *。

/root/monitor_traffic.sh 190 3 是你想在 crontab 中运行的命令，你可以将 190 和 3 修改为你想要的流量限制和检查类型。

> /root/脚本日志.txt 表示将脚本的输出重定向到 /root/脚本日志.txt 文件，你可以将 /root/脚本日志.txt 修改为你想要的文件路径。
>
> 这个脚本是用于监控Linux服务器上的网络流量，并根据设定的流量限制来决定是否阻止除SSH以外的所有网络流量。脚本接受四个参数，但是所有参数都是可选的，如果没有提供，脚本会使用默认值。这四个参数分别是：

LIMIT_GB：流量限制，单位为GB。默认值为1024GB。
reset_day：流量重置日，即每月的哪一天流量会被重置。默认值为1，即每月的第一天。
CHECK_TYPE：流量检查类型。默认值为4。这个参数有四个可选值：
1：只检查上传流量
2：只检查下载流量
3：检查上传和下载流量中的最大值
4：检查上传和下载流量的总和
INTERFACE：网络接口。默认值为系统的默认网络接口。
下面是一些使用这个脚本的例子：

使用所有默认参数运行脚本：
./traffic_monitor.sh
这将会设置流量限制为1024GB，每月的第一天重置流量，检查上传和下载流量的总和，并使用系统的默认网络接口。

设置流量限制为500GB，其他参数使用默认值：
./traffic_monitor.sh 500
设置流量限制为500GB，流量在每月的10号重置，其他参数使用默认值：
./traffic_monitor.sh 500 10
设置流量限制为500GB，流量在每月的10号重置，只检查下载流量，其他参数使用默认值：
./traffic_monitor.sh 500 10 2
设置流量限制为500GB，流量在每月的10号重置，只检查下载流量，并指定网络接口为eth0：
./traffic_monitor.sh 500 10 2 eth0
这个脚本需要在Linux系统上运行，并需要vnstat和iptables这两个工具。如果你的系统上没有这两个工具，你可以通过以下命令来安装：

对于基于Debian的系统（如Ubuntu）：
sudo apt-get update
sudo apt-get install vnstat iptables
对于基于RPM的系统（如CentOS）：
sudo yum update
sudo yum install vnstat iptables
在运行脚本之前，你需要给脚本执行权限。你可以通过以下命令来给脚本添加执行权限：

chmod +x traffic_monitor.sh
