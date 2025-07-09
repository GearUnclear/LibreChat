# LibreChat Deployment Guide

## Overview
This LibreChat deployment is configured for production use with OpenRouter API integration and runs on Docker containers. This document provides essential information for maintaining and troubleshooting the deployment.

## ⚠️ Critical Files (NOT in Git)
These files are ignored by `.gitignore` and must be preserved during deployments:

- **`librechat.yaml`** - Main configuration file with model specifications
- **`.env`** - Environment variables (API keys, database settings)
- **`docker-compose.override.yml`** - Docker volume mounts and overrides
- **`data-node/`** - MongoDB data directory
- **`meili_data_v1.12/`** - MeiliSearch index data
- **`logs/`** - Application logs

## 🚀 Service Management

### Starting the Service
```bash
# Full startup with configuration
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml up -d

# Quick startup (if override is default)
cd /opt/LibreChat && docker-compose up -d
```

### Stopping the Service
```bash
# Graceful shutdown
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml down

# Force stop if needed
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml down --remove-orphans
```

### Restarting the Service
```bash
# Quick container restart (LibreChat only)
docker restart LibreChat

# Full restart (recommended after config changes)
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml down
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml up -d
```

### Checking Service Status
```bash
# Container status
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml ps

# Application logs
docker logs LibreChat --tail 50

# Follow live logs
docker logs LibreChat -f
```

## 📋 Current Configuration

### Model Specifications
The deployment includes 6 pre-configured models via OpenRouter:

| Model | Context Tokens | Max Output | Temperature |
|-------|---------------|------------|-------------|
| GPT-4o | 128,000 | 4,096 | 0.7 |
| GPT-o3 | 128,000 | 4,096 | 0.7 |
| Claude 4 Sonnet | 200,000 | 64,000 | 0.7 |
| Claude 4 Opus | 200,000 | 32,000 | 0.7 |
| Mistral Small | 128,000 | 4,096 | 0.7 |
| Llama 3 70B | 128,000 | 4,096 | 0.7 |

### Key Configuration Settings
- **User token limits**: DISABLED (`balance.enabled: false`)
- **Model enforcement**: ENABLED (`modelSpecs.enforce: true`)
- **Model prioritization**: ENABLED (`modelSpecs.prioritize: true`)
- **Cache**: ENABLED (`cache: true`)

## 🔧 Configuration Management

### Modifying Models
1. Edit `/opt/LibreChat/librechat.yaml`
2. Update model specifications under `modelSpecs.list`
3. Restart the service (see commands above)

### Adding New Models
Add to the `modelSpecs.list` section:
```yaml
- name: "new-model-clean"
  label: "New Model ($)"
  preset:
    endpoint: "OpenRouter"
    model: "provider/model-name"
    maxContextTokens: 128000
    max_tokens: 4096
    temperature: 0.7
```

### Enabling User Token Limits
1. Edit `/opt/LibreChat/librechat.yaml`
2. Change `balance.enabled: false` to `balance.enabled: true`
3. Add balance configuration:
```yaml
balance:
  enabled: true
  startBalance: 50000
  autoRefillEnabled: false
  refillIntervalValue: 30
  refillIntervalUnit: "days"
  refillAmount: 25000
```
4. Restart the service

## 👥 User Management

### Listing Users
```bash
# List all users in the system
docker exec LibreChat npm run list-users

# View user statistics (conversations, messages)
docker exec LibreChat npm run user-stats
```

### User Administration Commands
```bash
# Create a new user
docker exec LibreChat npm run create-user

# Reset a user's password
docker exec LibreChat npm run reset-password

# Ban a user
docker exec LibreChat npm run ban-user

# Delete a user
docker exec LibreChat npm run delete-user

# Invite a user (if registration is disabled)
docker exec LibreChat npm run invite-user
```

### User Balance Management (if enabled)
```bash
# Add balance to a user
docker exec LibreChat npm run add-balance

# Set user balance
docker exec LibreChat npm run set-balance

# List all user balances
docker exec LibreChat npm run list-balances
```

**Important**: All user management commands must be run inside the Docker container using `docker exec LibreChat` because the database connection and dependencies are only available within the container environment.

## 🗂️ File Locations

### Configuration Files
- **Main config**: `/opt/LibreChat/librechat.yaml`
- **Environment**: `/opt/LibreChat/.env`
- **Docker override**: `/opt/LibreChat/docker-compose.override.yml`
- **Docker compose**: `/opt/LibreChat/docker-compose.yml`

### Data Directories
- **MongoDB**: `/opt/LibreChat/data-node/`
- **MeiliSearch**: `/opt/LibreChat/meili_data_v1.12/`
- **Logs**: `/opt/LibreChat/logs/`
- **User uploads**: `/opt/LibreChat/uploads/` (if enabled)

