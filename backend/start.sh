#!/bin/bash

echo "=== Starting Spring Boot Backend ==="
echo "Java version:"
java -version

echo ""
echo "=== Building and Running Application ==="

# Устанавливаем переменные окружения из Replit PostgreSQL
export SPRING_DATASOURCE_URL="${DATABASE_URL}"
export SPRING_DATASOURCE_USERNAME="${PGUSER}"
export SPRING_DATASOURCE_PASSWORD="${PGPASSWORD}"

# Запускаем Spring Boot через Maven
mvn spring-boot:run
