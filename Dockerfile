# ---------- Stage 1: Build the application ----------
FROM maven:3.8.5-openjdk-8-slim AS build

# Set the working directory
WORKDIR /app

# Copy pom.xml and download dependencies first (to leverage caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the project
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# Optional: Debug - Show what was built
RUN ls -lh target/

# ---------- Stage 2: Run the application ----------
FROM openjdk:8-alpine

ENV PROJECT_HOME=/opt/app
WORKDIR $PROJECT_HOME

# Adjust this line if your jar name is different
COPY --from=build /app/target/spring-boot-mongo-1.0.0-SNAPSHOT.jar spring-boot-mongo.jar

EXPOSE 8080

CMD ["java", "-jar", "spring-boot-mongo.jar"]
