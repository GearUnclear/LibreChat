#!/bin/bash

# LibreChat Setup Script for Hetzner VPS
# This script sets up LibreChat with MongoDB, Meilisearch, and Nginx reverse proxy

set -e

echo "🚀 Setting up LibreChat on your VPS..."

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install Node.js 18.x (required for LibreChat)
echo "📦 Installing Node.js 18.x..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install MongoDB
echo "📦 Installing MongoDB..."
apt-get install -y gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
apt-get update
apt-get install -y mongodb-org

# Start and enable MongoDB
systemctl start mongod
systemctl enable mongod

# Install Meilisearch
echo "📦 Installing Meilisearch..."
curl -L https://install.meilisearch.com | sh
mv ./meilisearch /usr/local/bin/

# Create Meilisearch service
cat > /etc/systemd/system/meilisearch.service << 'EOF'
[Unit]
Description=Meilisearch
After=network.target

[Service]
Type=simple
User=meilisearch
Group=meilisearch
ExecStart=/usr/local/bin/meilisearch --http-addr 127.0.0.1:7700 --env production --master-key yNVdoteN0VEeS8Ri2gUl9x4S1MVDVEpw7f+Qf+vpP9k=
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Create meilisearch user
useradd -r -s /bin/false meilisearch || true

# Start and enable Meilisearch
systemctl daemon-reload
systemctl start meilisearch
systemctl enable meilisearch

# Install Nginx if not present
echo "📦 Installing Nginx..."
apt-get install -y nginx

# Install certbot for SSL
echo "📦 Installing Certbot for SSL..."
apt-get install -y certbot python3-certbot-nginx

# Create Nginx configuration for LibreChat
cat > /etc/nginx/sites-available/librechat << 'EOF'
server {
    listen 80;
    server_name ai.wagenhoffer.dev;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ai.wagenhoffer.dev;
    
    # SSL configuration will be added by certbot
    
    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Increase client max body size for file uploads
    client_max_body_size 50M;
    
    location / {
        proxy_pass http://127.0.0.1:3080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeout settings
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Handle WebSocket connections
    location /socket.io/ {
        proxy_pass http://127.0.0.1:3080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/librechat /etc/nginx/sites-enabled/
nginx -t

# Install LibreChat dependencies
echo "📦 Installing LibreChat dependencies..."
cd /opt/LibreChat
npm ci

# Create LibreChat systemd service
cat > /etc/systemd/system/librechat.service << 'EOF'
[Unit]
Description=LibreChat
After=network.target mongod.service meilisearch.service
Wants=mongod.service meilisearch.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/LibreChat
Environment=NODE_ENV=production
ExecStart=/usr/bin/npm start
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start services
systemctl daemon-reload
systemctl enable librechat

echo "🔧 Setting up SSL certificate..."
echo "Please run the following command to set up SSL:"
echo "sudo certbot --nginx -d ai.wagenhoffer.dev"
echo ""
echo "After SSL is set up, start LibreChat with:"
echo "sudo systemctl start librechat"
echo ""
echo "Check status with:"
echo "sudo systemctl status librechat"
echo "sudo systemctl status mongod"
echo "sudo systemctl status meilisearch"
echo ""
echo "View logs with:"
echo "sudo journalctl -u librechat -f"
echo ""
echo "🎉 Setup complete! Don't forget to:"
echo "1. Set up SSL with certbot"
echo "2. Configure your API keys in the env.txt file"
echo "3. Start the LibreChat service"
echo "4. Configure firewall rules if needed" 