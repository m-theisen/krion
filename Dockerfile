FROM docker.io/library/ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system utilities, editor, and web stack
RUN apt-get update && apt-get install -y \
    supervisor \
    nginx \
    python3 \
    net-tools \
    procps \
    lsof \
    curl \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Setup Python application
RUN useradd -m -s /bin/bash appuser
WORKDIR /opt/app
COPY app.py /opt/app/app.py

# Setup configuration file (BUG 2: Restrictive permissions)
RUN mkdir -p /etc/app
COPY app.conf /etc/app/app.conf
RUN chown root:root /etc/app/app.conf && chmod 600 /etc/app/app.conf

# Setup Nginx configuration (BUG 1: Wrong proxy port)
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/sites-enabled/default

# Setup Supervisor process manager
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
