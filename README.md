# paams-tests

BDD test suite for **PAAMS** (Policy-Aware Asset Management System).

## Three-Layer Architecture

```
Langfuse Prompt Templates
        │
        ▼
BDD Feature Files  (features/*.feature)
        │
        ▼
Apache AGE Reuse Index  (step_definitions/)
```

### Layer 1 — Langfuse Prompt Templates

Prompt templates are versioned and managed in [Langfuse](https://langfuse.com). Each template defines the expected inputs and outputs for a PAAMS evaluation scenario. Step definitions fetch the active template by name/version at test time, so tests always run against the canonical prompt without hard-coding it.

### Layer 2 — BDD Feature Files

Human-readable Gherkin scenarios in `features/` describe acceptance criteria for each PAAMS capability. Scenarios are data-driven: test data and tokens live in `fixtures/` and are injected by step definitions, keeping feature files free of environment-specific values.

### Layer 3 — Apache AGE Reuse Index

Step definitions in `step_definitions/` query the Apache AGE property graph that backs the PAAMS reuse index. Assertions verify that graph traversals return the correct entities, relationships, and metadata for each scenario.

## Repository Structure

```
features/           # Gherkin .feature files
fixtures/           # Test data, token stubs, seed files
step_definitions/   # Step implementation code
.github/workflows/  # CI pipeline (lint; tests coming soon)
```

## Running

```bash
npm run lint        # Linting only (tests not yet wired)
```

## CI

GitHub Actions runs `npm run lint` on every push and pull request. Full test execution will be added in a follow-up once the step definitions are implemented.
