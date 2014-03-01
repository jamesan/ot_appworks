OpenText AppWorks for Arch Linux
===========

The two scripts set up Tomcat and AppWorks Gateway for Arch Linux specifically.
One sets up Arch's Tomcat package; the other uses Tomcat's plain tarball.

The Arch package setup doesn't yet successfully set up the Gateway due to
write permission issue with the auto-generated JMS keystore for OTDS.
