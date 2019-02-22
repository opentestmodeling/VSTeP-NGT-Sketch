FROM maven:3.6-jdk-8 as builder


COPY org.opentestmodeling.vstep.ngt.sketch.parent/ /apps/

WORKDIR /apps
RUN mvn clean install -DskipTests

RUN mkdir sources/
RUN cp org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar sources/
RUN rm org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar

FROM openjdk:8

RUN apt-get update && apt-get install socat -y

WORKDIR /apps
COPY --from=builder /apps/sources/*.jar ./sources/
COPY --from=builder /apps/org.opentestmodeling.vstep.ngt.sketch.ide/target/*.jar ./

EXPOSE 4418

CMD socat TCP4-LISTEN:4418,reuseaddr,fork EXEC:"java -jar /apps/*.jar"
