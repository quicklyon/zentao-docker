ARG BASE_IMAGE

FROM ${BASE_IMAGE}
LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ARG BUILD_ENV
ARG ZENTAO_URL
ENV OS_NAME="debian-11" \
    HOME_PAGE="www.zentao.net"

COPY debian/prebuildfs /

# Install zentao
ARG ZENTAO_VER
ENV ZENTAO_VER=${ZENTAO_VER:-"18.5"}
ENV EASYSOFT_APP_NAME="ZenTao $ZENTAO_VER"

SHELL ["/bin/bash", "-c"]
RUN . /opt/easysoft/scripts/libcomponent.sh && z_download "zentao" "${ZENTAO_VER}"

# Copy apache,php and gogs config files
COPY debian/rootfs /

# Apply patch
# RUN bash -x /apps/zentao/patch/patch.sh

# Copy zentao-pass source code
WORKDIR /apps/zentao
RUN chown nobody.nogroup /apps/zentao /opt/zbox/tmp -R \
   && ln -s /opt/zbox/run/mysql/mysql /usr/bin/

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
