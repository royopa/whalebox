FROM python:3-alpine

ENV WHALEBOX_HOME /opt/whalebox
ENV WHALEBOXES ${WHALEBOX_HOME}/conf/whaleboxes.yaml

ADD whalebox ${WHALEBOX_HOME}
WORKDIR ${WHALEBOX_HOME}
RUN python setup.py install

ENTRYPOINT ["whalebox"]