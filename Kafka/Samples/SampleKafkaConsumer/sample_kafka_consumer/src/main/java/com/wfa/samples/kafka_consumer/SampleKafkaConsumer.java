package com.wfa.samples.kafka_consumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.time.Duration;
import java.util.Arrays;
import java.util.Properties;

public class SampleKafkaConsumer {

    public static void main(String[] args) {

        String bootstrapServers = "192.168.56.3:9092"; // Replace with your Kafka broker address
        String groupId = "test-group";
        String topic = "test-topic"; // Replace with your topic name

        Properties properties = new Properties();
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest"); // or "latest"
        properties.setProperty(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        properties.setProperty("log4j.logger.org.apache.kafka.clients.consumer", "DEBUG");

        try (KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties)) {
            consumer.subscribe(Arrays.asList(topic));

            System.out.println("Consumer subscribed to topic: " + topic);

            try {
            	while (true) {
	                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(3000)); // Poll for 10 seconds
	                if (records.isEmpty()) {
	                    System.out.println("No messages received within the timeout. Kafka connectivity is likely working, but no messages exist on the topic.");
	                }
	
	                for (ConsumerRecord<String, String> record : records) {
	                    System.out.println("Received message: Key = " + record.key() + ", Value = " + record.value() + ", Partition = " + record.partition() + ", Offset = " + record.offset());
	                }
            	}
            } catch (org.apache.kafka.common.errors.WakeupException e) {
                System.out.println("Consumer poll interrupted.");
            } catch (Exception e) {
                System.err.println("Error consuming messages: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (Exception e) {
            System.err.println("Failed to create Kafka consumer: " + e.getMessage());
            e.printStackTrace();
        }
    }
}