from ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

#install prerequisites
RUN apt-get -q update && \
    apt-get -q -y install software-properties-common git python3.6 python3-pip \
    build-essential unzip libsqlite3-dev zlib1g-dev wget curl && \
    add-apt-repository ppa:ubuntugis/ppa && \
    apt-get update && \
    apt-get -q -y install gdal-bin gdal-data && \
    apt-get clean && \
    rm -rf /var/lib/apt/ /var/cache/apt/ /var/cache/debconf/

RUN cd /opt && \
    git clone -b '0.3' --single-branch --depth 1 \
    https://github.com/OpenBounds/Processing.git && \
    cd Processing && \
    pip3 install click boto boto3 ujson requests

ADD code /opt/snowdepth/

ENV LC_ALL=C.UTF-8
CMD ["/bin/bash","-c","cd /opt/snowdepth/ && ./download_data.sh || curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"Snow build failed\"}' $SLACK_WEBHOOK"]
