# Notebooks Forge script: Jupyter Hunt Environment Dockerfile
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

FROM docker-helk-jupyter-pyspark
LABEL maintainer="Roberto Rodriguez @Cyb3rWard0g"
LABEL description="Notebooks Forge Jupyter Project."

ENV DEBIAN_FRONTEND noninteractive

# *********** Setting Environment Variables ***************
ENV GRAPHFRAMES_VERSION=0.8.3
ENV KAFKA_VERSION=3.7.0
ENV SCALA_VERSION=2.13
ENV SLF4J_API_VERSION=2.0.9
ENV LZ4_JAVA=1.8.0
ENV SNAPPY_JAVA=1.1.9.1
ENV ESHADOOP_VERSION=8.13.4
ENV ESHADOOP_DIR=${JUPYTER_DIR}/es-hadoop

USER $USER
# **** Current Channels ***********
#- https://repo.anaconda.com/pkgs/main/linux-64
#- https://repo.anaconda.com/pkgs/main/noarch
#- https://repo.anaconda.com/pkgs/free/linux-64
#- https://repo.anaconda.com/pkgs/free/noarch
#- https://repo.anaconda.com/pkgs/r/linux-64
#- https://repo.anaconda.com/pkgs/r/noarch
RUN mkdir -v ${ESHADOOP_DIR} \
  # *********** Install Jupyter Notebook & Extra Packages with Conda *************
  && conda install --quiet --yes \
    'altair=5.3.0' \
    's3fs=2024.5.0' \
    'elasticsearch-dsl=8.13.1' \
    'matplotlib=3.9.0' \
    'networkx=3.3' \
    'nxviz=0.7.4' \
  && conda update --all --quiet --yes \
  # *********** Clean *****************
  && conda clean -tipy \
  && conda build purge-all \
  && rm -rf /home/$USER/.cache/yarn \
  # *********** Install Pip packages not availabe via conda ************
  && python3 -m pip install ksql==0.10.2 confluent-kafka==2.4.0 splunk-sdk==2.0.1 Kqlmagic==0.1.114.post24 neo4j==5.20.0 openhunt==1.8.5 pyarrow==16.1.0 msticpy==2.12.0 \
  # *********** Download ES-Hadoop ***************
  && wget https://artifacts.elastic.co/downloads/elasticsearch-hadoop/elasticsearch-hadoop-${ESHADOOP_VERSION}.zip -P ${ESHADOOP_DIR}/ \
  && unzip -j ${ESHADOOP_DIR}/*.zip -d ${ESHADOOP_DIR}/ \
  && rm ${ESHADOOP_DIR}/*.zip \
  # *********** Download Graphframes Jar ***************
  && wget https://repos.spark-packages.org/graphframes/graphframes/${GRAPHFRAMES_VERSION}-spark3.5-s_2.13/graphframes-${GRAPHFRAMES_VERSION}-spark3.5-s_2.13.jar -P ${SPARK_HOME}/jars/ \
  && cp ${SPARK_HOME}/jars/graphframes* ${SPARK_HOME}/graphframes.zip \
  # *********** Download Extra Jars ***************
  && wget https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_${SCALA_VERSION}/${SPARK_VERSION}/spark-sql-kafka-0-10_${SCALA_VERSION}-${SPARK_VERSION}.jar -P ${SPARK_HOME}/jars/ \
  && wget https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/${KAFKA_VERSION}/kafka-clients-${KAFKA_VERSION}.jar -P ${SPARK_HOME}/jars/ \
  && wget https://repo1.maven.org/maven2/org/slf4j/slf4j-api/${SLF4J_API_VERSION}/slf4j-api-${SLF4J_API_VERSION}.jar -P ${SPARK_HOME}/jars/ \
  && wget https://repo1.maven.org/maven2/org/spark-project/spark/unused/1.0.0/unused-1.0.0.jar -P ${SPARK_HOME}/jars/ \
  && wget https://repo1.maven.org/maven2/org/lz4/lz4-java/${LZ4_JAVA}/lz4-java-${LZ4_JAVA}.jar -P ${SPARK_HOME}/jars \
  && wget https://repo1.maven.org/maven2/org/xerial/snappy/snappy-java/${SNAPPY_JAVA}/snappy-java-${SNAPPY_JAVA}.jar -P ${SPARK_HOME}/jars/

# *********** Adding HELK scripts and files to Container ***************
COPY spark/* ${SPARK_HOME}/conf/

USER root

RUN chown -R ${USER} ${JUPYTER_DIR} ${HOME} ${SPARK_HOME}

USER ${USER}