FROM ubuntu:focal AS ubuntu-base-with-s6
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

FROM ubuntu-base-with-s6
ENV DEBIAN_FRONTEND noninteractive
ARG UBU_VER='focal'
ARG GLOBAL_BUILDDEPS='ca-certificates curl gnupg apt-transport-https build-essential kmod'
ARG BOINC_VERSION
ARG S6-VERSION='v2.2.0.3'

RUN \
  echo "**BUILDING BASE DEPENDENCIES***" \
  && apt-get update && apt-get install -y --no-install-recommends \
        ${GLOBAL_BUILDDEPS} linux-headers-$(uname -r) dkms \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN \
  echo "**BUILDING VIRTUALBOX LAYER***" \
  && curl -sSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add - \
  && echo "deb http://download.virtualbox.org/virtualbox/debian ${UBU_VER} contrib" >> /etc/apt/sources.list.d/virtualbox.list \
#  && apt-get update && apt-get install -y --no-install-recommends \
#    virtualbox-dkms \
  && apt-get update && apt-get install -y --no-install-recommends \
    virtualbox-6.1 \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN \
  curl -sSL https://download.virtualbox.org/virtualbox/6.1.26/Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack -o Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack \
  && echo y | VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack

RUN \
  echo "**BUILDING NVIDIA LAYER**" \
  sleep 2 \
  echo "**JK, The Nvidia runtime is already here**" \
  sleep 3

RUN \
        echo "**BUILDING BOINC LAYER**" \
      && apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys E36CE452F7C2AE96FB1354901BCB19E03C2A1859 \
      && echo "deb http://ppa.launchpad.net/costamagnagianfranco/boinc/ubuntu ${UBU_VER} main" >> /etc/apt/sources.list.d/boinc.list \
      && echo "deb-src http://ppa.launchpad.net/costamagnagianfranco/boinc/ubuntu ${UBU_VER} main" >> /etc/apt/sources.list.d/boinc.list \
      && if [ -z ${BOINC_VERSION+x} ]; then \
             BOINC="boinc-client"; \
      else \
             BOINC="boinc-client=${BOINC_VERSION}"; \
      fi \
      && apt-get update && apt-get install -y --no-install-recommends \
             ${BOINC} \
             python-xdg \
      && echo "**** cleanup ****" \
      && apt-get clean \
      && rm -rf \
             /tmp/* \
             /var/lib/apt/lists/* \
             /var/tmp/*

COPY root/ /
ENTRYPOINT ["/init"]
