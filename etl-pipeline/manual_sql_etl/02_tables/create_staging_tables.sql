-- ============================================
-- CREATE STAGING TABLES
-- Author: Ganesh Gadicherla
-- ============================================

USE DATABASE JOBPREP_DB;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA STAGING;

CREATE OR REPLACE TABLE STAGING_INTERVIEW_QUESTIONS (
    question_id NUMBER(38,0) PRIMARY KEY,
    company_name VARCHAR(255),
    role_name VARCHAR(255),
    interview_question TEXT,
    difficulty_level VARCHAR(50),
    question_category VARCHAR(255),
    question_category_enhanced VARCHAR(255),
    skills_mentioned ARRAY,
    question_length INT,
    word_count INT,
    is_behavioral BOOLEAN,
    is_technical BOOLEAN,
    complexity_score FLOAT,
    source VARCHAR(100),
    date_collected TIMESTAMP_NTZ,
    processed_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    processed_by VARCHAR(100) DEFAULT 'ETL_Pipeline'
);

DESCRIBE TABLE STAGING_INTERVIEW_QUESTIONS;
