FROM maven:3.6-jdk-8 as builder


COPY org.opentestmodeling.vstep.ngt.sketch.parent/ /apps/

WORKDIR /apps
RUN mvn clean install -DskipTests

RUN mkdir source/
RUN cp org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar source/
RUN rm org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar

FROM openjdk:8

RUN sudo apt-get install socat -y

WORKDIR /apps
COPY --from=builder sources/*.jar ./source/
COPY --from=builder org.opentestmodeling.vstep.ngt.sketch.ide/target/*.jar ./

EXPOSE 4471

CMD socat TCP4-LISTEN:4417,reuseaddr,fork EXEC:"java -jar /apps/*.jar"
