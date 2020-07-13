FROM alpine:3.6

ENV UID=1000
ENV GID=1000

COPY * /app/

RUN BUILD_DEPS=" \
    git \
    gcc \
    musl-dev \
    python2-dev \
    py-pip" \
    && apk -U upgrade && apk add \
    ${BUILD_DEPS} \
    python \
    && addgroup -g $GID -S flask \
    && adduser -u $UID -D -S -h /app -s /sbin/nologin -G flask flask \
    && cd /app \
    && pip install -r requirements.txt \
    && chown -R flask:flask /app \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

WORKDIR /app

VOLUME /app

EXPOSE 5004

ENTRYPOINT ["/usr/bin/python"]
CMD ["/app/tvhProxy.py"]
