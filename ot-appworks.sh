#!/bin/bash
#
# Copyright 2014, James An <james@jamesan.ca>
#
# This binds Tomcat to http://localhost:8080 with no user account. The Appworks
# Gateway can be found at http://localhost:8080/gateway. When installing
# Gateway, the LDAP port can't be a privileged port (e.g. change it from
# 389 to 1389).
#
# Gateway is set up, except for missing the Java Message Broker's keystore
# required by OpenText's Directory Services (OTDS). There is a permission
# bug here preventing the OTDSJMSBroker.ks file from being written to the
# correct location.
#
# Giving ugo+w write access to either /usr/share/tomcat8 or /usr/share/tomcat8/bin
# should resolve the issue. Will confirm this time permitting.

# Control parameters
TOMCAT=tomcat8                  # Tomcat username, directory name, and package name
OT_APP=appworks_gateway_1.1.5   # Filename for the latest OpenText's Appworks Gateway
TC_DIR=/usr/share/$TOMCAT       # Tomcat's absolute path
DL_DIR=~/Downloads              # (Download) location of the Gateway install package

# Install Tomcat and unpackage Appworks
unzip $DL_DIR/$OT_APP.zip -d $DL_DIR/$OT_APP
sudo pacman -S --noconfirm --needed $TOMCAT tomcat-native

# Add AppWorks' JVM memory parameters requirements to Tomcat's service unit file
sudo cp -f /{usr/lib,etc}/systemd/system/$TOMCAT.service
sudo sed -i 's/Environment=CATALINA_OPTS=/Environment="CATALINA_OPTS=-XX:MaxPermSize=256m -Xmx1024m"/' /etc/systemd/system/$TOMCAT.service

# Install Gateway files within Tomcat's directory tree
sudo cp $DL_DIR/$OT_APP/lib/* $TC_DIR/lib
sudo cp $DL_DIR/$OT_APP/webapps/* $TC_DIR/webapps
sudo cp -r $DL_DIR/$OT_APP/otds $TC_DIR
sudo chown -R $TOMCAT:$TOMCAT $TC_DIR $TC_DIR/*/

# Start Tomcat
sudo systemctl daemon-reload
sudo systemctl start $TOMCAT
