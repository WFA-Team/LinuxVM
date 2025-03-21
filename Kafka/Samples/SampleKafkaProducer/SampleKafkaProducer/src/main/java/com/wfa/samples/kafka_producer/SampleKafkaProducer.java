package com.wfa.samples.kafka_producer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;

public class SampleKafkaProducer {

    public static void main(String[] args) {

        String bootstrapServers = "192.168.56.3:9092"; // Replace with your Kafka broker address
        String topic = "test-topic"; // Replace with your topic name

        Properties properties = new Properties();
        properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        try (KafkaProducer<String, String> producer = new KafkaProducer<>(properties)) {

            for (int i = 0; i < 10; i++) {
                String key = "key-" + i;
                String value = "message-" + i;
                ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, value);

                producer.send(record, (metadata, exception) -> {
                    if (exception == null) {
                        System.out.println("Message sent: Key = " + key + ", Value = " + value + ", Partition = " + metadata.partition() + ", Offset = " + metadata.offset());
                    } else {
                        System.err.println("Error sending message: " + exception.getMessage());
                        exception.printStackTrace();
                    }
                });
            }

            producer.flush(); // Ensure all messages are sent

        } catch (Exception e) {
            System.err.println("Failed to create Kafka producer: " + e.getMessage());
            e.printStackTrace();
        }
    }
}