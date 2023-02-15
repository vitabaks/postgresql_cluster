FROM ubuntu:22.04
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y \
    python3 \
    python3-pip \
    git \
    && apt-get clean
RUN python3 -m pip install --user ansible==7.2.0 ansible-core==2.14.2
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && echo "$SNIPPET" >> "/root/.bashrc"
ENV PATH="$PATH:/root/.local/bin"
ENV LC_ALL=en_US.UTF-8  
ENV LANG=en_US.UTF-8