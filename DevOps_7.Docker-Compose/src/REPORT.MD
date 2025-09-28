## Part 1. Запуск нескольких Docker-контейнеров с использованием Docker Compose

Создание Dockerfile для каждого микросервиса:

Докерфайлы для микросервисов одинаковые, рассмотрим только на примере `gateway-service`. В сборки использовал multi-stage для облегчения образа. В стадии 'builder' использовал образ `maven` где уже есть большинство зависимостей. А в финальном образе использовал более стабильный `eclipse`, в который перенес уже готовый исполняемый файл .jar

```docker
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY .mvn/ .mvn/
COPY pom.xml .
RUN mvn -B -Dmaven.repo.local=/root/.m2/repository --no-transfer-progress dependency:go-offline
COPY src ./src
RUN mvn -B package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN apk add --no-cache bash
COPY --from=builder /app/target/*.jar ./app.jar
COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh
CMD ["./wait-for-it.sh", "-t", "40", "db:5432", "--",\
     "./wait-for-it.sh", "-t", "40", "hotel-service:8082", "--",\
     "./wait-for-it.sh", "-t", "40", "session-service:8081", "--",\
     "./wait-for-it.sh", "-t", "40", "booking-service:8083", "--",\
     "./wait-for-it.sh", "-t", "40", "payment-service:8084", "--",\
     "./wait-for-it.sh", "-t", "40", "loyalty-service:8085", "--",\
     "./wait-for-it.sh", "-t", "40", "report-service:8086",  "--",\
     "java", "-jar", "./app.jar"]
```

Для обмена данными между микросервисами использовал стандартный брокер

![1](img/1.png)

На скриншоте видим что размеры оброзов получились небольшими.  

![3](img/3.png)

В докер-компос:
- прописываю сервисы. 
- прокидываю порты  наружу `например "8083:8083"`. 
- Прописываю сеть `app-network`, чтоб сервисы могли подключаться к ней и обращаться друк к другу по имени хоста `например db:5432`. 
- прописываю переменные окружения. 
- В 'db' прописал том, что бы .sql-файлы выполнились автоматически и хранились локально.
- Прописываю 'restart' что бы контейнер автоматически перезапускался, если упадет. 

```yaml
services:
  rabbitmq:
    image: rabbitmq:3-management-alpine
    ports:
      - "5672:5672"
      - "15672:15672"
    networks:
      - app-network

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    networks:
      - app-network
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    volumes:
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
      - db_data:/var/lib/postgresql/data
    
  booking-service:
    restart: unless-stopped
    build: ./booking-service/
    networks:
      - app-network
    ports:
      - "8083:8083"
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: reservations_db
      RABBIT_MQ_HOST: rabbitmq
      RABBIT_MQ_PORT: 5672
      RABBIT_MQ_USER: guest
      RABBIT_MQ_PASSWORD: guest
      RABBIT_MQ_QUEUE_NAME: messagequeue
      RABBIT_MQ_EXCHANGE: messagequeue-exchange
      HOTEL_SERVICE_HOST: hotel-service
      HOTEL_SERVICE_PORT: 8082
      PAYMENT_SERVICE_HOST: payment-service
      PAYMENT_SERVICE_PORT: 8084
      LOYALTY_SERVICE_HOST: loyalty-service
      LOYALTY_SERVICE_PORT: 8085
    depends_on:
      - db
      - rabbitmq

  session-service:
    restart: unless-stopped
    build: ./session-service/
    networks:
      - app-network
    ports:
      - "8081:8081"
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: "postgres"
      POSTGRES_DB: users_db
    depends_on:
      - db

  hotel-service:
    restart: unless-stopped
    build: ./hotel-service/
    networks:
      - app-network
    ports:
      - "8082:8082"
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: "postgres"
      POSTGRES_DB: hotels_db
    depends_on:
      - db

  payment-service:
    restart: unless-stopped
    build: ./payment-service/
    networks:
      - app-network
    ports:
      - "8084:8084"
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: "postgres"
      POSTGRES_DB: payments_db
    depends_on:
      - db

  loyalty-service:
    restart: unless-stopped
    build: ./loyalty-service/
    networks:
      - app-network
    ports:
      - "8085:8085"
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: "postgres"
      POSTGRES_DB: balances_db
    depends_on:
      - db

  report-service:
    restart: unless-stopped
    build: ./report-service/
    networks:
      - app-network
    ports:
      - "8086:8086"
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: "postgres"
      POSTGRES_DB: statistics_db
      RABBIT_MQ_HOST: rabbitmq
      RABBIT_MQ_PORT: 5672
      RABBIT_MQ_USER: guest
      RABBIT_MQ_PASSWORD: guest
      RABBIT_MQ_QUEUE_NAME: messagequeue
      RABBIT_MQ_EXCHANGE: messagequeue-exchange
    depends_on:
      - db
      - rabbitmq

  gateway-service:
    restart: unless-stopped
    build: ./gateway-service/
    ports:
      - "8087:8087"
    networks:
      - app-network
    environment:
      SESSION_SERVICE_HOST: session-service
      SESSION_SERVICE_PORT: 8081
      HOTEL_SERVICE_HOST: hotel-service
      HOTEL_SERVICE_PORT: 8082
      BOOKING_SERVICE_HOST: booking-service
      BOOKING_SERVICE_PORT: 8083
      PAYMENT_SERVICE_HOST: payment-service
      PAYMENT_SERVICE_PORT: 8084
      LOYALTY_SERVICE_HOST: loyalty-service
      LOYALTY_SERVICE_PORT: 8085
      REPORT_SERVICE_HOST: report-service
      REPORT_SERVICE_PORT: 8086
    depends_on:
      - booking-service
      - hotel-service
      - session-service
      - payment-service
      - loyalty-service
      - report-service

networks:
  app-network:

volumes:
  db_data:
```

Собираем и разворачиваем веб-сервис с помощью Docker Compose 

![2](img/2.png)

Запускаем тесты в 'Postman' и видим что все ОК

![4](img/4.png)

## Part 2. Создание виртуальных машин

