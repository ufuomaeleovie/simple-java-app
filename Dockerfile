FROM docker.io/ubuntu:latest AS build
ENV JAVA_HOME /opt/jdk17
ENV PATH $PATH:/opt/jdk17/bin
ENV MAVEN_HOME /opt/maven
RUN export PATH
RUN export JAVA_HOME
RUN apt update -y && \ 
    apt install wget -y && \
    apt install gzip -y && \
    apt install tar -y && \
    apt install git -y
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
    tar zxf jdk-17_linux-x64_bin.tar.gz && \
    rm -r jdk-17_linux-x64_bin.tar.gz && \
    mv jdk-17.0.12 /opt/jdk17

RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar zxf apache-maven-3.9.9-bin.tar.gz && \
    rm -r apache-maven-3.9.9-bin.tar.gz && \
    mv apache-maven-3.9.9 /opt/maven

RUN git clone https://github.com/ufuomaeleovie/simple-java-app.git /opt/app
WORKDIR /opt/app
RUN /opt/maven/bin/mvn package

FROM docker.io/ubuntu
ENV JAVA_HOME /opt/jdk17
ENV PATH $PATH:/opt/jdk17/bin
RUN apt update -y && \
    apt install wget -y && \
    apt install gzip -y && \
    apt install tar -y
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
    tar zxf jdk-17_linux-x64_bin.tar.gz && \
    rm -r jdk-17_linux-x64_bin.tar.gz && \
    mv jdk-17.0.12 /opt/jdk17

RUN wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.0-M26/bin/apache-tomcat-11.0.0-M26.tar.gz && \
    tar zxf apache-tomcat-11.0.0-M26.tar.gz && \
    rm -r apache-tomcat-11.0.0-M26.tar.gz && \
    mv apache-tomcat-11.0.0-M26 /opt/tomcat
COPY --from=build /opt/app/target/tca-1.0.war /opt/tomcat/webapps/
CMD  ["/opt/tomcat/bin/catalina.sh", "run"]