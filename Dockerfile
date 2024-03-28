FROM ubuntu:jammy

USER root

# Copy postgresql_cluster repository
COPY . /postgresql_cluster

# Install required packages, Python dependencies, Ansible requirements, and perform cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/partial \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
       ca-certificates gnupg git python3 python3-pip keychain ssh-client sshpass \
    && pip3 install --no-cache-dir \
       ansible==9.3.0 \
       boto3==1.34.44 \
       dopy==0.3.7 \
       google-auth==2.28.0 \
       hcloud==1.33.2 \
    && ansible-galaxy install -r \
       postgresql_cluster/roles/consul/requirements.yml \
    && apt-get autoremove -y --purge gnupg git \
    && apt-get clean -y autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Set environment variable for Ansible collections paths
ENV ANSIBLE_COLLECTIONS_PATHS=/usr/lib/python3/dist-packages/ansible_collections
ENV USER=root

WORKDIR /postgresql_cluster
