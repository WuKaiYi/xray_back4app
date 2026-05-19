# 使用最乾淨、穩定的標準 Linux Nginx 作為基底，絕不報錯
FROM nginx:alpine

# 設定工作目錄
WORKDIR /usr/share/nginx/html

# 安裝必要的基礎組件 (100% 本地編譯，不下載任何第三方探針)
RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

# 下載並封裝最穩定的原生 Xray 內核，直接固化在容器內
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip https://github.com && \
    unzip xray.zip && \
    chmod +x xray && \
    rm -f xray.zip

# 複製啟動腳本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露標準網頁 80 端口（Back4app 會自動幫你轉發為 HTTPS 443）
EXPOSE 80

# 啟動命令
ENTRYPOINT ["/entrypoint.sh"]
