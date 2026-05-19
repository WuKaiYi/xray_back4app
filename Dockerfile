FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

# Download and extract xray (using XTLS/Xray-core latest release)
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.15/Xray-linux-64.zip && \
    unzip -q xray.zip && \
    chmod +x xray && \
    rm -f xray.zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
