FROM docker:dind

RUN apk upgrade --no-cache && \
    apk add --no-cache bash

STOPSIGNAL SIGINT
WORKDIR /opt
ADD updater.sh /opt/updater.sh
RUN chmod +x /opt/updater.sh
CMD ["/opt/updater.sh"]
