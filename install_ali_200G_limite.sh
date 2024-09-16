wget https://raw.githubusercontent.com/kkbeta/ali/main/monitor_traffic.sh
wget https://raw.githubusercontent.com/kkbeta/ali/main/change_cloudflare_dns_ip_record.sh
wget https://raw.githubusercontent.com/kkbeta/ali/main/README.md 
apt-get install -y iptables bc vnstat
chmod +x monitor_traffic.sh change_cloudflare_dns_ip_record.sh
bash monitor_traffic.sh 190 3
(crontab -l ; echo "* * * * * /root/monitor_traffic.sh 190 1 4 eth0 > /root/脚本日志.txt") | crontab -
