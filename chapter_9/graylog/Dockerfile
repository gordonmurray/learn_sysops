# A simple Dockerfile to test Ansible roles before using Packer

FROM ubuntu:18.04

RUN apt update && apt upgrade -y && apt install python ansible -y

COPY ./ansible /home/ubuntu/ansible

WORKDIR /home/ubuntu/ansible

RUN ansible-playbook graylog.yml

#RUN tail -f /dev/null