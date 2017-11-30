#!/bin/bash -x

# Change to root directory
if [[ $EUID -ne 0 ]]; then
    echo "You should run this script as root."
    exit 1
fi

cdir=$(pwd)

cd /root

# Precondition
apt-get update -y && apt-get upgrade -y
apt-get install software-properties-common wget python python-pip python3 python3-pip default-jdk python-psycopg2 -y

# Install bubblewrap
add-apt-repository ppa:openstack-ci-core/bubblewrap -y
apt-get update -y
apt-get install bubblewrap -y

# Install Zookeeper
wget http://apache.mirrors.ionfish.org/zookeeper/current/zookeeper-3.4.10.tar.gz
tar xzf zookeeper-3.4.10.tar.gz
cat << EOF > /root/zookeeper-3.4.10/conf/zoo.cfg
tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
EOF
#/root/zookeeper-3.4.10/bin/zkServer.sh start

#Install gearman
apt-get install gearman-job-server -y
# Modify gearman to listen all
sed -i 's/127.0.0.1/0.0.0.0/1' /lib/systemd/system/gearman-job-server.service
sed -i 's/127.0.0.1/0.0.0.0/1' /etc/systemd/system/multi-user.target.wants/gearman-job-server.service
#systemctl daemon-reload
#service gearman-job-server restart

