# HELK script: HELK Jupyter Dockerfile
# HELK build Stage: Alpha
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

FROM docker-helk-jupyter-hunt
LABEL maintainer="Roberto Rodriguez @Cyb3rWard0g"
LABEL description="Dockerfile Notebooks-Forge Jupyter-Hunt Project."

ENV DEBIAN_FRONTEND noninteractive

USER root

# *********** Setting Environment Variables ***************
ENV POSTGRESQL_VERSION=42.7.3

# ********** Installing additional libraries **************
RUN mkdir /opt/jupyter/notebooks/datasets \
    && apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    postgresql postgresql-contrib \
    # ********** Clean APT **********
    && apt-get -qy clean autoremove \
    && rm -rf /var/lib/apt/lists/* \
    # ********** Download Postgresql JAR *****************
    && wget https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_VERSION}.jar -P /opt/jupyter/spark/jars/

# *********** Adding HELK scripts and files to Container ***************
COPY notebooks/demos ${JUPYTER_DIR}/notebooks/demos
COPY notebooks/tutorials ${JUPYTER_DIR}/notebooks/tutorials
COPY notebooks/sigma ${JUPYTER_DIR}/notebooks/sigma
COPY spark/* ${SPARK_HOME}/conf/
COPY scripts/* ${JUPYTER_DIR}/scripts/

RUN chown -R ${USER} ${JUPYTER_DIR} ${HOME} ${SPARK_HOME} \
    && chown ${USER} /run/postgresql \
    && chown ${USER} /opt/jupyter/scripts/jupyter-cmd.sh \
    && chmod +x /opt/jupyter/scripts/jupyter-cmd.sh
#Fix hyperframe to work on python 3.11
RUN sed -i '/import collections/a import sys\nif sys.version_info.major == 3 and sys.version_info.minor >= 10:\n    setattr(collections, "MutableSet", collections.abc.MutableSet)\n    setattr(collections, "MutableMapping", collections.abc.MutableMapping)' /opt/conda/lib/python3.11/site-packages/hyperframe/flags.py

WORKDIR ${HOME}
ENTRYPOINT ["/opt/jupyter/scripts/jupyter-entrypoint.sh"]
CMD ["/opt/jupyter/scripts/jupyter-cmd.sh"]

USER ${USER}

