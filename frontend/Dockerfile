FROM node:20-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm

# Create and set working directory
WORKDIR /app/frontend

# Copy package files
COPY frontend/package.json frontend/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy application code
COPY frontend/ .

# Expose port
EXPOSE 3000

# Start development server
CMD ["pnpm", "start"]