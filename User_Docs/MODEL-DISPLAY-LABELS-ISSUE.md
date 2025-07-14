# Model Display Labels Issue - LibreChat Limitations

## Issue Summary
**Date**: 2025-07-14  
**Problem**: LibreChat selectively displays proper model names in the chat interface, showing correct names for some models but generic labels for others.

## Root Cause
LibreChat appears to have **built-in recognition** for certain AI providers, allowing it to extract and display proper names from model identifiers. For unrecognized providers, it falls back to generic labels like "AI" or "OpenRouter".

## Observed Behavior

### Models That Show Proper Names ✅
| Model | Provider | Model ID | Display Name |
|-------|----------|----------|--------------|
| GPT-4o | OpenAI | `openai/gpt-4o` | "GPT-4o" |
| GPT o3 | OpenAI | `openai/o3` | "GPT o3" |
| Mistral Small | Mistral | `mistralai/mistral-small-3.2-24b-instruct-2506` | "Mistral Small" |

### Models That Show Generic Names ❌
| Model | Provider | Model ID | Display Name |
|-------|----------|----------|--------------|
| Claude 4 Sonnet | Anthropic | `anthropic/claude-sonnet-4` | "AI" or "OpenRouter" |
| Llama 3 70B | Meta | `meta-llama/llama-3.3-70b-instruct` | "AI" or "OpenRouter" |
| Inflection 3 Pi | Inflection | `inflection/inflection-3-pi` | "AI" or "OpenRouter" |
| Gemini 2.5 Pro | Google | `google/gemini-2.5-pro` | "AI" or "OpenRouter" |
| Kimi K2 | Moonshot | `moonshotai/kimi-k2` | "AI" or "OpenRouter" |

## Analysis

### Provider Recognition Pattern
LibreChat appears to have hardcoded recognition for:
- **OpenAI models** (`openai/` prefix)
- **Mistral models** (`mistralai/` prefix)

For other providers like Anthropic, Google, Meta, Inflection, and Moonshot, LibreChat doesn't recognize the model identifiers and falls back to generic labels.

### Configuration Attempts Made
1. **Individual model `modelDisplayLabel`**: Added to each model spec
2. **Endpoint-level `modelDisplayLabel`**: Set to "OpenRouter" (shows for all models)
3. **Template `modelDisplayLabel`**: Used `"{{model}}"` (inconsistent results)
4. **Removed `modelDisplayLabel`**: Let LibreChat use default behavior

## LibreChat Documentation Findings
Based on official LibreChat documentation:
- `modelDisplayLabel` is designed to work at the **endpoint level**, not individual model level
- All models using the same endpoint will show the same display label
- Individual model display labels are not officially supported in modelSpecs

## Current Workaround
**None available**. This appears to be a LibreChat limitation where:
1. The model selection dropdown shows proper names from `label` field in modelSpecs
2. The chat interface inconsistently displays model names based on provider recognition
3. Users must rely on the model selector to know which model they're using

## Impact
- **User Experience**: Harder to identify which model is responding in chat
- **Testing**: Difficult to distinguish between model variants (e.g., Pi temperature tests)
- **Documentation**: Must explain this limitation to users

## Recommendations
1. **Accept limitation**: Document this as a known issue
2. **Future monitoring**: Check if newer LibreChat versions improve this
3. **Alternative identification**: Use conversation context or model selector to identify models
4. **Feedback to LibreChat**: Consider reporting this as a feature request

## Files Modified
- `/opt/LibreChat/librechat.yaml` - Attempted various `modelDisplayLabel` configurations
- Applied multiple restarts to test different approaches

## References
- [LibreChat modelDisplayLabel documentation](https://www.librechat.ai/docs/configuration/librechat_yaml/example)
- [OpenRouter example config](https://www.librechat.ai/docs/configuration/librechat_yaml/ai_endpoints/openrouter)
- [TOKEN-LIMITS-ISSUE.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/TOKEN-LIMITS-ISSUE.md) - Related configuration issue

---
*This document was created after extensive testing of model display label configurations in LibreChat.*