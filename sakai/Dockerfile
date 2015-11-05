# This is the file that is actually use to build the production images
# It copies a build of Sakai ontop of the sakai tomcat
#

FROM buckett/sakai-tomcat

# Copy all the files in
COPY tomcat/components /opt/tomcat/components/
COPY tomcat/lib /opt/tomcat/sakai-lib/
COPY tomcat/webapps /opt/tomcat/webapps/

# We don't copy local.properties for production
COPY  log4j.properties placeholder.properties sakai.quartz.properties /opt/tomcat/sakai/

# Up the memory for production
ENV CATALINA_OPTS_MEMORY -Xms2g -Xmx3g

# To allow de-reploy and expanding of webapps.
RUN chown sakai /opt/tomcat/webapps

# Create archive folder and make sure it's writeable by the sakai user.
RUN \
  mkdir /opt/tomcat/sakai/archive && \
  chown sakai /opt/tomcat/sakai/archive
