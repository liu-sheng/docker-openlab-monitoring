FROM     ubuntu:16.04

# ---------------- #
#   Installation   #
# ---------------- #

ENV DEBIAN_FRONTEND noninteractive
ADD ./gearman_zookeeper.sh /root/gearman_zookeeper.sh
RUN  chmod +x /root/gearman_zookeeper.sh &&\
     bash -x /root/gearman_zookeeper.sh
EXPOSE 2181 2888 3888 4730
CMD /root/zookeeper-3.4.10/bin/zkServer.sh start &&\
    service gearman-job-server start

