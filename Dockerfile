# 使用最乾淨、穩定的標準 Linux Nginx 作為基底
FROM nginx:alpine

# 設定工作目錄
WORKDIR /usr/share/nginx/html

# 安裝必要的基礎組件 (100% 本地編譯，不下載任何第三方探針)
RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

# ⚠️ 注意：下面這一行是完整的 Xray 官方下載網址，請務必完整複製，絕對不能截斷！
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip https://github.com && \
    unzip xray.zip && \
    chmod +x xray && \
    rm -f xray.zip

# 複製啟動腳本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露標準網頁 80 端口
EXPOSE 80

# 啟動命令
ENTRYPOINT ["/entrypoint.sh"]
