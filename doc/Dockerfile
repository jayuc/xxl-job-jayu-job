FROM ubuntu18/jre8:v1.1.2
MAINTAINER yujie
ENV REFRESHED_AT 2019-09-28
WORKDIR /usr
RUN mkdir app
ADD xxl-job-jayu-job-1.0.3.jar /usr/app/
ADD application.properties /usr/app/
Volume /app/log
EXPOSE 8001
ENTRYPOINT ["sh","-c","java -jar -Dspring.config.location=/usr/app/application.properties /usr/app/xxl-job-jayu-job-1.0.3.jar"]
