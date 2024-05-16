# HELK script: HELK Kafka Zookeeper Dockerfile
# HELK build Stage: Alpha
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

FROM docker-helk-kafka-base
LABEL maintainer="Roberto Rodriguez @Cyb3rWard0g"
LABEL description="Dockerfile base for the HELK Kafka Zookeeper."

ENV DEBIAN_FRONTEND noninteractive

# *********** Configure KRAFT Controller ***************
ENV KAFKA_SCRIPT=$KAFKA_HOME/bin/kafka-server-start.sh
ENV KAFKA_CONFIG=$KAFKA_HOME/config/server.properties

RUN mv $KAFKA_CONFIG ${KAFKA_HOME}/config/backup_server.properties
COPY server.properties ${KAFKA_HOME}/config/
COPY scripts ${KAFKA_HOME}/scripts
RUN chmod +x ${KAFKA_HOME}/scripts/kafka-entrypoint.sh \
    && chmod +x ${KAFKA_HOME}/scripts/kafka-create-topics.sh

USER ${KAFKA_USER}

EXPOSE 9092 9093
WORKDIR /opt/helk/kafka/scripts/
ENTRYPOINT ["./kafka-entrypoint.sh"]
CMD ["/bin/bash","-c","$KAFKA_SCRIPT $KAFKA_CONFIG"]