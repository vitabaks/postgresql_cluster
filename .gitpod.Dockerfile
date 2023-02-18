FROM gitpod/workspace-python-3.11:latest

# install molecule and ansible
RUN sudo pip3 install molecule[docker] ansible
