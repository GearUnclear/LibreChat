# LibreChat Quick Reference for Claude

Essential day-to-day commands and information for managing this LibreChat deployment.

## 🚀 Service Management

### Restart Service (After Config Changes)
```bash
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml down
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml up -d
```

### Quick Container Restart
```bash
docker restart LibreChat
```

### Check Service Status
```bash
docker-compose -f /opt/LibreChat/docker-compose.yml -f /opt/LibreChat/docker-compose.override.yml ps
docker logs LibreChat --tail 20
```

## 📋 Configuration Files

### Critical Files (NOT in Git)
- **`librechat.yaml`** - Main model configuration
- **`.env`** - API keys and secrets  
- **`docker-compose.override.yml`** - Volume mounts
- **`prompts/`** - External prompt files

### Adding New Models
Edit `librechat.yaml` → `modelSpecs.list`:
```yaml
- name: "new-model-clean"
  label: "New Model"
  description: "$ - Description here"
  preset:
    endpoint: "OpenRouter"
    model: "provider/model-name"
    maxContextTokens: 131000
    max_tokens: 131000
    temperature: 0.4
```

### External Prompts
Store in `/opt/LibreChat/prompts/filename.txt` and reference:
```yaml
promptPrefix: "file:///opt/LibreChat/prompts/filename.txt"
```

## 👥 User Management

### Common Commands
```bash
# List users
docker exec LibreChat npm run list-users

# Create user
docker exec LibreChat npm run create-user

# Reset password
docker exec LibreChat npm run reset-password

# User statistics
docker exec LibreChat npm run user-stats
```

**Important**: ALL user commands must run with `docker exec LibreChat`

## 🔍 Troubleshooting

### Check Configuration Loading
```bash
docker logs LibreChat | grep "Custom config file loaded"
```

### Common Issues
- **Config not loading**: Include override file in commands
- **Model missing**: Check `modelSpecs.enforce: true` 
- **User commands fail**: Must run inside container with `docker exec`

### Health Check
```bash
# All services running
docker-compose ps

# LibreChat responding  
curl -f http://localhost:3080 || echo "Service down"
```

## 📁 Current Setup

### Site URL
https://ai.wagenhoffer.dev

### Container Names
- **LibreChat**: `LibreChat`
- **MongoDB**: `chat-mongodb` 
- **MeiliSearch**: `chat-meilisearch`

### Data Locations
- **Config**: `/opt/LibreChat/librechat.yaml`
- **Prompts**: `/opt/LibreChat/prompts/`
- **Database**: `/opt/LibreChat/data-node/`
- **Logs**: `/opt/LibreChat/logs/`

## 🔄 Git Management

### Current Setup
- **Fork**: `git@github.com:GearUnclear/LibreChat.git`
- **Upstream**: `https://github.com/danny-avila/LibreChat.git`

### User Documentation
- **Location**: `/opt/LibreChat/User_Docs/`
- **Files**: DEPLOYMENT-README.md, tempguide.md, ISSUES-MODEL-GROUPING.md

## ⚠️ Critical Reminders

1. **Always include override file** in docker-compose commands
2. **Config changes require full restart** (not just container restart)
3. **User commands must run inside container** 
4. **Critical files are NOT in git** - backup separately
5. **External prompts** keep YAML clean and manageable

---
*This is a Claude-generated quick reference. For full details see User_Docs/DEPLOYMENT-README.md*