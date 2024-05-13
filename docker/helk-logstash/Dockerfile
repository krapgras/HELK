# HELK script: HELK Logstash Dockerfile
# HELK build Stage: Alpha
# Author: Roberto Rodriguez (@Cyb3rWard0g)
# License: GPL-3.0

# References:
# https://cyberwardog.blogspot.com/2017/02/setting-up-pentesting-i-mean-threat_98.html

FROM docker.elastic.co/logstash/logstash:8.13.4
LABEL maintainer="Roberto Rodriguez @Cyb3rWard0g"
LABEL description="Dockerfile base for the HELK Logstash."

USER root
RUN apt-get update -y
RUN apt-get install zip -y
RUN apt-get install shared-mime-info -y

USER logstash
COPY --chown=logstash:logstash config /usr/share/logstash/config

# Build with plugins baked in
ENV plugins_time_file="/usr/share/logstash/helk-plugins-updated-timestamp.txt"
RUN printf "%s" "$(date +"%Y-%m-%d %T")" > "${plugins_time_file}"
RUN chown logstash:logstash "${plugins_time_file}"

COPY --chown=logstash:logstash plugins/helk-offline-logstash-codec_and_filter_plugins-split.zip /usr/share/logstash/plugins/helk-offline-logstash-codec_and_filter_plugins-split.zip
COPY --chown=logstash:logstash plugins/helk-offline-logstash-codec_and_filter_plugins-split.z01 /usr/share/logstash/plugins/helk-offline-logstash-codec_and_filter_plugins-split.z01
COPY --chown=logstash:logstash plugins/helk-offline-logstash-input-plugins-split.zip /usr/share/logstash/plugins/helk-offline-logstash-input-plugins-split.zip
COPY --chown=logstash:logstash plugins/helk-offline-logstash-input-plugins-split.z01 /usr/share/logstash/plugins/helk-offline-logstash-input-plugins-split.z01
COPY --chown=logstash:logstash plugins/helk-offline-logstash-input-plugins-split.z02 /usr/share/logstash/plugins/helk-offline-logstash-input-plugins-split.z02
COPY --chown=logstash:logstash plugins/helk-offline-logstash-output-plugins-split.zip /usr/share/logstash/plugins/helk-offline-logstash-output-plugins-split.zip
COPY --chown=logstash:logstash plugins/helk-offline-logstash-output-plugins-split.z01 /usr/share/logstash/plugins/helk-offline-logstash-output-plugins-split.z01
COPY --chown=logstash:logstash plugins/helk-offline-logstash-output-plugins-split.z02 /usr/share/logstash/plugins/helk-offline-logstash-output-plugins-split.z02

RUN zip -F /usr/share/logstash/plugins/helk-offline-logstash-input-plugins-split.zip --out /usr/share/logstash/plugins/helk-offline-logstash-input-plugins.zip
RUN zip -F /usr/share/logstash/plugins/helk-offline-logstash-codec_and_filter_plugins-split.zip --out /usr/share/logstash/plugins/helk-offline-logstash-codec_and_filter_plugins.zip
RUN zip -F /usr/share/logstash/plugins/helk-offline-logstash-output-plugins-split.zip --out /usr/share/logstash/plugins/helk-offline-logstash-output-plugins.zip
RUN bin/ruby -S gem install mimemagic -v '>= 0.3.7'
RUN logstash-plugin update \
    && logstash-plugin install file:///usr/share/logstash/plugins/helk-offline-logstash-codec_and_filter_plugins.zip \
    && logstash-plugin install file:///usr/share/logstash/plugins/helk-offline-logstash-input-plugins.zip \
    && logstash-plugin install file:///usr/share/logstash/plugins/helk-offline-logstash-output-plugins.zip \
    && rm -f /usr/share/logstash/pipeline/logstash.conf