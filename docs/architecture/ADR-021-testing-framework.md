# ADR-021 — Three-Layer Testing Framework

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-04-24 |
| **Tickets** | C8-50 (spec), C8-56 (architect review) |
| **Supersedes** | — |
| **Superseded by** | — |

---

## Context

The do.place platform requires a structured approach to automated testing that:

1. Allows non-engineers to express test scenarios in human-readable form
2. Provides a machine-executable layer that validates running services
3. Enables strategic reuse detection — knowing which scenarios already cover a given
   service path before writing new tests
4. Remains tenant-agnostic so the same scenario can be executed against any tenant realm

Prior to Cycle 8 there was no formal test infrastructure. Manual demo scripts (the "Pedro demo"
walkthrough) existed but were not automated.

---

## Decision

Adopt a **three-layer testing framework**:

```
Layer 1 – Langfuse Prompt Templates
            ↓  generates
Layer 2 – BDD Feature Files  (koernster/paams-tests)
            ↓  indexed by
Layer 3 – Apache AGE Reuse Index  (paams_test_registry graph)
```

### Layer 1 — Langfuse Prompt Templates

**Tool:** Langfuse (self-hosted on doplace-platform, port 3000)

**Purpose:** Versioned, parameterised prompt templates that generate BDD feature file stubs
given a vertical name, service under test, and scenario intent. Decouples the "what to test"
intent (a product/business concern) from the implementation of the feature file.

**Rationale:**
- Langfuse already runs on the orchestrator host (C8-51 scaffolded templates)
- Prompt versioning gives traceability between product intent and test artefact
- LLM-assisted stub generation speeds up scenario authoring for new verticals

### Layer 2 — BDD Feature Files

**Tool:** Cucumber-JS + TypeScript (`@cucumber/cucumber ^11`)  
**Repo:** `koernster/paams-tests`  
**Runner:** `npm test` → `cucumber-js features/**/*.feature`

**Purpose:** Human-readable Gherkin scenarios that describe the expected behaviour of
PAAMS services from the outside. Each scenario is an executable specification.

**Rationale:**
- Gherkin is readable by product owners and QA without programming knowledge
- Cucumber-JS integrates with the existing TypeScript toolchain
- Feature files are the stable artefact that the AGE index points to

**Tenant-agnostic execution pattern:** Scenario step definitions read connection parameters
from environment variables (`KEYCLOAK_URL`, `MTCM_URL`, `TEST_REALM`) so the same
`.feature` file runs against any tenant realm without modification.

### Layer 3 — Apache AGE Reuse Index

**Tool:** Apache AGE (PostgreSQL graph extension), `apache/age:latest` Docker container  
**Container:** `age-paams-tests` on doplace-platform, port 127.0.0.1:5454  
**Graph:** `paams_test_registry`

**Purpose:** A property graph that records every registered BDD scenario as a node, with
edges to the Feature file it belongs to. Before authoring a new scenario the graph is queried
to detect existing coverage and avoid duplication.

**Node labels:**
- `Scenario` — id, name, featureFile, testType, scenarioType, vertical, ticket, status, createdAt
- `Feature` — path, name, vertical

**Edge labels:**
- `BELONGS_TO` — (Scenario)→(Feature)

**Rationale:**
- A graph structure naturally models the many-to-many relationships between scenarios,
  features, verticals, and services
- Apache AGE runs inside PostgreSQL, keeping the infrastructure footprint small
- Cypher queries make coverage-gap detection simple to express

---

## Consequences

### Positive
- Product owners can review test coverage at the Gherkin layer without reading code
- New verticals can be scaffolded quickly via Langfuse prompt templates
- The AGE reuse index prevents duplicate test authoring effort across sprints
- Tenant-agnostic step definitions reduce per-environment maintenance cost

### Negative / Trade-offs
- Three moving parts require three infrastructure components to be healthy for CI to run
- Apache AGE is a relatively niche extension; operational knowledge needs to be built
- Prompt-to-feature generation quality depends on LLM and prompt maintenance

### Neutral
- Step definition quality and false-negative risk remains a function of authoring discipline
- The index is only as useful as the discipline of registering new scenarios after authoring

---

## Implementation Notes

| Ticket | Deliverable |
|--------|-------------|
| C8-50  | This ADR body |
| C8-51  | Langfuse prompt templates scaffolded |
| C8-52  | `koernster/paams-tests` repo created |
| C8-53  | Canonical BDD feature file (`mtcm-private-debt.feature`) |
| C8-54  | Apache AGE container + `paams_test_registry` graph + first node |
| C8-55  | Playwright E2E baseline (`npm run test:e2e`) |
| C8-56  | This architect review sign-off |
