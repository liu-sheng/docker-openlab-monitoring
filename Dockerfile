FROM     ubuntu:16.04

# ---------------- #
#   Installation   #
# ---------------- #

ENV DEBIAN_FRONTEND noninteractive
ADD ./gearman_zookeeper.sh /root/gearman_zookeeper.sh
ADD ./openlab_misc.sh /root/openlab_misc.sh
ADD ./conf /root/conf
ADD ./mysql_secure_installation.sql /root/mysql_secure_installation.sql

RUN  chmod +x /root/gearman_zookeeper.sh &&\
     bash -x /root/gearman_zookeeper.sh  &&\
     chmod +x /root/openlab_misc.sh      &&\
     bash -x /root/openlab_misc.sh

EXPOSE 2181 2888 3888 2181 80 2003 8125/udp

CMD /root/zookeeper-3.4.10/bin/zkServer.sh start &&\
    service gearman-job-server start             &&\
    service grafana-server restart               &&\
    service mysql restart                        &&\
    mysql -sfu root < /root/mysql_secure_installation.sql &&\
    graphite-manage migrate auth                 &&\
    graphite-manage syncdb --noinput             &&\
    service carbon-cache start                   &&\
    /usr/bin/nodejs /root/build/statsd/stats.js /etc/statsd/localConfig.js > /dev/null 2>&1 &&\
    service fail2ban restart                     &&\
    service apache2 restart
