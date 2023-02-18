FROM ubuntu:jammy

USER root

RUN apt update \
    && apt install ca-certificates curl gnupg lsb-release -yq git git-lfs sudo \
    # install docker
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update && apt install docker-ce docker-ce-cli containerd.io \
    # install python
    && apt install python3 \
    # install molecule and ansible
    && pip3 install molecule[docker] ansible
    # clean
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# Create the gitpod user. UID must be 33333.
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

USER gitpod
