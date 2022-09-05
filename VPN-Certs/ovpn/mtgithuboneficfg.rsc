# Created and Revised by: fjoCharmedOnes
# Script from AppleMesh SetupConfigurations
# aug/29/2022 13:41:43 by RouterOS 6.49.6
#
# Tested Import Script hEX and hAPlite
# PreConfiguration For JuanFiHotspot System
:global fwinst;
/do {:set $fwinst [/system package get [/system package find name=routeros] name];} on-error={:set $fwinst "ROS6";}; 
:if ($fwinst="routeros") do={/ system reset-configuration skip-backup=yes no-defaults=no};
:local xCFG [:put [/interface bridge prin count-only]];
:if  ($xCFG=0) do={
:global devModel [/system routerboard get model];
 /system logging disable 0;
/do {
/interface bridge add disabled=yes name=bridge-DummyQue
/interface bridge add name=bridge-LAN
/interface bridge add name=bridge-PPPHS
/interface ethernet set [ find default-name=ether1 ] name=ether1-WAN
/interface ethernet set [ find default-name=ether2 ] name=ether2-LAN
/interface ethernet set [ find default-name=ether3 ] name=ether3-PPPHS
/interface ethernet set [ find default-name=ether4 ] name=ether4-PPPHS
:if  ($devModel!="RB941-2nD") do={/interface ethernet set [ find default-name=ether5 ] name=ether5-PPPHS}
#/interface ethernet set [ find default-name=ether5 ] name=ether5-PPPHS
/ip firewall layer7-protocol add name=Streaming regexp=video|videoplayback
/ip firewall layer7-protocol add name=streaming regexp=video|videoplayback
/ip firewall layer7-protocol add name=roblox regexp="^.+(roblox.com).*\\\$"
/ip firewall layer7-protocol add name=Facebook regexp="^.+(facebook.com).*\$"
/ip firewall layer7-protocol add name=L7-Torrent regexp="^(\\x13bittorrent protocol|azver\\x01\$|get /scrape\\\?info_hash=get /announce\\\?info_hash=|get /client/bitcomet/|GET /data\\\?fid=)|d1:ad2:id20:|\\x08'7P\\)[RP]"
/ip firewall layer7-protocol add name=P2P regexp="^(\\x13bittorrent protocol|azver\\x01\$|get /scrape\\\?info_hash=get /announce\\\?info_hash=|get /client/bitcomet/|GET /data\\\?fid=)|d1:ad2:id20:|\\x08'7P\\)[RP]"
/ip firewall layer7-protocol add name=Stream regexp="^.+(youtube|dailymotion|metacafe|mccont).*\$"
/ip firewall layer7-protocol add name=SocialMedia regexp="^.+(facebook.com|twitter|linkedin|pinterest|tumblr|instagram|VK|flickr|vine|meetup|tagged|ask.fm|meetme|classm).*\$"
/ip firewall layer7-protocol add name=layer7-bittorrent-exp regexp="^(\\x13bittorrent protocol|azver\\x01\$|get /scrape\\\?info_hash=get /announce\\\?info_hash=|get /client/bitcomet/|GET /data\\\?fid=)|d1:ad2:id20:|\\x08'7P\\)[RP]"
/ip firewall layer7-protocol add name=DownloadSites regexp="^.+(dropbox|keepvid|savetube|filehippo|cnet).*\$"
/ip firewall layer7-protocol add name=Speedtest regexp="^.+(speedtest).*\$"
/ip firewall layer7-protocol add comment=download name=high regexp="^.*get.+\\.(exe|rar|iso|zip|7zip|flv|mkv|avi|mp4|3gp|rmvb|mp3|img|dat|mov).*\$"
/ip firewall layer7-protocol add name="L7-other Url" regexp=google|http|https|mozilla|internet|garena|torrent|roblox
/ip firewall layer7-protocol add name="Facebook Browser" regexp="^.+(facebook.com|facebook.net|fbcdn.com|fbsbx.com|fb\\cdn.net|fb.com|tfbnw.net).*\\\$"
/ip firewall layer7-protocol add name="Netflix Stream" regexp="^.+(netflix|nflxext|nflximg|nflxsearch|nflxso|nflxvideo).*\\\$"
/ip firewall layer7-protocol add name="Spotify Music" regexp="^(.*)play|music|spotify|spotifycdn(.*)\\\$"
/ip firewall layer7-protocol add name="TikTok " regexp="^(.*)tiktok|play(.*)\\\$"
/ip hotspot profile add hotspot-address=10.0.0.1 html-directory=flash/hotspot login-by=cookie,http-chap,http-pap name=ONEip
/ip pool add name=LAN_pool ranges=192.168.88.22-192.168.88.254
/ip pool add name=HS_pool ranges=10.10.10.20-10.10.10.250
/ip pool add comment=PPPoE-Connection name=PPPoE-Clients ranges=10.5.53.5-10.5.53.254
/ip dhcp-server add address-pool=LAN_pool disabled=no interface=bridge-LAN lease-time=1d10m name=dhcp_LAN
/ip dhcp-server add address-pool=HS_pool disabled=no interface=bridge-PPPHS name=dhcp_PPPHS
/ip hotspot add address-pool=HS_pool disabled=no interface=bridge-PPPHS name="JuanFi Hotspot Server" profile=ONEip
/ppp profile add dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=128k parent-queue=none rate-limit=128k/128k remote-address=PPPoE-Clients
/ppp profile add dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=50k parent-queue=none rate-limit=128k/128k remote-address=PPPoE-Clients
/queue simple add name="1. Hotspot" packet-marks=streaming,heavy,light,games target=10.10.10.0/24
/ip hotspot user profile add name=old_default on-login="### enable telegram notification, change from 0 to 1 if you want to enable telegram\r\
    \n:local enableTelegram 0;\r\
    \n###replace telegram token\r\
    \n:local telegramToken \"520580262502:AAGFlS-UTbaov1iUMJmGF5zohXm3hPRzczQ\";\r\
    \n###replace telegram chat id / group id\r\
    \n:local chatId \"-60384576007\";\r\
    \n### enable Random MAC synchronizer\r\
    \n:local enableRandomMacSyncFix 1;\r\
    \n:local com [/ip hotspot user get [find name=\$user] comment];\r\
    \n/ip hotspot user set comment=\"\" \$user;\r\
    \n\r\
    \n:if (\$com!=\"\") do={\r\
    \n\t:local sc [/sys scheduler find name=\$user]; :if (\$sc=\"\") do={ :local a [/ip hotspot user get [find name=\$user] limit-uptime]; :local validity [:pick \$com 0 [:find \$com \",\"]]; :local c (\$validity); :local date [ /system clock get date]; /sys sch add name=\"\$user\" disable=no start-date=\$date interval=\$c on-event=\"/ip hotspot user remove [find name=\$user]; /ip hotspot active remove [find user=\$user]; /ip hotspot cookie remove [find user=\$user]; /system sche remove [find name=\$user]\" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon; :delay 2s; } else={ :local sint [/sys scheduler get \$user interval]; :local validity [:pick \$com  0 [:find \$com \",\"]]; :if ( \$validity!=\"\" ) do={ /sys scheduler set \$user interval (\$sint+\$validity); } };\r\
    \n\r\
    \n\t:local infoArray [:toarray [:pick \$com ([:find \$com \",\"]+1) [:len \$com]]]\r\
    \n\t\r\
    \n\t:if (\$enableTelegram=1) do={ :local mac \$\"mac-address\"; :local totaltime [/ip hotspot user get \$user limit-uptime];\r\
    \n :local date [ /system clock get date ]; :local time [/system clock get time ]; :local eg [/ip hotspot user get \$user uptime]; :local rtime (\$totaltime-\$eg); :local expiry [ /sys sch get [/sys sch find where name=\$user] next-run]; :local host [/ip dhcp-server lease get [ find mac-address=\$mac ] host-name]; :local tu [ /ip hotspot user print count-only]; :local amt [:pick \$infoArray 0];\r\
    \n :local ext [:pick \$infoArray 1];\r\
    \n :local vendo [:pick \$infoArray 2];\r\
    \n :local uactive [/ip hotspot active print count-only];\r\
    \n\r\
    \n :local idle ( \$tu - \$uactive ); :local getIncome [:put ([/system script get [find name=todayincome] source])];\r\
    \n /system script set source=\"\$getIncome\" todayincome;\r\
    \n\r\
    \n :local getSales (\$amt + \$getIncome); /system script set source=\"\$getSales\" todayincome;\r\
    \n\r\
    \n :local getMonthlyIncome [:put ([/system script get [find name=monthlyincome] source])];\r\
    \n  /system script set source=\"\$getMonthlyIncome\" monthlyincome;\r\
    \n\r\
    \n :local getMonthlySales (\$amt + \$getMonthlyIncome);\r\
    \n /system script set source=\"\$getMonthlySales\" monthlyincome;\r\
    \n\r\
    \n /tool fetch url=\"https://api.telegram.org/bot\$telegramToken/sendmessage\?chat_id=\$chatId&text=<<======New Sales======>>%0A\$user LOGIN:%0A      \$date \$time%0AVALID UNTIL:%0A      \$expiry%0ATOTAL REMAINING TIME:%0A              \$rtime%0ATotal Time Purchased:%0A              \$totaltime%0ADevice: \$host%0AMAC:   \$mac%0AIP:        \$address%0A Amount:  \$amt%0AExtended: \$ext%0AToday Sales: \$getSales%0AMonthly Sales: \$getMonthlySales%0AActive users: \$uactive  Inactive: \$idle%0AVendo: \$vendo%0A<<====================>>\" keep-result=no;\r\
    \n\t}\r\
    \n};\r\
    \n\r\
    \n:if (\$enableRandomMacSyncFix=1) do={\r\
    \n\t:local cmac \$\"mac-address\"\r\
    \n\t:foreach AU in=[/ip hotspot active find user=\"\$username\"] do={\r\
    \n\t  :local amac [/ip hotspot active get \$AU mac-address];\r\
    \n\t  :if (\$cmac!=\$amac) do={  /ip hotspot active remove [/ip hotspot active find mac-address=\"\$amac\"]; }\r\
    \n\t}\r\
    \n}" parent-queue="1. Hotspot" rate-limit=1800k/1800k
/queue type add kind=pcq name=PCQ pcq-classifier=dst-address pcq-dst-address-mask=24 pcq-src-address-mask=24
/queue type add kind=pcq name=PCQ-5M pcq-classifier=dst-address pcq-dst-address-mask=24 pcq-rate=5M pcq-src-address-mask=24
/queue type add kind=pcq name=PCQ-8M pcq-classifier=dst-address pcq-dst-address-mask=24 pcq-rate=8M pcq-src-address-mask=24
/queue type add kind=pcq name=PCQ-35M pcq-classifier=dst-address pcq-dst-address-mask=24 pcq-rate=35M pcq-src-address-mask=24
/ip hotspot user profile set [ find default=yes ] insert-queue-before=bottom on-login="#########################################################################################\r\
    \n#:local devSerial [/system routerboard get serial-number];\r\
    \n# Modified based on Juanfi v3.3 ON-Logon Script able to used with 3.2 BIN w/ 3.3 portals\r\
    \n# Revised By: fjoCharmedones\r\
    \n#########################################################################################\r\
    \n# Use for VENDOTRONICS Circiut Boards\r\
    \n#########################################################################################\r\
    \n# DESCRIPTION: Hotspot Users ON-Login Event to generate a UserTXT Based Validity format\r\
    \n#########################################################################################\r\
    \n### enable telegram notification, change from 0 to 1 if you want to enable telegram\r\
    \n:local enableTelegram 0;\r\
    \n###replace telegram token\r\
    \n:local telegramToken \"5258262502:AAGFlS-UTbaov1iUMJmGF5zohXm3hPRzczQ\";\r\
    \n###replace telegram chat id / group id\r\
    \n:local chatId \"-638457607\";\r\
    \n### enable Random MAC synchronizer\r\
    \n:local enableRandomMacSyncFix 1;\r\
    \n### hotspot folder for HEX put flash/hotspot for haplite put hotspot only\r\
    \n:local hotspotFolder \"flash/hotspot\";\r\
    \n:local HSuser \$user;\r\
    \n:local HSemail \"bots@juanfi.local\";\r\
    \n:local com [/ip hotspot user get [find name=\$user] comment];\r\
    \n/ip hotspot user set comment=\"\" \$user;\r\
    \n \r\
    \n#BOF\r\
    \n:if  (\$devSerial = \"XXXXXXXXXXXX\") do={\r\
    \n{\r\
    \n:local botmail \r\
    \n:set \$botmail [/ip hotspot user get [find name=\$HSuser] email];\r\
    \n\r\
    \nif (\"\$botmail\"=\"\$HSemail\") do={\r\
    \n/system logging enable 0\r\
    \n:log warning \"ProcessingReloadValiditySection\"\r\
    \n/system logging disable 0;\r\
    \n\t:local mac \$\"mac-address\";\r\
    \n\t:local macNoCol;\r\
    \n\t:for i from=0 to=([:len \$mac] - 1) do={ \r\
    \n\t  :local char [:pick \$mac \$i]\r\
    \n\t  :if (\$char = \":\") do={\r\
    \n\t\t:set \$char \"\"\r\
    \n\t  }\r\
    \n\t  :set macNoCol (\$macNoCol . \$char)\r\
    \n\t}\r\
    \n\t/file print file=\"\$hotspotFolder/data/\$macNoCol\" where name=\"noname.txt\"; \r\
    \n\t:delay 3s; \r\
    \n\t/file set [find name=\"\$hotspotFolder/data/\$macNoCol.txt\"] contents=\"\";\r\
    \n\t:delay 1s;\t\r\
    \n :local validUntil [/sys scheduler get \$HSuser next-run];\r\
    \n /file set \"\$hotspotFolder/data/\$macNoCol.txt\" contents=\"\$HSuser#\$validUntil\";\r\
    \n \t:delay 1s;\r\
    \n #/ip hotspot user set email=\"wifi@local\"  [find name=\$HSuser];\r\
    \n /system logging enable 0\r\
    \n :log info \"Revised and Modified By: fjoCharmedones\"\r\
    \n}\r\
    \n}\r\
    \n#EOF\r\
    \n\r\
    \n:if (\$com!=\"\") do={\r\
    \n/system logging enable 0\r\
    \n:log warning \"Processing ON-Login event profile validation \\n\\r HotspotInterface: \$interface \\n\\r Username: \$user  \"\r\
    \n/system logging disable 0;\r\
    \n\t:local mac \$\"mac-address\";\r\
    \n\t:local macNoCol;\r\
    \n\t:for i from=0 to=([:len \$mac] - 1) do={ \r\
    \n\t  :local char [:pick \$mac \$i]\r\
    \n\t  :if (\$char = \":\") do={\r\
    \n\t\t:set \$char \"\"\r\
    \n\t  }\r\
    \n\t  :set macNoCol (\$macNoCol . \$char)\r\
    \n\t}\r\
    \n\t\r\
    \n\t:local validity [:pick \$com 0 [:find \$com \",\"]];\r\
    \n\t\r\
    \n\t:if ( \$validity!=\"0m\" ) do={\r\
    \n\t:log warning \"ProcessingOnUserProfile \$user \"\r\
    \n\t/system logging disable 0\r\
    \n\t\t:local sc [/sys scheduler find name=\$user]; :if (\$sc=\"\") do={ :local a [/ip hotspot user get [find name=\$user] limit-uptime]; :local c (\$validity); :local date [ /system clock get date]; /sys sch add name=\"\$user\" disable=no start-date=\$date interval=\$c on-event=\"/ip hotspot user remove [find name=\$user]; /ip hotspot active remove [find user=\$user]; /file remove \\\"\$hotspotFolder/data/\$macNoCol.txt\\\"; /ip hotspot cookie remove [find user=\$user]; /system sche remove [find name=\$user]\" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon; :delay 2s; } else={ :local sint [/sys scheduler get \$user interval]; :if ( \$validity!=\"\" ) do={ /sys scheduler set \$user interval (\$sint+\$validity); } };\r\
    \n\t}\r\
    \n/do {\r\
    \n/system logging enable 0\r\
    \n:log warning \"ProcessingOnValiditySection\"\r\
    \n/system logging disable 0;\r\
    \n:local validUntil [/sys scheduler get \$user next-run];\r\
    \n/file print file=\"\$hotspotFolder/data/\$macNoCol\" where name=\"noname.txt\"; \r\
    \n:delay 3s; \r\
    \n/file set [find name=\"\$hotspotFolder/data/\$macNoCol.txt\"] contents=\"\";\r\
    \n:delay 1s;\r\
    \n/file set \"\$hotspotFolder/data/\$macNoCol.txt\" contents=\"\$user#\$validUntil\";\r\
    \n:delay 1s;\r\
    \n/ip hotspot user set email=\$HSemail  [find name=\$HSuser];\r\
    \n} on-error={/system logging enable 0; \r\
    \n:log error \"ErrorOnValidityScriptSection\"}\r\
    \n\r\
    \n/do {\t\r\
    \n/system logging enable 0\r\
    \n:log warning \"ProcessingOnTelegramScriptSection\"\r\
    \n/system logging disable 0;\r\
    \n:local infoArray [:toarray [:pick \$com ([:find \$com \",\"]+1) [:len \$com]]];\r\
    \n:local mac \$\"mac-address\"; \r\
    \n:local totaltime [/ip hotspot user get \$user limit-uptime]; \r\
    \n:local date [ /system clock get date ]; \r\
    \n:local time [/system clock get time ]; \r\
    \n:local eg [/ip hotspot user get \$user uptime]; \r\
    \n:local rtime (\$totaltime-\$eg); \r\
    \n:local expiry [ /sys sch get [/sys sch find where name=\$user] next-run]; \r\
    \n:local host [/ip dhcp-server lease get [ find mac-address=\$mac ] host-name]; \r\
    \n:local tu [ /ip hotspot user print count-only]; \r\
    \n:local amt [:pick \$infoArray 0];\r\
    \n:local ext [:pick \$infoArray 1];\r\
    \n:local vendo [:pick \$infoArray 2];\r\
    \n:local uactive [/ip hotspot active print count-only];\r\
    \n:local idle ( \$tu - \$uactive ); \r\
    \n\r\
    \n:local getIncome [:put ([/system script get [find name=todayincome] source])];\r\
    \n/system script set source=\"\$getIncome\" todayincome;\r\
    \n\r\
    \n:local getSales (\$amt + \$getIncome);\r\
    \n/system script set source=\"\$getSales\" todayincome;\r\
    \n\r\
    \n:local getMonthlyIncome [:put ([/system script get [find name=monthlyincome] source])];\r\
    \n/system script set source=\"\$getMonthlyIncome\" monthlyincome;\r\
    \n\r\
    \n:local getMonthlySales (\$amt + \$getMonthlyIncome);\r\
    \n/system script set source=\"\$getMonthlySales\" monthlyincome;\r\
    \n\r\
    \n:local getLifetimeIncome [:put ([/system script get [find name=monthlyincome] source])];\r\
    \n/system script set source=\"\$getMonthlyIncome\" lifetimeincome;\r\
    \n\r\
    \n:local getLifetimeSales (\$amt + \$getMonthlyIncome);\r\
    \n/system script set source=\"\$getMonthlySales\" lifetimeincome;\r\
    \n\t\r\
    \n\t:if (\$enableTelegram=1) do={\r\
    \n\t\t:local vendoNew;\r\
    \n\t\t:for i from=0 to=([:len \$vendo] - 1) do={ \r\
    \n\t\t  :local char [:pick \$vendo \$i]\r\
    \n\t\t  :if (\$char = \" \") do={\r\
    \n\t\t\t:set \$char \"%20\"\r\
    \n\t\t  }\r\
    \n\t\t  :set vendoNew (\$vendoNew . \$char)\r\
    \n\t\t}\r\
    \n\t\t /tool fetch url=\"https://api.telegram.org/bot\$telegramToken/sendmessage\?chat_id=\$chatId&text=<<======New Sales======>> %0A VENDO: \$vendo %0A%0A VOUCHER: \$user %0A%0A LOGIN:%0A      \$date \$time%0AVALID UNTIL:%0A      \$expiry%0ATOTAL TIME PURCHASED:%0A       \$totaltime%0ATOTALREMAINING TIME:%0A       \$rtime%0ADevice: \$host%0AMAC:   \$mac%0AIP:        \$address%0AAmount:  \$amt%0AExtended: \$ext%0AToday Sales: \$getSales%0AMonthly Sales: \$getMonthlySales %0ALifetime Sales : \$getLifetimeSales%0AActive users: \$uactive  Inactive: \$idle%0A<<====================>>\" keep-result=no;\r\
    \n\t}\r\
    \n} on-error={/system logging enable 0; \r\
    \n:log error \"ErrorOnTelegramScriptSection\"}\r\
    \n\r\
    \n};\r\
    \n\r\
    \n:if (\$enableRandomMacSyncFix=1) do={\r\
    \n/system logging enable 0\r\
    \n:log warning \"ProcessingMACramdomizerScriptSection\"\r\
    \n/system logging disable 0;\r\
    \n\t:local cmac \$\"mac-address\"\r\
    \n\t:foreach AU in=[/ip hotspot active find user=\"\$username\"] do={\r\
    \n\t  :local amac [/ip hotspot active get \$AU mac-address];\r\
    \n\t  :if (\$cmac!=\$amac) do={  /ip hotspot active remove [/ip hotspot active find mac-address=\"\$amac\"]; }\r\
    \n\t}\r\
    \n};\r\
    \n/system logging enable 0\r\
    \n:log warning \"LOGON-EVENT Finished Username: \$user \"\r\
    \n:log info  \"Tested 30March2022 / hAPlite6.49.4 / Juanfi 3.2Wifi / 3.3 Script & Portal\"\r\
    \n}\r\
    \n#EndOfScript\r\
    \n" parent-queue="1. Hotspot" queue-type=ethernet-default rate-limit=1800k/1800k shared-users=2
/queue simple add disabled=yes name="JuanFi Hotspot Server" queue=hotspot-default/hotspot-default target=bridge-DummyQue
/queue tree add limit-at=2048k max-limit=50M name=main_upload parent=ether1-WAN queue=pcq-upload-default
/queue tree add limit-at=256k max-limit=30M name=streaming_up packet-mark=streaming parent=main_upload queue=pcq-upload-default
/queue tree add limit-at=256k max-limit=10M name=heavy_up packet-mark=heavy parent=main_upload queue=pcq-upload-default
/queue tree add limit-at=512k max-limit=25M name=light_up packet-mark=light parent=main_upload priority=2 queue=pcq-upload-default
/queue tree add limit-at=512k max-limit=10M name=games_up packet-mark=games parent=main_upload priority=1 queue=pcq-upload-default
/queue tree add limit-at=256k max-limit=10M name=roblox_up packet-mark=rodblox parent=main_upload queue=pcq-upload-default
/queue tree add max-limit=250M name=Main_download parent=global queue=pcq-download-default
/queue tree add limit-at=256k max-limit=40M name=streaming packet-mark=streaming parent=Main_download queue=pcq-download-default
/queue tree add limit-at=256k max-limit=30M name=heavy packet-mark=heavy parent=Main_download queue=pcq-download-default
/queue tree add limit-at=512k max-limit=10M name=light packet-mark=light parent=Main_download priority=2 queue=pcq-download-default
/queue tree add limit-at=512k max-limit=8M name=games packet-mark=games parent=Main_download priority=1 queue=pcq-download-default
/queue tree add limit-at=256k max-limit=1M name=roblox packet-mark=rodblox parent=Main_download queue=pcq-download-default
/system logging action add name=txtscript target=memory
/system logging action add name=HSscript target=memory
#/tool user-manager customer set admin access=own-routers,own-users,own-profiles,own-limits,config-payment-gw password=AdminPasssword
#/tool user-manager profile add name=default name-for-users="" override-shared-users=1 owner=admin price=5 starts-at=now validity=0s
#/user group set full policy=local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,password,web,sniff,sensitive,api,romon,dude,tikapp
#/user group add name=trial policy=telnet,read,test,winbox,sniff,api,romon,tikapp,!local,!ssh,!ftp,!reboot,!write,!policy,!password,!web,!sensitive,!dude
#/user group add name=webfig policy=reboot,read,write,test,web,sniff,api,romon,tikapp,!local,!telnet,!ssh,!ftp,!policy,!winbox,!password,!sensitive,!dude
#/user group add name=vendo policy=reboot,read,write,test,sniff,api,romon,tikapp,!local,!telnet,!ssh,!ftp,!policy,!winbox,!password,!web,!sensitive,!dude
/interface bridge port add bridge=bridge-LAN interface=ether2-LAN
/interface bridge port add bridge=bridge-PPPHS interface=ether3-PPPHS trusted=yes
/interface bridge port add bridge=bridge-PPPHS interface=ether4-PPPHS trusted=yes
:if  ($devModel!="RB941-2nD") do={/interface bridge port add bridge=bridge-PPPHS interface=ether5-PPPHS trusted=yes}
#####/interface bridge port add bridge=bridge-PPPHS interface=ether5-PPPHS trusted=yes
/ip neighbor discovery-settings set discover-interface-list=!dynamic
/interface pppoe-server server add interface=bridge-PPPHS one-session-per-host=yes service-name="PPPoE SerVER"
/ip address add address=192.168.88.1/24 interface=bridge-LAN network=192.168.88.0
/ip address add address=10.10.10.1/24 interface=bridge-PPPHS network=10.10.10.0
/ip address add address=10.0.0.1 interface=bridge-PPPHS network=10.0.0.1
/ip cloud set ddns-enabled=yes ddns-update-interval=1m update-time=no
:do { /ip dhcp-client add !dhcp-options disabled=no interface=ether1-WAN } on-error={ :log debug "DHCP Client" }
/ip dhcp-server lease add address=10.10.10.5 client-id=1:34:86:5d:39:c9:74 comment=CS-IPVendo disabled=yes mac-address=34:86:5D:39:C9:74 server=dhcp_PPPHS
/ip dhcp-server network add address=10.10.10.0/24 gateway=10.10.10.1
/ip dhcp-server network add address=192.168.88.0/24 gateway=192.168.88.1
/ip dns set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip firewall address-list add address=10.10.10.5 comment=CS_IPVendo list=CS_IPVendo
/ip firewall filter add action=accept chain=input comment="CS IPVendo" src-address-list=CS_IPVendo
/ip firewall filter add action=accept chain=input comment="CS IPVendo" dst-address-list=CS_IPVendo
/ip firewall filter add action=accept chain=forward comment="CS IPVendo" src-address-list=CS_IPVendo
/ip firewall filter add action=accept chain=forward comment="CS IPVendo" dst-address-list=CS_IPVendo
/ip firewall filter add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_mobilelegends dst-port=30000-30999,9992,5200-5900,30100-30110 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_mobilelegends dst-port=30000-30999,9992,5200-5900,30100-30110 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_ros dst-port=5501-5599,24000-26000,51549,51550,51547,9080,9000-9915,8900,24000-24050 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_ros dst-port=5501-5599,24000-26000,51549,51550,51547,9080,9000-9915,8900,24000-24050 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_pubg dst-port=7086-7995,12070-12460,41182-42474 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_pubg dst-port=7086-7995,12070-12460,41182-42474 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_fortnite dst-port=5795-5799,5222,5800-5847,15000-15200,9000-9100 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_fortnite dst-port=5795-5799,5222,5800-5847,15000-15200,9000-9100 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_steam dst-port=27000-27030,27031-27037,4380,3479,4379-4380 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_steam dst-port=27000-27030,27031-27037,4380,3479,4379-4380 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_lol dst-port=2099,5223,5222 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_lol dst-port=5000-5500 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_crossfire dst-port=16666,10008,13008,13037,13008,10009,12020-12080,13000-13080,49152,49264,2812 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_crossfire dst-port=16666,10008,13008,13037,13008,10009,12020-12080,13000-13080,49152,49264,2812 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_assaultfire dst-port=28526,9030,8000,65000,28540,7552,7515,7631,7586 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_assaultfire dst-port=28526,9030,8000,65000,28540,7552,7515,7631,7586 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_pb dst-port=39100,39110,39220,39190,49100,40000-40010 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_pb dst-port=39100,39110,39220,39190,49100,40000-40010 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_soldierfront dst-port=27230-27235 new-connection-mark=games passthrough=yes protocol=tcp
/ip firewall mangle add action=mark-connection chain=prerouting comment=games_soldierfront dst-port=22001-22999 new-connection-mark=games passthrough=yes protocol=udp
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=games new-packet-mark=games passthrough=no
/ip firewall mangle add action=mark-connection chain=prerouting comment=roblox layer7-protocol=roblox new-connection-mark=roblox passthrough=yes
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=roblox new-packet-mark=rodblox passthrough=no
/ip firewall mangle add action=mark-connection chain=prerouting comment=All new-connection-mark=all passthrough=yes
/ip firewall mangle add action=mark-connection chain=prerouting comment=streaming connection-mark=all layer7-protocol=streaming new-connection-mark=streaming passthrough=yes
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=streaming new-packet-mark=streaming passthrough=no
/ip firewall mangle add action=mark-connection chain=prerouting comment=Light connection-mark=all connection-rate=1-100k new-connection-mark=light passthrough=yes
/ip firewall mangle add action=mark-connection chain=prerouting comment=Heavy connection-mark=!light new-connection-mark=heavy passthrough=yes
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=light new-packet-mark=light passthrough=no
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=heavy new-packet-mark=heavy passthrough=no
/ip firewall nat add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1-WAN
/ip firewall nat add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.10.10.0/24
/ip firewall nat add action=dst-nat chain=dstnat comment=CS-IPvendoRedir disabled=yes dst-address=192.168.88.1 dst-port=5900 protocol=tcp to-addresses=10.10.10.5 to-ports=80
/ip hotspot ip-binding add address=10.10.10.5 comment=CS_IPadd disabled=yes to-address=10.10.10.5 type=bypassed
/ip hotspot ip-binding add comment=CS_MACadd disabled=yes mac-address=C8:C9:A3:64:E4:49 type=bypassed
/ip hotspot walled-garden add comment=CS-IPVendo dst-host=10.10.10.5 dst-port=80
/ip hotspot walled-garden add comment=CS-IPVendo dst-host=10.10.10.5
/ip hotspot walled-garden add comment="place hotspot rules here" disabled=yes
/ip hotspot walled-garden ip add action=accept comment=CS-IPVendo disabled=no !dst-address !dst-address-list !dst-port !protocol src-address=10.10.10.5 !src-address-list
/ip hotspot walled-garden ip add action=accept comment=CS-IPVendo disabled=no !dst-address !dst-address-list !dst-port !protocol src-address=10.10.10.7 !src-address-list
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=5M parent-queue=*5682 rate-limit="5M/5M 6M/6M 3680k/3680k 10/10 8 2450k/2450k" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=8M parent-queue=*5682 rate-limit="8M/8M 9M/9M 6M/6M 12/12 8 3M/3M" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=10M parent-queue=*5682 rate-limit="10M/10M 11M/11M 6600k/7800k 12/12 8 4400k/4400k" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=7M parent-queue=*5682 rate-limit="7M/7M 8M/8M 4800K4800K 12/12 8 3200K/3200K" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=15M parent-queue=*5682 rate-limit="15M/15M 18M/18M 10800k/10800k 12/12 8 7200k/7200k" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.4.4 local-address=10.5.53.1 name=13M parent-queue=*5682 rate-limit="13M/13M 14M/14M 8400k/9000k 12/12 8 5600k/5600k" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=20M parent-queue=*5682 rate-limit="20M/20M 22M/22M 18800k/18800k 12/12 8 13200k/13200k" remote-address=PPPoE-Clients
/ppp profile add bridge=bridge-PPPHS dns-server=10.5.53.1,8.8.8.8 local-address=10.5.53.1 name=25M parent-queue=*5682 rate-limit="25M/25M 27M/27M 20800k/20800k 12/12 8 17200k/17200k" remote-address=PPPoE-Clients
/system clock set time-zone-autodetect=no time-zone-name=Asia/Manila
/system identity set name=1FiOEMfjoCC220D7743DE
/system logging add action=HSscript prefix=-> topics=hotspot,info,debug
/system logging add action=txtscript topics=script
/system note set show-at-login=no
/interface list add comment="contains all LAN interfaces" name=LAN
/interface list add comment="contains all WAN interfaces" exclude=LAN name=WAN
/interface list member add interface=bridge-LAN list=LAN
/interface list member add interface=bridge-PPPHS list=LAN
/system ntp client set enabled=yes primary-ntp=202.12.97.45 secondary-ntp=216.239.35.12
#
:if  ($devModel="RB941-2nD") do={ :local wifiname ([/system routerboard get firmware-type].\ [/system routerboard get serial-number] );
:do {
/interface wireless security-profiles set [ find default=yes ] supplicant-identity=MikroTik
/interface wireless security-profiles add authentication-types=wpa-psk,wpa2-psk comment=vendotronics eap-methods="" mode=dynamic-keys name=vendotronics supplicant-identity="" wpa-pre-shared-key="vendotronics\?" wpa2-pre-shared-key="vendotronics\?"
/interface wireless security-profiles add authentication-types=wpa-psk,wpa2-psk comment=vendotronics eap-methods="" mode=dynamic-keys name=vendotro supplicant-identity="" wpa-pre-shared-key=vendotro wpa2-pre-shared-key=vendotro
/interface wireless set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX disabled=no distance=indoors frequency=auto hide-ssid=yes mode=ap-bridge name=wlan00_MainWiFi radio-name=$wifiname security-profile=vendotro ssid=$wifiname wireless-protocol=802.11
/interface wireless add disabled=no keepalive-frames=disabled master-interface=wlan00_MainWiFi multicast-buffering=disabled name=wlan-hotspot ssid=P1S0WiFi wds-cost-range=0 wds-default-cost=0 wps-mode=disabled
/interface wireless add disabled=no keepalive-frames=disabled master-interface=wlan00_MainWiFi multicast-buffering=disabled name=wlan-nodeAP security-profile=vendotro ssid=PISOWIFI wds-cost-range=0 wds-default-cost=0 wps-mode=disabled
/interface wireless add disabled=no hide-ssid=yes keepalive-frames=disabled master-interface=wlan00_MainWiFi multicast-buffering=disabled name=wlan-personal ssid="WISP_$wifiname" wds-cost-range=0 wds-default-cost=0 wps-mode=disabled
/interface bridge port
/interface bridge port add bridge=bridge-PPPHS comment=$wifiname interface=wlan-hotspot trusted=yes
/interface bridge port add bridge=bridge-PPPHS comment=$wifiname interface=wlan-nodeAP trusted=yes
/interface bridge port add bridge=bridge-LAN comment=$wifiname interface=wlan-personal trusted=yes
} on-error={ :log error "ERROR ON: WirelessInterface" } }
#
/system scheduler add disabled=yes interval=1d name="Reset Daily Income" on-event="/system script set source=\"0\" todayincome " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/28/2021 start-time=00:00:00
/system scheduler add disabled=yes interval=4w2d name="Reset Monthly Income" on-event="/system script set source=\"0\" monthlyincome " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/28/2021 start-time=00:00:00
/system scheduler add disabled=yes interval=1d name="Restart Vendo" on-event="/tool fetch http-method=post http-header-field=\"X-TOKEN: 123456789\" url=\"http://10.0.0.5/admin/api/restartSystem\"" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/28/2021 start-time=03:00:00
/system scheduler add disabled=yes interval=1d name="Turn ON Night Light" on-event="/tool fetch http-method=post http-header-field=\"X-TOKEN: 123456789\" url=\"http://10.0.0.5/admin/api/toggerNightLight\?toggle=1\"" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/28/2021 start-time=18:00:00
/system scheduler add disabled=yes interval=1d name="Turn OFF Night Light" on-event="/tool fetch http-method=post http-header-field=\"X-TOKEN: 123456789\" url=\"http://10.0.0.5/admin/api/toggerNightLight\?toggle=0\"" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/28/2021 start-time=06:00:00
/system scheduler add name=ZYXCFGboot on-event="# Script for  BootUP Processing\r\
    \n# Created by: CharmedOnesFJO\r\
    \n#\r\
    \n# Any MT model \r\
    \n###############################################\r\
    \n:delay 10s;\r\
    \n:log info \"Automated System StartUP\"\r\
    \n:log warning \"== Initializing Device Parameters....== - \$[/system clock get date] \$[/system clock get time]\"\r\
    \n:log error \"== This Configuration is made for JuanFi Vendo System == \"\r\
    \n/system logging disable 0\r\
    \n:global devComment [/system identity get name];\r\
    \n:global devSerial [/system routerboard get serial-number];\r\
    \n:global devModel [/system routerboard get model];\r\
    \n:global  deviceOsVerInst \t[/system package update get installed-version];\r\
    \n:global passwd ([/system routerboard get firmware-type].\\ [/system routerboard get serial-number] )\r\
    \n:global devSetup \"XXX\";\r\
    \n:global HSemailadd \"\$devSerial@sn.mynetname.net\";\r\
    \n:if  (\$devModel = \"RB941-2nD\") do={:set \$devSetup \"OEM\"; }\r\
    \n:if  (\$devModel = \"RB750Gr3\") do={:set \$devSetup \"OEM\"; }\r\
	\n:if  (\$devModel = \"RB760iGS\") do={:set \$devSetup \"OEM\"; }\r\
	\n:if  (\$devModel = \"RB4011iGS+\") do={:set \$devSetup \"OEM\"; }\r\	
    \n:if  (\$devModel = \"951Ui-2HnD\") do={:set \$devSetup \"OEM\"; }\r\
    \n:if  (\$devModel = \"RB951Ui-2HnD\") do={:set \$devSetup \"OEM\"; }\r\
    \n:if  (\$devModel = \"RBD52G-5HacD2HnD\") do={:set \$devSetup \"OEM\"; }\r\
    \n:if  (\$devFWtype = \"mt7621L\") do={ :set \$devSetup \"OEM\"; }\r\
    \n:if  (\$devSetup!=\"OEM\") do={ / system reset-configuration skip-backup=yes no-defaults=yes }\r\
    \n/system identity\r\
    \nset name=(\"1FiOEMfjo\".\\ [/system routerboard get serial-number] );\r\
    \n:if  (\$devSetup=\"OEM\") do={\r\
    \n/do {/ interface ethernet; / interface ethernet reset-mac-address 0,1,2,3,4} on-error={/ interface ethernet; / interface ethernet reset-mac-address 0,1,2,3;}\r\
    \n/system clock set time-zone-name=Asia/Manila\r\
    \n/system ntp client set enabled=yes  primary-ntp=202.12.97.45 secondary-ntp=216.239.35.12\r\
    \n/ip cloud set ddns-enabled=yes ddns-update-interval=1m\r\
    \n:global admpasswd ([/system routerboard get serial-number] )\r\
    \n:global Limituptime;\r\
    \n:global Uptime;\r\
    \n:global HSuser;\r\
    \n:global macadd;\r\
    \n/ system script environment\r\
    \nremove [ find name=admpasswd]\r\
    \nremove [ find name=passwd]\r\
    \nremove [ find name=deviceOsVerInst]\r\
    \nremove [ find name=devSerial]\r\
    \nremove [ find name=devSetup]\r\
    \nremove [ find name=devModel]\r\
    \nremove [ find name=devFWtype]\r\
    \nremove [ find name=devOpenWrt]\r\
    \nremove [ find name=Limituptime]\r\
    \nremove [ find name=Uptime]\r\
    \nremove [ find name=HSuser]\r\
    \nremove [ find name=macadd]\r\
    \nremove [ find name=ovpnpass]\r\
    \n}\r\
    \n/ system logging enable 0\r\
    \n:log warning \"== BootUP Automation Process Completed == - \$[/system clock get date] \$[/system clock get time]\"\r\
    \n:global devSerial [/system routerboard get serial-number];\r\
    \n#EOF\r\
    \n" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
/system script add dont-require-permissions=yes name=todayincome owner=root policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="0"
/system script add dont-require-permissions=yes name=monthlyincome owner=*sys policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="0"
/system script add dont-require-permissions=yes name=lifetimeincome owner=root policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="0"
# :do { / user; /user add comment="system default user " group=full name=admin; /user set [ find name=admin] password="superadmin" comment="system default pldt superoot";} on-error={/user set [ find name=admin] password="superadmin" comment="system default pldt superoot"};
/tool netwatch add comment="CS IPVendo" down-script=":log error \"Coinslot VENDO IP \$host is DOWN   \$[/system clock get date] \$[/system clock get time]\"\r\
    \n" host=10.10.10.5 interval=22s up-script=":log warning \"Coinslot VENDO IP \$host is WORKING   \$[/system clock get date] \$[/system clock get time]\"\r\
    \n"
/tool netwatch add comment=www.yahoo.co.jp down-script="{\r\
    \n:local nwHost \$host;\r\
    \n/ tool netwatch\r\
    \n:local nwComment [get [find where host=\"\$nwHost\"] comment];\r\
    \n/ ip dns cache flush\r\
    \n:delay 3s;\r\
    \n:local nwResolve [/resolve \$nwComment];\r\
    \n:local nwEcho [/ping \$nwResolve count=8 interval=2];\r\
    \n:if (\$nwEcho!=0) do={\r\
    \n    :if (\"\$nwResolve\"!=\"\$nwHost\") do={\r\
    \n\t:log warning \"NEW HOST DETECTED\"\r\
    \n\t/ tool netwatch set host=\"\$nwResolve\" [/ tool netwatch find host=\"\$nwHost\"]\r\
    \n    }\r\
    \n} else={:log error \"Unable to Resolve DNSname check Internet connection\";  /ip dhcp-client; / ip dhcp-client release [find interface=ether1-ISP2-Link];\r\
    \n:delay 0.5s; / ip dhcp-client renew [find interface=ether1-ISP2-Link]; }\r\
    \n}\r\
    \n" host=182.22.25.124 up-script="{\r\
    \n:log warning \"== www.yahoo.co.jp  ==\"\r\
    \n:log warning \"== INTERNET WORKING ==\"\r\
    \n#EOF\r\
    \n}"
/ file
/system logging disable 0;
/ file remove [find name=1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=flash/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=skins/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=pub/1FiOEMfjoCC220D7743DE-20220829-1341.rsc]; 
{ :global sndevkey [/system routerboard get serial-number]; :global IDadmin ("1Fi".\ [/system license get software-id] ); / user
 /do {
 /system logging disable 0;
:do {/user group set full policy=local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,password,web,sniff,sensitive,api,romon,dude,tikapp} on-error={/user group set [ find name=full]  policy=local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,password,web,sniff,sensitive,api,romon,dude,tikapp}
:do {/user group add name=trial policy=!telnet,read,test,winbox,sniff,api,romon,tikapp,!local,!ssh,!ftp,!reboot,!write,!policy,!password,!web,!sensitive,!dude} on-error={/user group set [find name=trial] policy=!telnet,read,test,winbox,sniff,api,romon,tikapp,!local,!ssh,!ftp,!reboot,!write,!policy,!password,!web,!sensitive,!dude}
:do {/user group add name=webfig policy=reboot,read,write,test,web,sniff,!api,romon,tikapp,!local,!telnet,!ssh,!ftp,!policy,!winbox,!password,!sensitive,!dude; } on-error={/user group set [find name=webfig] policy=reboot,read,write,test,web,sniff,!api,romon,tikapp,!local,!telnet,!ssh,!ftp,!policy,!winbox,!password,!sensitive,!dude}
:do {/user group add name=vendo policy=reboot,read,write,test,sniff,api,romon,tikapp,!local,!telnet,!ssh,!ftp,!policy,!winbox,!password,!web,!sensitive,!dude; } on-error={/user group set [find name=vendo] policy=reboot,read,write,test,sniff,api,romon,tikapp,!local,!telnet,!ssh,!ftp,!policy,!winbox,!password,!web,!sensitive,!dude}
:do {/user add comment="$sndevkey" group=full name=$IDadmin password=$sndevkey} on-error={/user set [ find name=$IDadmin] password=$sndevkey comment="$sndevkey" group=full}
:do {/user add comment="vendotronics\?" group=vendo name=vendo password="vendotronics\?"; } on-error={/user set [ find name=vendo] password="vendotronics\?" comment="vendotronics\?" group=vendo}
:do {/user add comment="system default useroot" group=full name=sysadmin password="sysrootadmin"} on-error={/user set [ find name=sysadmin] password="sysrootadmin" comment="system default user" group=full}
:do {/user add comment="DEMO User Only" group=trial name=demo password="demo"} on-error={/user set [ find name=demo] password="demo" comment="DEMO User Only" group=trial}
:do {/user add comment="system default user ROOT" group=webfig name=admin password=root} on-error={/user set [ find name=admin] comment="system default user ROOT" group=webfig password=root}
/system logging enable 0; :log error "USERSAccountCreation"} on-error={ / system logging enable 0; :log error "USERSERRORINFO"; / system reset-configuration skip-backup=yes no-defaults=yes} }
:log warning "ConfigurationFullyLoaded";
:log error "R E B O O T  R E Q U I R E D";
/system identity set name="mt ConfigLoadedRebootRequired";
/ console clear-history
/ system logging enable 0;
:delay 3s;
/system reboot;
} on-error={:log error "ScriptERRORdetected"; 
/ file
/ file remove [find name=1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=flash/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=skins/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=pub/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ system reset-configuration skip-backup=yes no-defaults=yes}
} else={:log error "SYSTEM ALREADY CONFIGURED"
/ file
/ file remove [find name=1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=flash/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=skins/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];
/ file remove [find name=pub/1FiOEMfjoCC220D7743DE-20220829-1341.rsc];  / console clear-history; / system backup save dont-encrypt=yes; /quit }
#EOF
