# This is just a tmp thing as we should fix the version.
#
# Pull base image.
FROM buildpack-deps:jessie-scm

MAINTAINER Matthew Buckett <matthew.buckett@it.ox.ac.uk>

# Install MySQL.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
  rm -rf /var/lib/mysql

WORKDIR /data

VOLUME ["/etc/mysql", "/var/lib/mysql"]

RUN mkdir -p /opt/scripts
ADD ./entrypoint.sh /opt/scripts/entrypoint.sh

# Need to startup MySQL 
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]

CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]

EXPOSE 3306


