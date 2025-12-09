FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY . .
RUN mvn clean package -DskipTests

# ===== Runtime Stage =====
FROM tomcat:9.0-jdk17

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR as ROOT app
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
