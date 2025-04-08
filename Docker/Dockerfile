# Use ubuntu as base image
FROM ubuntu:latest

# avoid iteractives prompts during instalation
ENV DEBIAN_FRONTEND=noninteractive

# update repository and install system dependencies 
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    git \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Create a symlink to make python3 accessible as python
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Create app directory
WORKDIR /opt/app

# Clone repository
RUN git clone https://github.com/CodeSSRockMan/DevOps_MedicalAppointmentsAPI.git /opt/app

# Install Python dependencies 
RUN python -m venv /opt/app/.venv && \
    . /opt/app/.venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r /opt/app/requirements.txt && \
    pip install --upgrade flask werkzeug

# Copy the script to start the app 
COPY start.sh /opt/app/start.sh
RUN chmod +x /opt/app/start.sh

# Expose the port used
EXPOSE 5000

# Command to start the app
CMD ["/opt/app/start.sh"]