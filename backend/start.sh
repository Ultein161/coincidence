#!/bin/bash
DB_USER=$(echo "$DATABASE_URL" | sed -E 's|postgresql://([^:]+):([^@]+)@([^/]+)/([^?]+)(.*)|\1|')
DB_PASS=$(echo "$DATABASE_URL" | sed -E 's|postgresql://([^:]+):([^@]+)@([^/]+)/([^?]+)(.*)|\2|')
DB_HOST=$(echo "$DATABASE_URL" | sed -E 's|postgresql://([^:]+):([^@]+)@([^/]+)/([^?]+)(.*)|\3|')
DB_NAME=$(echo "$DATABASE_URL" | sed -E 's|postgresql://([^:]+):([^@]+)@([^/]+)/([^?]+)(.*)|\4|')

export JDBC_DATABASE_URL="jdbc:postgresql://${DB_HOST}/${DB_NAME}?sslmode=require"
export DB_USERNAME="${DB_USER}"
export DB_PASSWORD="${DB_PASS}"

java -jar target/coincidence-0.0.1-SNAPSHOT.jar
