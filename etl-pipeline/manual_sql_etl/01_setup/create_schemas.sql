-- ============================================
-- JOBPREP ETL PIPELINE - SCHEMA SETUP
-- Author: Ganesh Gadicherla
-- ============================================

USE DATABASE JOBPREP_DB;
USE WAREHOUSE COMPUTE_WH;

CREATE SCHEMA IF NOT EXISTS STAGING
  COMMENT = 'Staging layer - cleaned and transformed data';

CREATE SCHEMA IF NOT EXISTS ANALYTICS
  COMMENT = 'Analytics layer - aggregated data for AI agents';

SHOW SCHEMAS IN DATABASE JOBPREP_DB;
