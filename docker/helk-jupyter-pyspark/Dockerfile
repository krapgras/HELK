# Notebooks Forge script: Jupyter PySpark Environment Dockerfile
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

FROM docker-helk-jupyter-base
LABEL maintainer="Roberto Rodriguez @Cyb3rWard0g"
LABEL description="Notebooks Forge Jupyter Project."

ENV DEBIAN_FRONTEND noninteractive

USER root

# *********** Spark Env Variables ***************
ENV SPARK_VERSION=3.5.1
ENV APACHE_HADOOP_VERSION=3
ENV SPARK_HOME=/opt/jupyter/spark
ENV SPARK_LOGS=$SPARK_HOME/logs

# *********** Installing Prerequisites ***************
# -qq : No output except for errors
RUN apt-get update -qq \
  && apt-get install -qqy openjdk-8-jre-headless ca-certificates-java \
  && apt-get -qy clean autoremove \
  && rm -rf /var/lib/apt/lists/* \
  # *********** Installing Spark ***************
  && bash -c 'mkdir -pv /opt/jupyter/spark/logs' \
  && wget -qO- http://mirror.cogentco.com/pub/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${APACHE_HADOOP_VERSION}.tgz | tar xvz -C ${SPARK_HOME} --strip-components=1 \
  && mkdir -p $SPARK_LOGS \
  && chown -R ${USER} ${JUPYTER_DIR} ${HOME}

# *********** Adding scripts and files to Container ***************
COPY spark/* ${SPARK_HOME}/conf/
COPY kernels/pyspark_kernel.json /usr/local/share/jupyter/kernels/pyspark3/kernel.json

RUN chown -R ${USER} ${JUPYTER_DIR} ${HOME} ${SPARK_HOME} \
  && chown ${USER} /usr/local/share/jupyter/kernels/pyspark3/kernel.json

EXPOSE 8000

USER ${USER}