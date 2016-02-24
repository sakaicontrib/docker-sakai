docker/docker-compose
==========

This is a selection of docker images and docker-compose setups for developing/deploying Sakai.

Layout
======

tomcat - This is an Docker image ready for a copy of Sakai. It containts Java and Tomcat. This image 
available from the Docker Hub as https://hub.docker.com/r/buckett/sakai-tomcat/
sakai - This is the main docker and docker-compose folder

Setup
=====

If you are on Linux then you should install docker and docker-compose, if you're on Windows or Mac then 
you should install the Docker Toolbox. If you're using the Docker Toolbox you then need to create you're 
virtual machine and because Sakai has large memory requirements you should increase the default resources
allocated to it as long as your host has sufficient resources. This allocates 2GB and 2 CPUs.

```
export VIRTUALBOX_CPU_COUNT="2"
export VIRTUALBOX_MEMORY_SIZE="2048"
```

then create the VM and setup docker to use this VM:
```
docker-machine create -d virtualbox dev
eval $(docker-machine env dev)
```

Development
===========

If you're on Windows of Mac make sure that you have your Sakai deployment inside you're home folder as by default docker machine will only make those folders available to a docker container.

With your source checkout of Sakai build it and deploy it into the folder `sakai/tomcat`

```
cd sakai/checkout
mvn install sakai:deploy -Dmaven.tomcat.home=/home/user/sakai/docker/sakai/tomcat
```

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
docker build -t username/sakai sakai
```
Then to send the image to the hosting team push the image to the docker registry
```
docker push username/sakai
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

If the files don't seem to be appearing inside the docker container make sure your working inside your home folder.

