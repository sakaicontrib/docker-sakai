# This is the dockerfile for the Sakai tomcat.
# Basically this is just a copy of tomcat that has it's classloaders modified for Sakai.
# This doesn't have a copy of Sakai put into it so it can be used for development where Sakai is mounted from outside
# the container.

# Use the OpenJDK image
# This builds on debian jessie
FROM java:openjdk-8u66

MAINTAINER Matthew Buckett <matthew.buckett@it.ox.ac.uk>

WORKDIR /tmp

# Create the group and user for Sakai
RUN groupadd --gid 10000 sakai && \
  useradd --uid 10000 --gid 10000 --system sakai 

# The 1024 bit root CAs are no longer in Debian (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=812708)
# and the cross signing isn't working in older versions of openssl
COPY thawte_Premium_Server_CA.pem /usr/local/share/ca-certificates/thawte_permium_server_ca.crt
RUN update-ca-certificates

# Need to get the tomcat binary and unpack
RUN mkdir -p /opt/tomcat && \
  # We don't use the main mirror as otherwise it stops working once newer versions are released.
  # version we want
  curl -s https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz | \
  tar zxf - --strip-components 1 -C /opt/tomcat && \
  cd /opt/tomcat && \
  rm -r webapps && \
  mkdir webapps && \
  # We change the classloader for tomcat so that we can map in a folder that just contains the Sakai additions.
  mkdir /opt/tomcat/sakai-lib && \
  sed -i.orig '/^common.loader=/s@$@,"${catalina.base}/sakai-lib/*.jar"@' conf/catalina.properties


# Override with custom server.xml
COPY server.xml /opt/tomcat/conf/server.xml
# Speedup startup
COPY context.xml /opt/tomcat/conf/context.xml

# /opt/tomcat/sakai/logs is for Apache James logging.
RUN mkdir -p /opt/scripts && \
  mkdir -p /opt/tomcat/sakai/files && \
  mkdir -p /opt/tomcat/sakai/deleted && \
  mkdir -p /opt/tomcat/sakai/logs

# The logs directory needs to be writable by tomcat
RUN chown sakai /opt/tomcat/logs /opt/tomcat/temp /opt/tomcat/work /opt/tomcat/sakai/files /opt/tomcat/sakai/deleted /opt/tomcat/sakai/logs /opt/tomcat/webapps && \
  find /opt/tomcat/conf/ -type f| xargs chmod 640 && \
  mkdir -p /opt/tomcat/conf/Catalina && chown sakai /opt/tomcat/conf/Catalina && \
  chgrp sakai -R /opt/tomcat/conf && chmod 755 /opt/tomcat/conf && \
  touch /opt/tomcat/sakai/sakai.properties && \
  chown sakai /opt/tomcat/sakai/sakai.properties

# This sets the default locale and gets it to work correctly in Java
ENV LANG en.UTF-8

# TODO fix this
#RUN /usr/sbin/locale-gen $LANG

COPY ./entrypoint.sh /opt/scripts/entrypoint.sh

ENV CATALINA_OPTS_MEMORY -Xms256m -Xmx1524m

ENV CATALINA_OPTS \
# Force the JVM to run in server mode (shouldn't be necessary, but better sure ).
-server \
# Make the JVM headless so it doesn't try and use X11 at all.
-Djava.awt.headless=true \
# Stop the JVM from caching DNS lookups, otherwise we don't get DNS changes propogating
-Dsun.net.inetaddr.ttl=0 \
# If the component manager doesn't start shut down the JVM
-Dsakai.component.shutdownonerror=true \
# Force the locale
-Duser.language=en -Duser.country=US \
# Set the properties for Sakai (sakai.home isn't necessary)
-Dsakai.home=/opt/tomcat/sakai -Dsakai.security=/opt/tomcat/sakai \
# Set the timezone as the docker container doesn't have this set
-Duser.timezone=Europe/London \
# Connect timeout (5 minutes)
-Dsun.net.client.defaultConnectTimeout=300000 \
# Read timeout (30 minutes)
-Dsun.net.client.defaultReadTimeout=1800000

# If we run in debug mode
ENV JPDA_OPTS -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
