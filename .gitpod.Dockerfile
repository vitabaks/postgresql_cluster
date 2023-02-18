FROM gitpod/workspace-python:latest

# install-packages is a wrapper for `apt` that helps skip a few commands in the docker env.

# install molecule and ansible
RUN sudo pip3 install molecule[docker] ansible
