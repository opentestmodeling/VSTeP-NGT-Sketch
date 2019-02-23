FROM maven:3.6-jdk-8 as builder

COPY org.opentestmodeling.vstep.ngt.sketch.parent/ /apps/

WORKDIR /apps
RUN mvn clean install -DskipTests



FROM openjdk:8

RUN apt-get update && apt-get install socat -y

WORKDIR /apps
RUN mkdir -p sources/
COPY --from=builder /apps/org.opentestmodeling.vstep.ngt.sketch.ide/target/*-sources.jar ./sources/
COPY --from=builder /apps/org.opentestmodeling.vstep.ngt.sketch.ide/target/*-ls.jar ./
RUN ln -s *.jar server.jar
EXPOSE 4417

CMD socat TCP4-LISTEN:4417,reuseaddr,fork EXEC:"java -jar /apps/server.jar"