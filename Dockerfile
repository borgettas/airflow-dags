# FROM apache/airflow:1.10.15-python3.8 as base
FROM apache/airflow:2.5.0-python3.10 as base

ARG GROUP_ID
ARG USER_ID

ENV USER=airflow
ENV USER_HOME_DIR=/home/$USER

USER root

RUN mkdir -p /opt/airflow/
COPY . /opt/airflow

RUN chown -R "${USER}" /opt/airflow/ && \
    chmod +x /opt/airflow/docker/*.bash

RUN mkdir /opt/lala

USER ${USER}

ENV PATH="${PATH}:/${USER_HOME_DIR}/.local/bin"

FROM base AS app

HEALTHCHECK CMD /opt/airflow/docker/healthcheck.bash
ENTRYPOINT [ "/bin/bash" ]
