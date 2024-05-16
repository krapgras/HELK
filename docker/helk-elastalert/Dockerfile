# HELK script: HELK Elastalert2 Dockerfile
# HELK build Stage: Alpha
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

FROM python:3.12-slim
LABEL maintainer="Ignace De Cock @Krapgras"
LABEL description="Dockerfile base for the HELK elastalert2."

ENV ESALERT_GID=1000
ENV ESALERT_UID=1000
ENV ESALERT_USER=elastalertuser
ENV ESALERT_HOME=/etc/elastalert
ENV ESALERT_SIGMA_HOME=/opt/sigma

RUN apt update && apt -y upgrade \
    && apt -y install jq curl gcc libffi-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/jertel/elastalert2.git ${ESALERT_HOME} \
    && bash -c 'mkdir -pv /etc/elastalert/rules' \
    && cd ${ESALERT_HOME} \
    && pip install setuptools wheel \
    && python setup.py sdist bdist_wheel \
    && pip install ${ESALERT_HOME}/dist/*.tar.gz \
    && pip install sigma-cli \
    && sigma plugin install sysmon \
    && sigma plugin install windows \
    && apt -y remove gcc libffi-dev \
    && apt -y autoremove \
    # ********* Download SIGMA *******************
    && git clone https://github.com/SigmaHQ/sigma.git ${ESALERT_SIGMA_HOME}

# ********* Copy Elastalert files **************
COPY scripts/* ${ESALERT_HOME}/
COPY config.yaml ${ESALERT_HOME}/
COPY pull-sigma-config.yaml ${ESALERT_HOME}/
COPY rules/* ${ESALERT_HOME}/rules/
COPY sigmac/sigmac-config.yml ${ESALERT_SIGMA_HOME}/sigmac-config.yml

RUN chmod +x ${ESALERT_HOME}/pull-sigma.sh \
# ********* Adding Elastalert User *************
    && groupadd -g ${ESALERT_GID} ${ESALERT_USER} \
    && useradd -u ${ESALERT_UID} -g ${ESALERT_GID} -d ${ESALERT_HOME} --no-create-home -s /bin/bash ${ESALERT_USER} \
    && chown -R ${ESALERT_USER}:${ESALERT_USER} ${ESALERT_HOME} ${ESALERT_SIGMA_HOME}
      
USER ${ESALERT_USER}

ENV TZ "UTC"

WORKDIR ${ESALERT_HOME}
# *********** RUN Elastalert ***************
ENTRYPOINT ["./elastalert-entrypoint.sh"]
CMD ["/bin/bash","-c","elastalert","--verbose"]