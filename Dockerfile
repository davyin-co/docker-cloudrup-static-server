FROM ubuntu:18.04
ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    S6_OVERLAY_VERSION="2.1.0.2" \
    AEGIR_UID=1000
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && \
    /tmp/s6-overlay-amd64-installer / && \
    rm /tmp/s6-overlay-amd64-installer && \
    apt-get update -qq && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/apache2 && \
    apt-get update -qq && apt-get install -y -qq apache2 sudo rsync git-core unzip wget vim openssh-server && \
    addgroup --gid ${AEGIR_UID} aegir && \
    adduser --uid ${AEGIR_UID} --gid ${AEGIR_UID} --system --home /var/aegir aegir && \
    adduser aegir www-data && \
    usermod aegir -s /bin/bash && \
    a2enmod rewrite && \
    a2enmod speling && \
    a2enmod ssl && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod headers && \
    systemctl enable ssh && \
    # Save a symlink to the /var/aegir/config/docker.conf file.
    mkdir -p /var/aegir/config && \
    echo "" > /var/aegir/config/apache.conf && \
    chown aegir:aegir /var/aegir/config -R && \
    mkdir /var/aegir/.ssh && \
    chown aegir:aegir /var/aegir/.ssh -R && \
    chmod 750 /var/aegir/.ssh && \
    ln -sf /var/aegir/config/apache.conf /etc/apache2/conf-available/aegir.conf && \
    ln -sf /etc/apache2/conf-available/aegir.conf /etc/apache2/conf-enabled/aegir.conf

COPY sudoers-aegir /etc/sudoers.d/aegir
COPY rootfs /
COPY config/other-vhosts-access-log.conf /etc/apache2/conf-available/other-vhosts-access-log.conf
COPY config/security.conf /etc/apache2/conf-available/security.conf
COPY entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chown root:root /etc/sudoers.d/aegir && \
    chmod 0440 /etc/sudoers.d/aegir && \
    chmod +x /usr/local/bin/httpd-foreground && \
    chmod +x /usr/local/bin/docker-entrypoint && \
    # Prepare Aegir Logs folder.
    mkdir /var/log/aegir && \
    chown aegir:aegir /var/log/aegir && \
    echo 'Hello, Cloudrup.' > /var/log/aegir/system.log
USER aegir
WORKDIR /var/aegir
VOLUME /var/aegir

ENTRYPOINT ["/init"]
CMD ["httpd-foreground"]
