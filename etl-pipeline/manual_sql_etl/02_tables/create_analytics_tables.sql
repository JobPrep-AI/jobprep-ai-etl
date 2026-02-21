-- ============================================
-- CREATE ANALYTICS TABLES
-- Author: Ganesh Gadicherla
-- ============================================

USE DATABASE JOBPREP_DB;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE TABLE ANALYTICS_QUESTION_BY_CATEGORY (
    category VARCHAR(255),
    difficulty_level VARCHAR(50),
    total_questions INT,
    avg_length FLOAT,
    avg_word_count FLOAT,
    avg_complexity FLOAT,
    behavioral_count INT,
    technical_count INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE ANALYTICS_COMPANY_INSIGHTS (
    company_name VARCHAR(255),
    total_questions INT,
    common_categories ARRAY,
    avg_question_complexity FLOAT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE ANALYTICS_SKILLS_DEMAND (
    skill_name VARCHAR(200),
    times_mentioned INT,
    companies_asking ARRAY,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

SHOW TABLES IN SCHEMA ANALYTICS;
