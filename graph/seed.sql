-- =============================================================================
-- PAAMS Test Registry — seed data
-- Run AFTER setup_age.sql
-- =============================================================================

LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- ── Feature node: MTCM Private Debt ─────────────────────────────────────────
SELECT * FROM cypher('paams_test_registry', $$
  MERGE (f:Feature {path: 'features/mtcm-private-debt.feature'})
  ON CREATE SET
    f.name     = 'MTCM Private Debt deal lifecycle',
    f.vertical = 'mtcm-private-debt'
  RETURN f
$$) AS (f agtype);

-- ── Scenario node: canonical BDD scenario from C8-53 ────────────────────────
SELECT * FROM cypher('paams_test_registry', $$
  MERGE (s:Scenario {id: 'C8-53-001'})
  ON CREATE SET
    s.name         = 'Create a Private Debt deal in MTCM',
    s.featureFile  = 'features/mtcm-private-debt.feature',
    s.testType     = 'BDD',
    s.scenarioType = 'functional',
    s.vertical     = 'mtcm-private-debt',
    s.ticket       = 'C8-53',
    s.status       = 'scaffolded',
    s.createdAt    = '2026-04-24'
  RETURN s
$$) AS (s agtype);

-- ── Edge: Scenario BELONGS_TO Feature ───────────────────────────────────────
SELECT * FROM cypher('paams_test_registry', $$
  MATCH (s:Scenario {id: 'C8-53-001'}), (f:Feature {path: 'features/mtcm-private-debt.feature'})
  MERGE (s)-[:BELONGS_TO]->(f)
  RETURN s.id, f.path
$$) AS (scenario_id agtype, feature_path agtype);
