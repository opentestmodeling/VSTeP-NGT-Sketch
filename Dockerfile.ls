FROM maven:3.6-jdk-8 as builder


COPY org.opentestmodeling.vstep.ngt.sketch.parent/ /apps/

WORKDIR /apps
RUN mvn clean install -DskipTests

RUN mkdir sources/
RUN cp org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar sources/
RUN rm org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar

FROM openjdk:8

RUN sudo apt-get install socat -y

WORKDIR /apps
COPY --from=builder sources/*.jar ./sources/
COPY --from=builder org.opentestmodeling.vstep.ngt.sketch.ide/target/*.jar ./

EXPOSE 4417

CMD socat TCP4-LISTEN:4417,reuseaddr,fork EXEC:"java -jar /apps/*.jar"
