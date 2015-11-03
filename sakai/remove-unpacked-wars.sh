#!/bin/bash

find tomcat/webapps -type d -prune -mindepth 1 | xargs rm -r
