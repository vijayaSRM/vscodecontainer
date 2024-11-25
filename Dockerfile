# Use Node.js as the base image
FROM node:20-slim

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install system dependencies including Python and build tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    git \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm

# Create directory structure
WORKDIR /app
RUN mkdir backend frontend

# Python setup
WORKDIR /app/backend

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY backend/requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir typing-extensions && \
    pip install --no-cache-dir -r requirements.txt

# Copy Python application code
COPY backend/ .
RUN pip install .

# Node.js setup
WORKDIR /app/frontend

# Copy package files
COPY frontend/package.json frontend/pnpm-lock.yaml ./

# Install Node.js dependencies
RUN pnpm install

# Copy frontend application code
COPY frontend/ .

# Expose ports for both services
EXPOSE 3000 8000

# Create a startup script
WORKDIR /app
RUN echo '#!/bin/bash\n\
    cd /app/backend && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload & \n\
    cd /app/frontend && pnpm start' > /app/start.sh && \
    chmod +x /app/start.sh

# Set the default command to run both services
CMD ["/app/start.sh"]
