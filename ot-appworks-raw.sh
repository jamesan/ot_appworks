#!/bin/bash
#
# Copyright 2014, James An <james@jamesan.ca>
#
# This binds Tomcat to http://localhost:8080. The Appworks Gateway can be
# found at http://localhost:8080/gateway. When installing Gateway, the LDAP
# port can't be a privileged port (e.g. change it from 389 to 1389).
#
# Gateway sets up successfully with the defaily otag/otag credentials.

# Control parameters
OT_APP=appworks_gateway_1.1.5   # Filename for the latest OpenText's Appworks Gateway
TC_APP=apache-tomcat-7.0.52     # Filename for the latest Tomcat 7
TC_HOME=/srv/$TC_APP            # Tomcat's absolute path
TC_USER=tomcat7                 # Tomcat username
DL_DIR=~/Downloads              # (Download) location of the install packages

# Create system account for Tomcat
sudo useradd -rd $TC_HOME $TC_USER

# Unpack AppWorks Gateway and install Tomcat to its system account
unzip $DL_DIR/$OT_APP.zip -d $DL_DIR/$OT_APP
tar xzf $DL_DIR/$TC_APP.tar.gz
sudo mv $TC_APP /srv
sudo pacman -S --noconfirm --needed --asdeps jre7-openjdk

# Install Gateway files within Tomcat's directory tree
sudo cp $DL_DIR/$OT_APP/lib/* $TC_HOME/lib
sudo cp $DL_DIR/$OT_APP/webapps/* $TC_HOME/webapps
sudo cp -r $DL_DIR/$OT_APP/otds $TC_HOME
sudo chown -R $TC_USER:$TC_USER $TC_HOME $TC_HOME/*/

# Install env params for AppsWorks' JVM memory req and Tomcat's contexts
echo '#!/bin/bash

JAVA_HOME=/usr/lib/jvm/java-7-openjdk
CATALINA_PID="$CATALINA_BASE/tomcat.pid"
CATALINA_OPTS="-XX:MaxPermSize=256m -Xmx1024m"' | sudo tee /srv/apache-tomcat-7.0.52/bin/setenv.sh

# Start Tomcat
sudo su -c "env CATALINA_HOME=$TC_HOME ~/bin/startup.sh" $TC_USER

# Shutdown Tomcat
# sudo su -c "env CATALINA_HOME=$TC_HOME ~/bin/shutdown.sh" $TC_USER
