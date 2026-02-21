-- ============================================
-- ETL TRANSFORMATION - RAW TO STAGING
-- Author: Ganesh Gadicherla
-- Description: Cleans, categorizes, and enriches interview questions
-- ============================================

USE DATABASE JOBPREP_DB;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA STAGING;

TRUNCATE TABLE STAGING_INTERVIEW_QUESTIONS;

INSERT INTO STAGING_INTERVIEW_QUESTIONS (
    question_id, company_name, role_name, interview_question, 
    difficulty_level, question_category, question_category_enhanced,
    skills_mentioned, question_length, word_count, 
    is_behavioral, is_technical, complexity_score, source, date_collected
)
SELECT 
    ID AS question_id,
    TRIM(UPPER(COMPANY_NAME)) AS company_name,
    TRIM(ROLE_NAME) AS role_name,
    TRIM(INTERVIEW_QUESTION) AS interview_question,
    COALESCE(TRIM(DIFFICULTY), 'Medium') AS difficulty_level,
    NULL AS question_category,
    
    CASE 
        WHEN LOWER(INTERVIEW_QUESTION) LIKE '%array%' OR LOWER(INTERVIEW_QUESTION) LIKE '%subarray%' 
        THEN 'Technical - Arrays'
        WHEN LOWER(INTERVIEW_QUESTION) LIKE '%string%' OR LOWER(INTERVIEW_QUESTION) LIKE '%anagram%' 
        THEN 'Technical - Strings'
        WHEN LOWER(INTERVIEW_QUESTION) LIKE '%tree%' OR LOWER(INTERVIEW_QUESTION) LIKE '%bst%' 
        THEN 'Technical - Trees & Graphs'
        WHEN LOWER(INTERVIEW_QUESTION) LIKE '%sort%' OR LOWER(INTERVIEW_QUESTION) LIKE '%search%' 
        THEN 'Technical - Sorting & Searching'
        WHEN LOWER(INTERVIEW_QUESTION) LIKE '%longest%' OR LOWER(INTERVIEW_QUESTION) LIKE '%subsequence%' 
        THEN 'Technical - Dynamic Programming'
        WHEN LOWER(INTERVIEW_QUESTION) LIKE '%count%' OR LOWER(INTERVIEW_QUESTION) LIKE '%calculate%' 
        THEN 'Technical - Math & Logic'
        ELSE 'Technical - Coding Challenge'
    END AS question_category_enhanced,
    
    ARRAY_CONSTRUCT_COMPACT(
        CASE WHEN LOWER(INTERVIEW_QUESTION) LIKE '%array%' THEN 'Arrays' END,
        CASE WHEN LOWER(INTERVIEW_QUESTION) LIKE '%string%' THEN 'Strings' END,
        CASE WHEN LOWER(INTERVIEW_QUESTION) LIKE '%tree%' THEN 'Trees' END,
        CASE WHEN LOWER(INTERVIEW_QUESTION) LIKE '%python%' THEN 'Python' END
    ) AS skills_mentioned,
    
    LENGTH(INTERVIEW_QUESTION) AS question_length,
    ARRAY_SIZE(SPLIT(INTERVIEW_QUESTION, ' ')) AS word_count,
    FALSE AS is_behavioral,
    TRUE AS is_technical,
    0.5 AS complexity_score,
    COALESCE(SOURCE, 'Unknown') AS source,
    DATE_COLLECTED
    
FROM RAW_DATA.INTERVIEW_QUESTIONS
WHERE INTERVIEW_QUESTION IS NOT NULL
  AND LENGTH(TRIM(INTERVIEW_QUESTION)) > 10;

SELECT COUNT(*) AS total_transformed FROM STAGING_INTERVIEW_QUESTIONS;
