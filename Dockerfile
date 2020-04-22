FROM golang:1.8

ENV DEBIAN_FRONTEND noninteractive

COPY sources.list /etc/apt/sources.list

RUN curl https://haproxy.debian.net/bernat.debian.org.gpg | \
      apt-key add - && \
    echo deb http://haproxy.debian.net jessie-backports-1.5 main | \
      tee /etc/apt/sources.list.d/haproxy.list
        

RUN apt-get clean all -y && apt-get update -y


RUN  apt-get install -y software-properties-common

RUN apt-get install -y git mercurial supervisor
RUN apt-get install -y haproxy -t jessie-backports-1.5

ADD builder/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD builder/run.sh /run.sh

WORKDIR /go/src/github.com/QubitProducts/bamboo

RUN go get github.com/tools/godep && \
    go get -t github.com/smartystreets/goconvey

ADD . /go/src/github.com/QubitProducts/bamboo

RUN go build

RUN ln -s /go/src/github.com/QubitProducts/bamboo /var/bamboo

RUN mkdir -p /run/haproxy
RUN mkdir -p /var/log/supervisor

VOLUME /var/log/supervisor

RUN apt-get clean && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    rm -f /etc/ssh/ssh_host_*

EXPOSE 80 8000

CMD /run.sh
