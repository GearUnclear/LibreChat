# LibreChat User Documentation Library

This directory contains user-focused documentation and configuration references for the GearUnclear/LibreChat deployment.

## 📋 Documentation Index

### Deployment & Operations
- **[DEPLOYMENT-README.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/DEPLOYMENT-README.md)** - Complete deployment guide with service management, user administration, and troubleshooting

### Configuration Files (2025-07-14)
- **[librechat_config_2025-07-14_080015.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/librechat_config_2025-07-14_080015.txt)** - Sanitized main configuration with 12 AI models and descriptions
- **[librechat_config_anonymized_2025-07-14_083135.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/librechat_config_anonymized_2025-07-14_083135.txt)** - Anonymized configuration with token limits fixed
- **[docker_override_config_2025-07-14_080015.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/docker_override_config_2025-07-14_080015.txt)** - Docker volume mount configuration
- **[env_config_2025-07-14_080015.txt](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/env_config_2025-07-14_080015.txt)** - Environment variables (API keys redacted)

### Implementation Issues & Lessons Learned
- **[ISSUES-MODEL-GROUPING.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/ISSUES-MODEL-GROUPING.md)** - Detailed analysis of failed attempts to group models by developer while preserving descriptions
- **[TOKEN-LIMITS-ISSUE.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/TOKEN-LIMITS-ISSUE.md)** - OpenRouter provider token limit constraints and fixes applied to all models
- **[MODEL-DISPLAY-LABELS-ISSUE.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/MODEL-DISPLAY-LABELS-ISSUE.md)** - LibreChat limitations with custom model naming in chat interface

### Guides & References  
- **[tempguide.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/tempguide.md)** - Temperature settings guide for AI models

## 🔧 Current Configuration Status

### Model Organization
- **Approach**: Flat list with rich descriptions (modelSpecs)
- **Total Models**: 14 AI models with pricing indicators (includes CYOA variants)
- **Routing**: All requests through OpenRouter
- **Grouping**: ❌ Not implemented (see ISSUES-MODEL-GROUPING.md)
- **Token Limits**: ✅ Fixed for all models (see TOKEN-LIMITS-ISSUE.md)

### Key Features
- Detailed model descriptions with cost indicators ($, $$, $$$)
- Custom temperature settings per model
- Special configurations (Pi's empathetic AI, CYOA game prompts)
- Clean model names for user-friendly selection
- Proper token limits respecting OpenRouter provider constraints
- External prompt file experiments (reverted to inline prompts)

## 🚨 Important Notes

### Security
- Configuration files in this directory have API keys and secrets **REDACTED**
- Original configuration files contain sensitive information
- Never commit unredacted configuration files to version control

### Configuration Limitations
- **Model Grouping**: Cannot group by developer while preserving descriptions and clean names. See [ISSUES-MODEL-GROUPING.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/ISSUES-MODEL-GROUPING.md) for full analysis.
- **External Prompt Files**: Unreliable loading led to reverting to inline prompts in YAML configuration.
- **Token Limits**: Required fixing all models to respect OpenRouter provider constraints. See [TOKEN-LIMITS-ISSUE.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/TOKEN-LIMITS-ISSUE.md).
- **Model Display Labels**: LibreChat only shows proper model names for recognized providers (OpenAI, Mistral), others show generic labels. See [MODEL-DISPLAY-LABELS-ISSUE.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/MODEL-DISPLAY-LABELS-ISSUE.md).

## 📚 Additional Resources

- [LibreChat Official Documentation](https://docs.librechat.ai/)
- [OpenRouter API Documentation](https://openrouter.ai/docs)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

**Repository**: [GearUnclear/LibreChat](https://github.com/GearUnclear/LibreChat)  
**Last Updated**: 2025-07-14