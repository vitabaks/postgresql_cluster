FROM ubuntu:jammy

USER root

# install packages
RUN apt-get clean && rm -rf /var/lib/apt/lists/partial \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
       ca-certificates gnupg git python3 python3-pip keychain

# copy postgresql_cluster repository
COPY . /postgresql_cluster

# install ansible and dependencies
RUN pip3 install --no-cache-dir \
    ansible==8.4.0 \
    boto3==1.28.49 \
    dopy==0.3.7 \
    google-auth==2.23.0 \
    hcloud==1.28.0

# install requirements
RUN ansible-galaxy install -r \
    postgresql_cluster/roles/consul/requirements.yml

# clean
RUN apt-get autoremove -y --purge gnupg git \
    && apt-get clean -y autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# set environment variable for Ansible collections paths
ENV ANSIBLE_COLLECTIONS_PATHS=/usr/lib/python3/dist-packages/ansible_collections
ENV USER=root

WORKDIR /postgresql_cluster
