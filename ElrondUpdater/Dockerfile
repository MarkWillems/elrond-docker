FROM docker:dind

RUN apk upgrade --no-cache && \
    apk add --no-cache bash

STOPSIGNAL SIGINT
WORKDIR /opt
ADD autoupdater.sh /opt/autoupdater.sh
RUN chmod +x /opt/autoupdater.sh
CMD ["/opt/autoupdater.sh"]
