FROM maven:3.6.0-jdk-8-alpine AS build

RUN mkdir /project

WORKDIR /project

COPY . .

RUN mvn -e clean package

FROM openjdk:8-jre-alpine
#FROM openjdk:8-jre

RUN mkdir /app && mkdir /logs

WORKDIR /app

COPY --from=build /project/target/memory-leaker-*.jar memory-leaker.jar

VOLUME /logs
EXPOSE 8080
EXPOSE 9010

ENTRYPOINT java $JAVA_OPTS -jar memory-leaker.jar
