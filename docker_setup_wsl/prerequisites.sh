#!/bin/bash

sudo ufw disable
dos2unix install_docker.sh
dos2unix kafka_container.sh
dos2unix docker-compose.yml
dos2unix ksql_schema.sh
/bin/bash ./install_docker.sh
sg docker -c './kafka_container.sh'
sg docker -c './ksql_schema.sh'
apt install kcat
