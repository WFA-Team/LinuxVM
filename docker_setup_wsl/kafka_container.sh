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
  -e KAFKA_LISTENERS="PLAINTEXT://localhost:9092,CONTROLLER://localhost:9093" \
  -e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://localhost:9092" \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS="1@localhost:9093" \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT" \
  -e KAFKA_CONTROLLER_LISTENER_NAMES="CONTROLLER" \
  -e KAFKA_INTER_BROKER_LISTENER_NAME="PLAINTEXT" \
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  confluentinc/cp-kafka:latest

docker cp ./create_offsets.sh kafka_server:/home/create_offsets.sh
docker exec kafka_server /home/create_offsets.sh