#!/bin/bash

# Wait for Kafka to fully start
sleep 10

# Check if __consumer_offsets exists
EXISTING_TOPIC=$(kafka-topics --bootstrap-server 192.168.56.3:9092 --list | grep __consumer_offsets)

# Create the topic if it doesn't exist
if [ -z "$EXISTING_TOPIC" ]; then
  echo "Creating __consumer_offsets topic..."
  kafka-topics --bootstrap-server 192.168.56.3:9092 \
    --create --topic __consumer_offsets \
    --partitions 50 --replication-factor 1 \
    --config cleanup.policy=compact
else
  echo "__consumer_offsets already exists."
fi