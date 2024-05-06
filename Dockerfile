ARG VERSION=latest

FROM debian:bookworm-slim

ARG VERSION

###
# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#
# Note: Additional labels are added by the build workflow.
###
LABEL org.opencontainers.image.authors="Don-Swanson"
LABEL org.opencontainers.image.vendor="Netris Cyber Security"

###
# Upgrade the system
###
RUN apt-get update --quiet --quiet \
    && apt-get upgrade --quiet --quiet

###
# Install everything we need
###
ENV DEPS \
    ca-certificates \
    gettext-base \
    mailutils \
    postfix \
    procmail \
    sasl2-bin
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install --quiet --quiet --yes \
    $DEPS \
    && apt-get --quiet --quiet clean \
    && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

###
# Seup Config Files
###
RUN mkdir /config && \
    cp /etc/postfix/main.cf /etc/postfix/main.cf.orig && \
    cp /etc/postfix/master.cf /etc/postfix/master.cf.orig && \
    mv /etc/postfix/main.cf /config/main.cf && \
    mv /etc/postfix/master.cf /config/master.cf && \
    touch /config/transport && \
    ln -s /config/main.cf /etc/postfix/main.cf && \
    ln -s /config/master.cf /etc/postfix/master.cf && \
    ln -s /config/transport /etc/postfix/transport

###
# Setup entrypoint
###
USER root
WORKDIR /root
COPY docker-entrypoint.sh ./
RUN ["chmod", "+x", "./docker-entrypoint.sh"]

###
# Prepare to run
###
VOLUME ["/var/log", "/var/spool/postfix", "/config"]
EXPOSE 25/TCP 587/TCP
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["postfix", "-v", "start-fg"]