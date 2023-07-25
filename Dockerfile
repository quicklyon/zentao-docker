FROM debian:11.7-slim

LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ARG BUILD_ENV
ARG ZENTAO_URL
ARG MIRROR
ARG OS_ARCH
ENV OS_ARCH=${OS_ARCH:-amd64} \
    OS_NAME="debian-11" \
    HOME_PAGE="www.zentao.net"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN install_packages jq curl wget zip unzip s6 pwgen cron netcat ca-certificates vim-tiny patch

ARG PHP_VER
ENV PHP_VER=${PHP_VER:-"7.4.33"}

ARG MYSQL_VER
ENV MYSQL_VER=${MYSQL_VER:-"10.6.14"}

# Install required system packages and dependencies
RUN . /opt/easysoft/scripts/libcomponent.sh && unpack "apache-php" "$PHP_VER" "/opt"
RUN . /opt/easysoft/scripts/libcomponent.sh && unpack "mysql" "$MYSQL_VER" "/opt"
RUN . /opt/easysoft/scripts/libcomponent.sh && unpack "render-template" "1.0.5"
RUN . /opt/easysoft/scripts/libcomponent.sh && unpack "git" "2.30.2"
RUN . /opt/easysoft/scripts/libcomponent.sh && unpack "gt" "1.3"
RUN . /opt/easysoft/scripts/libcomponent.sh && unpack "jt" "0.4"

# Install zentao
ARG ZENTAO_VER
ENV ZENTAO_VER=${ZENTAO_VER:-"18.5"}
ENV EASYSOFT_APP_NAME="ZenTao $ZENTAO_VER"

SHELL ["/bin/bash", "-c"] 
RUN . /opt/easysoft/scripts/libcomponent.sh && z_download "zentao" "${ZENTAO_VER}"

# Copy apache,php and gogs config files
COPY debian/rootfs /

# Apply patch
RUN bash -x /apps/zentao/patch/patch.sh

# Copy zentao-pass source code
WORKDIR /apps/zentao
RUN chown nobody.nogroup /apps/zentao /opt/zbox/tmp -R \
   && ln -s /opt/zbox/run/mysql/mysql /usr/bin/

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
