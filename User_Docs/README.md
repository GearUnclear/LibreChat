# LibreChat User Documentation Library

This directory contains user-focused documentation and configuration references for the GearUnclear/LibreChat deployment.

## 📋 Documentation Index

### Deployment & Operations
- **[DEPLOYMENT-README.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/DEPLOYMENT-README.md)** - Complete deployment guide with service management, user administration, and troubleshooting

### Configuration Files (2025-07-14)
- **[librechat_config_2025-07-14_080015.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/librechat_config_2025-07-14_080015.txt)** - Sanitized main configuration with 12 AI models and descriptions
- **[docker_override_config_2025-07-14_080015.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/docker_override_config_2025-07-14_080015.txt)** - Docker volume mount configuration
- **[env_config_2025-07-14_080015.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/env_config_2025-07-14_080015.txt)** - Environment variables (API keys redacted)

### Implementation Issues & Lessons Learned
- **[ISSUES-MODEL-GROUPING.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/ISSUES-MODEL-GROUPING.md)** - Detailed analysis of failed attempts to group models by developer while preserving descriptions

### Guides & References  
- **[tempguide.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/tempguide.md)** - Temperature settings guide for AI models

## 🔧 Current Configuration Status

### Model Organization
- **Approach**: Flat list with rich descriptions (modelSpecs)
- **Total Models**: 12 AI models with pricing indicators
- **Routing**: All requests through OpenRouter
- **Grouping**: ❌ Not implemented (see ISSUES-MODEL-GROUPING.md)

### Key Features
- Detailed model descriptions with cost indicators ($, $$, $$$)
- Custom temperature settings per model
- Special configurations (Pi's empathetic AI, custom prompts)
- Clean model names for user-friendly selection

## 🚨 Important Notes

### Security
- Configuration files in this directory have API keys and secrets **REDACTED**
- Original configuration files contain sensitive information
- Never commit unredacted configuration files to version control

### Model Grouping Limitation
After extensive testing, LibreChat's configuration system cannot support model grouping by developer while preserving descriptions and clean names. See [ISSUES-MODEL-GROUPING.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/ISSUES-MODEL-GROUPING.md) for full analysis.

## 📚 Additional Resources

- [LibreChat Official Documentation](https://docs.librechat.ai/)
- [OpenRouter API Documentation](https://openrouter.ai/docs)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

**Repository**: [GearUnclear/LibreChat](https://github.com/GearUnclear/LibreChat)  
**Last Updated**: 2025-07-14