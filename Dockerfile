FROM python:alpine

RUN set -ex \
    && apk --update add rpm openssh-client openssl ca-certificates wget \
    && apk --update add --virtual build-dependencies python3-dev libffi-dev openssl-dev build-base \
    && pip3 install --upgrade pip pycrypto cffi \
    && pip3 install ansible==2.8.1 \
    && pip3 install jinja2==2.10.1 \
    && pip3 install netaddr==0.7.19 \
    && pip3 install pbr==5.2.0 \
    && pip3 install hvac==0.8.2 \
    && pip3 install jmespath==0.9.4 \
    && pip3 install ruamel.yaml==0.15.96 \
    && pip3 install boto \
    && pip3 install boto3 \
    && pip3 install passlib \
    && pip3 install paramiko \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/ansible \
    && echo 'localhost' > /etc/ansible/hosts

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library

WORKDIR /ansible/playbooks

ENTRYPOINT ["ansible-playbook"]