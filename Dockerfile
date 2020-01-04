FROM busybox
RUN mkdir -p /download 
WORKDIR /mnt
RUN wget https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.15.1/prometheus-2.15.1.linux-amd64.tar.gz
VOLUME ["/download"]
CMD ["mv","/mnt/*","/download"]