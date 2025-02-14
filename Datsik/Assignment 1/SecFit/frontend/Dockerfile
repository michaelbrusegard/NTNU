# Use a base Node image
FROM node:latest

# Enable bash and install dos2unix
RUN if [ -f /etc/alpine-release ]; then \
        apk add --no-cache bash dos2unix; \
    else \
        apt-get update && apt-get install -y bash dos2unix; \
    fi

# Install react essentials
RUN npm install react-scripts@4.0.3 -g && npm install -g serve

# Set the working directory inside the container
WORKDIR /src

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the source code
COPY . .

# Convert entrypoint script to unix format if PC is running windows
RUN dos2unix entrypoint.sh

# Start app
CMD ["/bin/bash", "entrypoint.sh"]
