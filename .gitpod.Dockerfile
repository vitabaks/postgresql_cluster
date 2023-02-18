FROM gitpod/workspace-python:latest

# install molecule and ansible
RUN sudo pip3 install molecule[docker] ansible
