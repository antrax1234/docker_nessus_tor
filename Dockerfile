FROM kalilinux/kali-rolling:amd64
ARG debfile
COPY $debfile /tmp/nessus.deb

RUN set -x \
  && apt update -y \
  \
  && apt install -y net-tools lsof tzdata hydra \
  && apt install -y tor tor-geoipdb \  
  && apt install -y git \
  && apt install -y dpkg \
  && apt install -y systemctl \
  && apt install -y iptables  \
  && apt install -y insserv \
  && apt install -y curl \
  && apt install -y network-manager \
  && apt install -y vim  \
  && apt install -y software-properties-common p7zip-full wget whois locales python3 python3-pip upx psmisc \
  && apt install -y tinyproxy && sed -i -e '/^Allow /s/^/#/' -e '/^ConnectPort /s/^/#/' -e '/^#DisableViaHeader /s/^#//' /etc/tinyproxy/tinyproxy.conf  \
  && dpkg -i /tmp/nessus.deb  \
  && git clone https://github.com/antrax1234/torDocker.git /root/anonsurf \   
  && chmod -R +x /root/anonsurf   \
  && bash /root/anonsurf/installer.sh \
  && rm /tmp/nessus.deb \  
  && apt clean all \
  && rm -rf /var/cache/apt \
  && rm -rf /opt/nessus/var/nessus/{uuid,*.db*,master.key} \
  && rm -rf /var/cache/apt \
  && rm -rf /root/anonsurf/ \
EXPOSE 8834 8888
CMD ["/opt/nessus/sbin/nessus-service"]
