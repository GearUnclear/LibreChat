# Model Grouping Implementation Issues

## Date: 2025-07-14

## Problem Statement
Need to organize models in LibreChat by developer/provider groups (OpenAI, Anthropic, Google, etc.) while maintaining all requests through OpenRouter. The original configuration had a flat list of models with rich descriptions and pricing information.

## Original Configuration (Working)
- Used `modelSpecs` with detailed model information
- Each model had:
  - Clean labels (e.g., "GPT-4o", "Claude 4 Sonnet")
  - Pricing indicators ($, $$, $$$, etc.)
  - Detailed descriptions of capabilities
  - Custom settings (temperature, max tokens, etc.)
  - Special features (Pi's greeting, prompt prefixes)

## Goals (ALL Required)
1. **Group models by developer** - Create expandable categories (OpenAI, Anthropic, Google, etc.)
2. **Preserve model descriptions** - Keep pricing indicators ($, $$, $$$) and capability descriptions
3. **Maintain clean labels** - Show "GPT-4o" not "openai/gpt-4o"
4. **Route through OpenRouter** - All requests must go through OpenRouter API
5. **No code changes** - Solution must be configuration-only to avoid merge conflicts

## Attempt 1: Custom Endpoints for Grouping ❌ FAILED TO MEET ALL GOALS

### Implementation
Created multiple custom endpoints, each representing a developer group:
```yaml
endpoints:
  custom:
    - name: "OpenAI Models"
      apiKey: "${OPENROUTER_KEY}"
      baseURL: "https://openrouter.ai/api/v1"
      iconURL: "openAI"
      models:
        default: ["openai/gpt-4o", "openai/o3"]
      # ... etc for each group
```

### Goals Achieved vs Failed
- ✅ Goal 1: Group models by developer - YES, created expandable groups
- ❌ Goal 2: Preserve model descriptions - NO, lost ALL descriptions and pricing
- ❌ Goal 3: Maintain clean labels - NO, shows raw API names "openai/gpt-4o"
- ✅ Goal 4: Route through OpenRouter - YES, maintained
- ✅ Goal 5: No code changes - YES, configuration only

### Critical Failures
- **"AGENTS" appeared as top model option** - Unexpected, not in our configuration
- **No descriptions field** in custom endpoint models
- **No label customization** - always shows raw model ID
- **No pricing indicators** - users can't see cost differences
- **No capability descriptions** - users don't know what each model is for

## Attempt 2: Hybrid Approach (ModelSpecs + Custom Endpoints) ❌ COMPLETE FAILURE

### Implementation
Tried to use both systems together:
```yaml
interface:
  modelSelect: true

modelSpecs:
  enforce: false  # Changed from true
  prioritize: true
  addedEndpoints:
    - "OpenAI Models"
    - "Anthropic Models"
    - "Google Models"
    - "Open Source Models"
    - "Other Models"
  list:
    # All original model specs with descriptions
```

### Goals Achieved vs Failed
- ❓ Goal 1: Group models by developer - UNKNOWN, UI broke
- ❓ Goal 2: Preserve model descriptions - UNKNOWN, couldn't test properly
- ❓ Goal 3: Maintain clean labels - UNKNOWN, UI malfunction
- ✅ Goal 4: Route through OpenRouter - YES in theory
- ✅ Goal 5: No code changes - YES, configuration only

### Critical Failures
- **UI didn't work as expected** - Model selector didn't properly merge the two systems
- **addedEndpoints misunderstanding** - Feature designed for standard endpoints (openAI, google, etc.), NOT custom endpoints
- **Incompatible systems** - modelSpecs and custom endpoints don't integrate well

## Technical Limitations Discovered

1. **Custom Endpoints Limitations**
   - Cannot add descriptions to individual models
   - Cannot customize display names (always shows raw model ID)
   - No support for pricing indicators
   - No per-model metadata

2. **ModelSpecs Limitations**
   - No built-in grouping/categorization feature
   - `addedEndpoints` doesn't work with custom endpoints as expected
   - Setting `enforce: false` creates unexpected UI behavior

3. **UI Constraints**
   - The model selector is designed for either modelSpecs OR endpoints, not both
   - No native support for hierarchical model organization

## Current State
**REVERTED TO ORIGINAL** - No grouping, but all descriptions preserved.

## Summary of Failures

### What We Wanted (All 5 Goals)
1. Models grouped by developer (OpenAI, Anthropic, etc.)
2. Keep descriptions and pricing ($, $$, $$$)
3. Clean model names ("GPT-4o" not "openai/gpt-4o")
4. Route everything through OpenRouter
5. Configuration-only solution

### What We Got
- **Attempt 1**: Grouping worked BUT lost all descriptions, pricing, and clean names (2/5 goals)
- **Attempt 2**: Complete failure, UI broke, "AGENTS" appeared mysteriously (0/5 goals testable)

### What We Lost When Using Grouping
1. **Descriptive Labels**: "GPT-4o" → "openai/gpt-4o"
2. **Pricing Info**: "$$ - OpenAI's flagship model..." → (none)
3. **Capabilities Descriptions**: Detailed explanations → (none)
4. **Special Features**: Pi's greeting, custom prompts → (none)
5. **User Guidance**: Which model to use for what → (none)

## Ideal Solution (Would Require Code Changes)
Add a `group` field to modelSpecs:
```yaml
modelSpecs:
  list:
    - name: "gpt-4o-clean"
      label: "GPT-4o"
      group: "OpenAI Models"  # NEW FIELD
      description: "$$ - OpenAI's flagship model..."
```

## Conclusion

**BOTH ATTEMPTS FAILED** to achieve all required goals simultaneously.

LibreChat's configuration system forces an impossible choice:
- **EITHER** have model grouping (lose descriptions, pricing, clean names)
- **OR** have rich model information (lose grouping)

The system is fundamentally unable to support both organizational hierarchy AND descriptive metadata through configuration alone. This is a significant limitation that degrades user experience no matter which approach is chosen.

### Final Decision
Reverted to original configuration (no grouping) because:
- Descriptions and pricing are MORE important than grouping
- Users need to know what models cost and what they're good for
- Clean model names are essential for usability
- A flat list with good descriptions > grouped list with no context