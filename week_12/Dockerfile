FROM docker.io/library/python:3.13-slim

# Install system utilities for student debugging
RUN apt-get update && apt-get install -y \
    supervisor \
    curl \
    dnsutils \
    iputils-ping \
    nano \
    vim \
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip install --no-cache-dir flask requests

COPY app.py .
COPY init_dns.sh .
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /app/init_dns.sh

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
