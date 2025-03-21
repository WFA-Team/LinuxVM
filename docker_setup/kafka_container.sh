#!/bin/bash

sudo apt install kafkacat --assume-yes
docker pull confluentinc/cp-kafka:latest
docker run -d \
  --network=host \
  --name="kafka_server" \
  -e KRAFT_ENABLED=true \
  -e CLUSTER_ID="$(docker run --rm confluentinc/cp-kafka:latest /usr/bin/kafka-storage random-uuid)" \
  -e KAFKA_PROCESS_ROLES="controller,broker" \
  -e KAFKA_NODE_ID=1 \
  -e KAFKA_LISTENERS="PLAINTEXT://192.168.56.3:9092,CONTROLLER://192.168.56.3:9093" \
  -e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://192.168.56.3:9092" \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS="1@192.168.56.3:9093" \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT" \
  -e KAFKA_CONTROLLER_LISTENER_NAMES="CONTROLLER" \
  -e KAFKA_INTER_BROKER_LISTENER_NAME="PLAINTEXT" \
  confluentinc/cp-kafka:latest

docker cp /docker_setup/create_offsets.sh kafka_server:/home/create_offsets.sh
docker exec kafka_server /home/create_offsets.sh