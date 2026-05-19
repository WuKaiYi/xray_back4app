#!/bin/sh

# 如果用戶沒有設定 UUID，預設隨機生成一個
if [ -z "$UUID" ]; then
  UUID="b831381d-6324-4d53-ad4f-8cda48b30811"
fi

# 在本地直接生成最純淨的 Xray 配置文件，不需要任何外部讀取
cat << EOF > /usr/share/nginx/html/config.json
{
    "inbounds": [{
        "port": 12345,
        "protocol": "vless",
        "settings": {
            "clients": [{"id": "$UUID"}],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {"path": "/vless"}
        }
    }],
    "outbounds": [{"protocol": "freedom"}]
}
EOF

# 修改 Nginx 配置，使其完美支持偽裝網頁與 WebSocket 轉發
cat << EOF > /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name localhost;
    
    # 預設首頁：顯示 Welcome to Nginx 偽裝防封鎖
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
    
    # 隱藏的分流路徑，將 Clash 的翻牆流量無縫送到 Xray 內核
    location /vless {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:12345;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
    }
}
EOF

# 同時啟動 Nginx 網頁與 Xray 翻牆核心
/usr/share/nginx/html/xray -config /usr/share/nginx/html/config.json &
nginx -g "daemon off;"
