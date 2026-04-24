-- =============================================================================
-- PAAMS Test Registry — Apache AGE graph setup
-- C8-54: Apache AGE reuse index: schema + first node
--
-- Run against the age-paams-tests Docker container:
--   docker exec age-paams-tests psql -U age -d paams_tests -f /tmp/setup_age.sql
--
-- Container: age-paams-tests (apache/age:latest)
-- Host:      doplace-platform (Hetzner), port 127.0.0.1:5454
-- =============================================================================

-- Load the AGE extension (idempotent)
CREATE EXTENSION IF NOT EXISTS age;
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- Create the test registry graph (idempotent via DO block)
DO $$
BEGIN
  PERFORM create_graph('paams_test_registry');
EXCEPTION WHEN OTHERS THEN
  -- graph already exists — skip
  NULL;
END;
$$;

-- ── Node label: Scenario ────────────────────────────────────────────────────
-- Properties:
--   id           TEXT  unique identifier (ticket + seq, e.g. 'C8-53-001')
--   name         TEXT  scenario title from the .feature file
--   featureFile  TEXT  relative path within paams-tests repo
--   testType     TEXT  'BDD' | 'E2E' | 'unit'
--   scenarioType TEXT  'functional' | 'regression' | 'smoke'
--   vertical     TEXT  product vertical (e.g. 'mtcm-private-debt')
--   ticket       TEXT  originating Cycle ticket
--   status       TEXT  'scaffolded' | 'active' | 'flaky' | 'retired'
--   createdAt    TEXT  ISO-8601 date
-- ── Node label: Feature ─────────────────────────────────────────────────────
-- Properties:
--   path         TEXT  relative path to .feature file
--   name         TEXT  feature title
--   vertical     TEXT  product vertical
-- ── Edge label: BELONGS_TO ──────────────────────────────────────────────────
--   (Scenario)-[:BELONGS_TO]->(Feature)
