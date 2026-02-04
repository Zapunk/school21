package com.s21.devops.sample.bookingservice.Statistics;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.s21.devops.sample.bookingservice.Communication.BookingStatisticsMessage;
import io.micrometer.core.instrument.Counter;          // NEW
import io.micrometer.core.instrument.MeterRegistry;   // NEW
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class QueueProducer {
    @Value("${fanout.exchange}")
    private String fanoutExchange;

    @Autowired
    private final RabbitTemplate rabbitTemplate;        // CHANGED
    private final Counter messagesSentCounter;          // NEW    

    private final ObjectMapper objectMapper = new ObjectMapper();       // CHANGED

    // NEW: используем constructor injection
    public QueueProducer(RabbitTemplate rabbitTemplate,
                         MeterRegistry meterRegistry) {

        this.rabbitTemplate = rabbitTemplate;

        // NEW: регистрируем метрику
        this.messagesSentCounter = Counter.builder(
                        "booking_rabbitmq_messages_sent_total"
                )
                .description("Total number of messages sent to RabbitMQ by booking-service")
                .register(meterRegistry);
    }


    public void putStatistics(BookingStatisticsMessage bookingStatisticsMessage) throws JsonProcessingException {
        System.out.println("Sending message...");
        rabbitTemplate.setExchange(fanoutExchange);
        rabbitTemplate.convertAndSend(objectMapper.writeValueAsString(bookingStatisticsMessage));
        System.out.println("Message was sent successfully!");

        // NEW: инкремент ТОЛЬКО после успешной отправки
        messagesSentCounter.increment();
    }
}
