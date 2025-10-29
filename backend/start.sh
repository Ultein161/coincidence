#!/bin/bash

echo "=== Starting Spring Boot Backend ==="
echo "Java version:"
java -version

echo ""
echo "=== Database Configuration ==="
echo "DATABASE_URL: ${DATABASE_URL}"
echo "PGUSER: ${PGUSER}"
echo "PGDATABASE: ${PGDATABASE}"

# Преобразуем PostgreSQL URL в JDBC URL и убираем credentials из URL
# postgresql://user:pass@host:port/db -> jdbc:postgresql://host:port/db
JDBC_URL=$(echo "${DATABASE_URL}" | sed 's|^postgresql://[^@]*@|jdbc:postgresql://|')
echo "JDBC_URL (without credentials): ${JDBC_URL}"

echo ""
echo "=== Building and Running Application ==="

# Запускаем Spring Boot через Maven с переопределением database properties
mvn spring-boot:run \
  -Dspring-boot.run.arguments="--spring.datasource.url=${JDBC_URL} --spring.datasource.username=${PGUSER} --spring.datasource.password=${PGPASSWORD}"
