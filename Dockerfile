# using ubuntu base image
FROM ubuntu:20.04

# Use default  answers for all questions.
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install clangd cmake build-essential python3-pip vim git && \
    pip3 install clang-format cmake-format 

COPY . /app

RUN cd app && cmake -D ENABLE_TESTING=ON -B build && cmake --build build && cd build && ctest --verbose



# TODO: Make this optional via a flag.
# Optional: Share ssh key with container. 
# Use this if you want to have access to
# private git repos while running the container interactively. share ssh keys
# with container.
#
# Must use build flags:
# `--secret id=pub_key,src=/home/$USER/.ssh/id_rsa.pub 
#  --secret id=prv_key,src=/home/$USER/.ssh/id_rsa `
RUN mkdir -p -m 0400 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=secret,id=prv_key,dst=/prv_key cat /prv_key >> ~/.ssh/id_rsa
RUN --mount=type=secret,id=pub_key,dst=/pub_key cat /pub_key >> ~/.ssh/id_rsa.pub
# Add proper permissions to ssh folder
RUN chmod -R 400 ~/.ssh/