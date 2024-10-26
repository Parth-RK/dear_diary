# Base image with Flutter SDK
FROM cirrusci/flutter:stable

#OR

# Use Google's Flutter Docker image
# FROM google/flutter:latest

# Set the working directory
WORKDIR /app

# Copy pubspec files and fetch dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the project files
COPY . .

# Build APK
RUN flutter build apk --release

# Build for web
RUN flutter build web --release

# Expose port for the web app
EXPOSE 8080

# Optional: Set default CMD for web or server running if needed
# If you need to serve the web build, you can add a simple web server, e.g., using Python:
# CMD ["python3", "-m", "http.server", "--directory", "build/web", "8080"]
