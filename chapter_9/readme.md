### Install Packer

Follow the steps at https://learn.hashicorp.com/tutorials/packer/getting-started-install

### Install Ansible

* sudo apt install ansible

### Test Ansible using Docker

The following approach is useful to test the Ansible playbook in a local Docker container instead of potentially incurring a small cost on AWS due to repeated Packer builds.

> docker build --pull --rm -f "chapter_9/graylog/Dockerfile" -t learnsysops:chapter9 "chapter_9/graylog"