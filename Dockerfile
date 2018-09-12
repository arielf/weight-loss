FROM ubuntu

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y python2.7 make vowpal-wabbit r-base r-base-core r-cran-ggplot2 git && \
    ln -s /usr/bin/python2.7 /usr/local/bin/python2

CMD make
