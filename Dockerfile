FROM     ubuntu:16.04

# ---------------- #
#   Installation   #
# ---------------- #

ENV DEBIAN_FRONTEND noninteractive
ADD ./gearman_zookeeper.sh /root/gearman_zookeeper.sh
ADD ./openlab_misc.sh /root/openlab_misc.sh
ADD ./conf /root/conf

RUN  chmod +x /root/gearman_zookeeper.sh &&\
     bash -x /root/gearman_zookeeper.sh  &&\
     chmod +x /root/openlab_misc.sh      &&\
     bash -x /root/openlab_misc.sh

EXPOSE 2181 2888 3888 2181 80 2003 8125/udp

CMD /root/zookeeper-3.4.10/bin/zkServer.sh start &&\
    service gearman-job-server start             &&\
    service grafana-server restart               &&\
    service carbon-cache start                   &&\
    service statsd restart                       &&\
    service fail2ban restart                     &&\
    service apache2 restart
