FROM docker.io/ubuntu:latest
RUN apt-get update
RUN apt-get install apt-utils software-properties-common wget -y
RUN apt-get install tar -y
RUN apt-get install openjdk-17-jre-headless -y
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz
RUN tar -zxvf apache-tomcat-9.0.95.tar.gz
RUN chmod +x apache-tomcat-9.0.95/bin/*
COPY target/*.jar /usr/local/tomcat/webapps/
CMD ["/apache-tomcat-9.0.95/bin/catalina.sh", "run"]