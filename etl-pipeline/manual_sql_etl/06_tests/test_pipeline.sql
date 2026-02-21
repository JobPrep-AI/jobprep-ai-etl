-- ============================================
-- ETL PIPELINE TEST SUITE
-- Author: Ganesh Gadicherla
-- ============================================

USE DATABASE JOBPREP_DB;
USE WAREHOUSE COMPUTE_WH;

-- TEST 1: Data flow integrity
SELECT 
    'RAW_DATA' AS layer, COUNT(*) AS records
FROM RAW_DATA.INTERVIEW_QUESTIONS
UNION ALL
SELECT 'STAGING', COUNT(*) FROM STAGING.STAGING_INTERVIEW_QUESTIONS
UNION ALL
SELECT 'ANALYTICS', SUM(total_questions) FROM ANALYTICS.ANALYTICS_QUESTION_BY_CATEGORY;

-- TEST 2: No duplicates
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT question_id) AS unique_records,
    CASE WHEN COUNT(*) = COUNT(DISTINCT question_id) 
         THEN '✅ PASS - No duplicates' 
         ELSE '❌ FAIL - Duplicates found' 
    END AS status
FROM STAGING.STAGING_INTERVIEW_QUESTIONS;

-- TEST 3: Categorization coverage
SELECT 
    question_category_enhanced,
    COUNT(*) AS count
FROM STAGING.STAGING_INTERVIEW_QUESTIONS
GROUP BY question_category_enhanced
ORDER BY count DESC;

-- TEST 4: Analytics accuracy
SELECT 
    (SELECT COUNT(*) FROM STAGING.STAGING_INTERVIEW_QUESTIONS) AS staging_count,
    (SELECT SUM(total_questions) FROM ANALYTICS.ANALYTICS_QUESTION_BY_CATEGORY) AS analytics_sum,
    CASE WHEN staging_count = analytics_sum 
         THEN '✅ PASS - Counts match' 
         ELSE '❌ FAIL - Mismatch' 
    END AS status;
