#!/bin/bash

sudo ufw disable
dos2unix install_docker.sh
dos2unix kafka_container.sh
sudo /bin/bash install_docker.sh
sudo /bin/bash kafka_container.sh
