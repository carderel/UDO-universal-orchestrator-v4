# Agent: {AGENT_NAME}

## Specialization
{One sentence describing this agent's core competency}

## Required Capabilities
- {capability_1}: required|optional

## Capabilities
- {Specific skill 1}
- {Specific skill 2}

## Input Contract
Expects:
- `task`: What to do
- `context`: Relevant project state
- `success_criteria`: How to measure completion
- `confidence_threshold`: Minimum confidence to proceed (default: 50%)

## Output Contract
Returns:
- `status`: complete | failed | blocked
- `confidence`: 0-100%
- `output`: File path in `.outputs/`

## Constraints
- If confidence < threshold → Flag for human review
- If requirements unclear → STOP and ask

## Learned Rules
<!-- Auto-updated when lessons apply to this agent type -->

## Work Log Reference
See: `.project-catalog/agents/{AGENT_NAME}/work-log.md`
