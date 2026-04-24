# Step Definitions

BDD step implementations live here. Each `.js` (or `.ts`) file maps Gherkin steps to executable code.

Steps interact with three layers:
1. **Langfuse** — fetch prompt templates by name/version
2. **Feature files** — drive scenario execution
3. **Apache AGE** — query/assert against the reuse index graph