### Container Names
- **LibreChat**: `LibreChat`
- **MongoDB**: `chat-mongodb`
- **MeiliSearch**: `chat-meilisearch`
- **Vector DB**: `vectordb`
- **RAG API**: `rag_api`

## 🩺 Troubleshooting

### Common Issues

#### 1. Configuration Not Loading
**Symptom**: Logs show "ENOENT: no such file or directory, open '/app/librechat.yaml'"
**Solution**: Ensure docker-compose.override.yml is included in the startup command

#### 2. Model Not Available
**Symptom**: Model not showing in UI
**Solution**: Check `modelSpecs.enforce: true` and verify model is in the list

#### 3. Context Length Errors
**Symptom**: "Maximum context length exceeded"
**Solution**: Verify `maxContextTokens` is set correctly for the model

#### 4. Container Won't Start
**Symptom**: Container exits immediately
**Solution**: Check logs with `docker logs LibreChat` and verify environment variables

#### 5. User Management Commands Fail
**Symptom**: "Cannot find module" errors when running user commands from host
**Solution**: Always run user management commands inside the container:
```bash
# Wrong - from host
npm run list-users

# Correct - inside container
docker exec LibreChat npm run list-users
```

#### 6. Create User Command Hangs
**Symptom**: User creation prompt waits for input indefinitely
**Solution**: Use non-interactive mode with piped input:
```bash
# If command hangs waiting for email verification prompt
docker exec -i LibreChat sh -c "echo 'y' | npm run create-user email@example.com 'Name' 'username' 'password'"
```

### Log Analysis
```bash
# Check startup logs
docker logs LibreChat --tail 20

# Look for configuration loading
docker logs LibreChat | grep "Custom config file loaded"

# Check for errors
docker logs LibreChat | grep -i error

# Monitor live logs
docker logs LibreChat -f
```

### Health Checks
```bash
# Verify all containers are running
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml ps

# Check if LibreChat is responding
curl -f http://localhost:3080 || echo "Service not responding"

# Check MongoDB connection
docker exec chat-mongodb mongosh --eval "db.runCommand('ping')"
```

## 💾 Backup & Recovery

### Critical Backup Items
1. **Configuration files** (not in git):
   - `librechat.yaml`
   - `.env`
   - `docker-compose.override.yml`

2. **Database data**:
   - `data-node/` (MongoDB)
   - `meili_data_v1.12/` (MeiliSearch)

3. **User data**:
   - `uploads/` (if file uploads enabled)

### Backup Command
```bash
# Create backup directory
mkdir -p /opt/librechat-backup/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/librechat-backup/$(date +%Y%m%d_%H%M%S)"

# Backup configuration
cp /opt/LibreChat/librechat.yaml $BACKUP_DIR/
cp /opt/LibreChat/.env $BACKUP_DIR/
cp /opt/LibreChat/docker-compose.override.yml $BACKUP_DIR/

# Backup data (stop service first)
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml down
tar -czf $BACKUP_DIR/data-node.tar.gz -C /opt/LibreChat data-node/
tar -czf $BACKUP_DIR/meili_data.tar.gz -C /opt/LibreChat meili_data_v1.12/

# Restart service
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml up -d
```

## 🔑 Environment Variables

### Required Variables
Check `/opt/LibreChat/.env` for:
- `OPENROUTER_KEY` - OpenRouter API key
- `MONGO_URI` - MongoDB connection string
- `JWT_SECRET` - JWT token secret
- `CREDS_KEY` - Credential encryption key
- `CREDS_IV` - Credential encryption IV

### Optional Variables
- Search providers (Serper, Firecrawl, etc.)
- Authentication providers (Google, GitHub, etc.)
- File upload settings
- Rate limiting settings

## 🌐 Network & Access

### Default Ports
- **LibreChat**: 3080 (HTTP)
- **MongoDB**: 27017 (Internal)
- **MeiliSearch**: 7700 (Internal)
- **Vector DB**: 5432 (Internal)

### Production Access
- **URL**: https://ai.wagenhoffer.dev
- **Local**: http://localhost:3080 (if port forwarded)

## 📚 Additional Resources

- [LibreChat Documentation](https://www.librechat.ai/docs)
- [OpenRouter API Documentation](https://openrouter.ai/docs)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🔄 Version Information

- **LibreChat**: v0.7.8
- **Config Version**: 1.2.8
- **MongoDB**: Latest
- **MeiliSearch**: v1.12.3
- **Vector DB**: Latest (pgvector)

---

**Last Updated**: 2025-07-08
**Deployment Path**: `/opt/LibreChat/`