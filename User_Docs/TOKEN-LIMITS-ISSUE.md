# Token Limits Issue - OpenRouter Provider Constraints

## Issue Summary
**Date**: 2025-07-14  
**Problem**: LibreChat models were configured with token limits that exceeded OpenRouter provider constraints, causing "maximum context length exceeded" errors.

## Root Cause
OpenRouter providers have **combined token limits** (input + output tokens together), not separate limits for each. Our configurations were treating them as independent limits.

### Example Error
```
An error occurred while processing the request: 400 This endpoint's maximum context length is 131072 tokens. However, you requested about 132463 tokens (1463 of text input, 131000 in the output). Please reduce the length of either one.
```

## Models Affected
All models in our configuration had this issue:

| Model | Original Config | Issue | Fixed Config |
|-------|----------------|-------|-------------|
| GPT-4o | 128K context + 16K output = 144K total | Exceeded 128K limit | 112K context + 16K output = 128K total |
| GPT-o3 | 128K context + 16K output = 144K total | Exceeded 128K limit | 112K context + 16K output = 128K total |
| Claude 4 Sonnet | 200K context + 64K output = 264K total | Exceeded 200K limit | 136K context + 64K output = 200K total |
| Claude 4 Opus | 200K context + 32K output = 232K total | Exceeded 200K limit | 168K context + 32K output = 200K total |
| Gemini 2.5 Pro | 1M context + 66K output = 1.066M total | Exceeded 1M limit | 934K context + 66K output = 1M total |
| Gemini 2.5 Flash | 1M context + 64K output = 1.064M total | Exceeded 1M limit | 936K context + 64K output = 1M total |
| Kimi K2 | 131K context + 131K output = 262K total | Exceeded 131K limit | 95K context + 36K output = 131K total |
| Inflection 3 Pi | 128K context + 4K output = 132K total | Exceeded 8K limit | 7K context + 1K output = 8K total |

## Solution Applied
**Formula**: `actual_provider_limit - max_tokens = new_maxContextTokens`

This ensures the combined token usage never exceeds the OpenRouter provider's actual limits.

## Key Learnings

### 1. OpenRouter Provider Limits Are Combined
- Each provider has a **total token budget** shared between input and output
- This is different from model documentation which may show separate limits
- Always check OpenRouter's provider-specific limits, not just model specs

### 2. Model Configuration Requirements
- `maxContextTokens + max_tokens ≤ provider_limit`
- Leave small buffer for safety (we used exact limits)
- Different providers for the same model may have different limits

### 3. Error Symptoms
- "Maximum context length exceeded" errors
- Occurs during generation, not at request start
- More likely with long conversations or large prompts

## Prevention
1. **Always verify OpenRouter provider limits** before configuring models
2. **Use the formula** `provider_limit - desired_output = max_context`
3. **Test with long conversations** to verify limits work in practice
4. **Monitor for token limit errors** in logs after configuration changes

## Files Modified
- `/opt/LibreChat/librechat.yaml` - Updated all model token limits
- Applied full restart procedure to load new configuration

## References
- OpenRouter Kimi K2 documentation: https://openrouter.ai/models/moonshotai/kimi-k2
- LibreChat model configuration docs
- GitHub issue #3 in our fork documenting external prompt file experiments

## Related Issues
- **Model Display Labels**: See [MODEL-DISPLAY-LABELS-ISSUE.md](https://github.com/GearUnclear/LibreChat/blob/main/User_Docs/MODEL-DISPLAY-LABELS-ISSUE.md) for LibreChat limitations with custom model naming

---
*This document was created after resolving token limit issues that affected all models in our LibreChat deployment.*