#!/usr/bin/env bash
echo "开始读取配置"
#填写本地ipv4
#LOCAL_IP=xxxx

echo "通过ip.gs读取ip"
LOCAL_IP=`curl -4 ip.gs`
echo "本机ip地址是$LOCAL_IP"
#地址池文件位置一行一个
#IP_POOL=./ip_pool.txt
#tg机器人的token
TG_BOT_TOKEN=xxxx
#你的tgid
TG_CHATID=xxxx
#CF的KEY 可登录网页查找
CFKEY=xxxx
#你的CF的邮箱
CFUSER=xxx@xxx.com
#域名id
#CFZONE_ID=xxxx
#域名
CFZONE_NAME=xxx.com
#二级域名
CFRECORD_NAME=xx.xxx.com
echo "同步的域名是$CFRECORD_NAME"
#解析类型
CFRECORD_TYPE=A
#ttl时间
CFTTL=120

# 获取 zone_id
CFZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$CFZONE_NAME" \
-H "X-Auth-Email: $CFUSER" \
-H "X-Auth-Key: $CFKEY" \
-H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
echo $CFZONE_ID


# 地址池更新
 if [  -f /root/traffic_enough ]; then
  echo "添加一条新的$CFRECORD_TYPE类型解析记录 $CFRECORD_NAME:$LOCAL_IP"
  RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CFZONE_ID/dns_records" \
  -H "X-Auth-Email: $CFUSER" \
  -H "X-Auth-Key: $CFKEY" \
  -H "Content-Type: application/json" \
  --data "{\"id\":\"$CFZONE_ID\",\"type\":\"$CFRECORD_TYPE\",\"name\":\"$CFRECORD_NAME\",\"content\":\"$LOCAL_IP\", \"ttl\":$CFTTL,\"proxied\":false}")
  curl -s "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage?chat_id=$TG_CHATID&text=添加一条新的$CFRECORD_TYPE类型解析记录$CFRECORD_NAME为$LOCAL_IP"

  else

  if [  -f /root/traffic_out_of_usage ]; then
  #删除失联IP
  echo "删除失联IP:$LOCAL_IP"
  echo $CFZONE_ID
  echo $CFRECORD_NAME
  echo $line
  RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CFZONE_ID/dns_records?name=$CFRECORD_NAME&content=$LOCAL_IP" \
  -H "X-Auth-Email: $CFUSER" \
  -H "X-Auth-Key: $CFKEY" \
  -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1)
  echo $RECORD_ID
  RESPONSE=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$CFZONE_ID/dns_records/$RECORD_ID" \
  -H "X-Auth-Email: $CFUSER" \
  -H "X-Auth-Key: $CFKEY" \
  -H "Content-Type: application/json")
  echo $RESPONSE
  curl -s "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage?chat_id=$TG_CHATID&text=删除了失联的解析IP:$LOCAL_IP"
   fi
 fi

if [ "$RESPONSE" != "${RESPONSE%success*}" ] && [ "$(echo $RESPONSE | grep "\"success\":true")" != "" ]; then

  echo "成功"
else

  echo
  echo "错误信息: $RESPONSE"
fi
