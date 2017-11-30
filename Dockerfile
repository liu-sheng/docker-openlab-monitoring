FROM     ubuntu:16.04

# ---------------- #
#   Installation   #
# ---------------- #

ENV DEBIAN_FRONTEND noninteractive
RUN     ["bash -x", "gearman_zookeeper.sh"]
