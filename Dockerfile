FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

# ⚠️ 注意：下面這一行把所有的下載解壓指令壓縮成了單行，去除了所有反斜線，保證網址完整！
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip https://github.com && unzip xray.zip && chmod +x xray && rm -f xray.zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
