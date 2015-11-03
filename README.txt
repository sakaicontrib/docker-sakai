docker/docker-compose
==========

This is a selection of docker images and fig setups for developing/deploying Sakai.

Layout
======

tomcat - This is an Docker image ready for a copy of Sakai. It containts Java and Tomcat.
sakai - This is a development fig setup for Sakai.
mysql - This is a Docker image containing MySQL.

Development
===========

With your source checkout of Sakai build it and deploy it into the folder `sakai/tomcat`
Once it's deployed bring up the application and supporting services:
```
cd sakai
docker-compose up
```

This will startup a copy of MySQL and Tomcat (running Sakai). They will be configured to
use each other, to stop them all just ^C. 
In general use you will probably want to start them up in the background:
```
docker-compose up -d
```
You can then look at the logs with
```
docker-compose logs
```
If you build and deploy any webapps they should be picked up, but if you want to just restart tomcat
after making changes to the build you can use:
```
docker-compose restart app
```
If you wish to test out config changes they should go in `sakai/local.properties` but
if you wish to include them in general builds they should get put in `sakai/placeholder.properties`


Production
==========

With your source checkout of Sakai build it it and deploy it into the foler `sakai/tomcat`
Once it's deployed you need to build the docker image:
```
docker build -t sakaiproject/tomcat tomcat
docker build -t buckett/sakai sakai
```
Then to send the image to the hosting team push the image to the docker registry
```
docker push buckett/sakai
```

Sakai Configuration
===================

To configure Sakai we have the following files, the order listed is the order they are read with values being overritten with newer ones.:

 - `sakai/placeholder.properties` This contains 99% of out config changes for Sakai, it's bundled into the container for production builds.
 - sakai.properties This is where the container linking automatically happens if you are using `docker-compose`. It's inside the container and shouldn't be touched.
 - `sakai/local.properties` Here you can put local configuration for configuration you are testing out (before putting in placeholder.properties). In production this is also where the DB configuration is put.
 - security.properties In production this contains the passwords for the services we connect to (DB, Turnitin, etc)

Notes
=====

Generally put stuff in /opt/* and put scripts that are used by docker in /opt/scripts (should be more unixy and change to /opt/bin)

