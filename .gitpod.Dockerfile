FROM ubuntu:jammy

USER root

# install packages
RUN apt update && apt install ca-certificates curl gnupg lsb-release -yq git git-lfs sudo python3 python3-pip

# install docker
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
#    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
#    && apt update \
#    && apt install docker-ce docker-ce-cli containerd.io

# install molecule and ansible
RUN pip3 install molecule[docker] ansible ansible-lint yamllint

# clean
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# Create the gitpod user. UID must be 33333.
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

USER gitpod
