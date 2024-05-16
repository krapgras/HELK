#!/bin/bash

# HELK script: kafka-entrypoint.sh
# HELK script description: Starts Kafka services
# HELK build Stage: Alpha
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

# *********** Configuring Kafka **************
echo "[HELK-DOCKER-INSTALLATION-INFO] Processing kafka environment variables.."

if [[ -z "$KAFKA_HEAP_OPTS" ]]; then
  export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting KAFKA_HEAP_OPTS to $KAFKA_HEAP_OPTS"

if [[ -z "$KAFKA_BROKER_PORT" ]]; then
  KAFKA_BROKER_PORT=9092
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting kafka broker port to $KAFKA_BROKER_PORT"

if [[ -z "$KAFKA_BROKER_NAME" ]]; then 
  KAFKA_BROKER_NAME=helk-kafka-broker
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting kafka broker name to $KAFKA_BROKER_NAME"

if [[ -z "$KAFKA_NODE_ID" ]]; then
  KAFKA_NODE_ID=1
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting kafka broker id to $KAFKA_NODE_ID"

if [ -z "$LOG_RETENTION_HOURS" ]; then
  LOG_RETENTION_HOURS=4
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting kafka broker log retention hours to $LOG_RETENTION_HOURS"

if [[ -z "$REPLICATION_FACTOR" ]]; then
  REPLICATION_FACTOR=1
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting replication factor for topics to $REPLICATION_FACTOR"

if [[ -z "$CONTROLLER_NAME" ]]; then
  CONTROLLER_NAME=localhost
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting Kraft Controller name to $CONTROLLER_NAME"

if [[ -z "$ADVERTISED_LISTENER" ]]; then
  echo "[HELK-DOCKER-INSTALLATION-INFO] ADVERTISED_LISTENER MUST BE SET WHEN RUNNING CONTAINER.."
  exit 1
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Setting Advertised listener value to $ADVERTISED_LISTENER"


echo "[HELK-DOCKER-INSTALLATION-INFO] Updating Kafka server properties file.."

sed -i "s/^node\.id\=.*$/node.id=${KAFKA_NODE_ID}/g" ${KAFKA_HOME}/config/server.properties
sed -i "s/^log\.retention\.hours\=.*$/log\.retention\.hours\=${LOG_RETENTION_HOURS}/g" ${KAFKA_HOME}/config/server.properties
sed -i "s/^process\.roles\=.*$/process.roles=${KAFKA_ROLE}/g" ${KAFKA_HOME}/config/server.properties

if [[ "$KAFKA_ROLE" == "controller" ]]
then
  sed -i "s/^advertised\.listeners\=PLAINTEXT:\/\/.*$//g"
  sed -i "s/^listeners\=PLAINTEXT:\/\/.*$/listeners\=CONTROLLER:\/\/:9093/g" ${KAFKA_HOME}/config/server.properties
  sed -i "s/^listeners\=PLAINTEXT:\/\/.*$/listeners=CONTROLLER:\/\/:9093/g" ${KAFKA_HOME}/config/server.properties
else
  sed -i "s/^listeners\=PLAINTEXT:\/\/.*$/listeners\=PLAINTEXT:\/\/${KAFKA_BROKER_NAME}\:${KAFKA_BROKER_PORT}/g" ${KAFKA_HOME}/config/server.properties
  sed -i "s/^advertised\.listeners\=PLAINTEXT:\/\/.*$/advertised\.listeners\=PLAINTEXT\:\/\/${ADVERTISED_LISTENER}\:${KAFKA_BROKER_PORT}/g" ${KAFKA_HOME}/config/server.properties
  sed -i "s/^controller\.quorum\.voters\=.*$/controller\.quorum\.voters\=1@${CONTROLLER_NAME}\:9093/g" ${KAFKA_HOME}/config/server.properties
fi

echo "[HELK-DOCKER-INSTALLATION-INFO] Create Kafka metadata properties file.."

${KAFKA_HOME}/bin/kafka-storage.sh format -t "${KAFKA_CLUSTER_ID}" -c "${KAFKA_HOME}/config/server.properties"

if [[ -z "$KAFKA_CREATE_TOPICS" ]]; then
  KAFKA_CREATE_TOPICS=winlogbeat
fi
echo "[HELK-DOCKER-INSTALLATION-INFO] Creating the following kafka topics: $KAFKA_CREATE_TOPICS"
./kafka-create-topics.sh &

exec "$@"
