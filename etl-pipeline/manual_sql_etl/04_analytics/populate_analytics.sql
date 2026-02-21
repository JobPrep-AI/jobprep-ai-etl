-- ============================================
-- POPULATE ANALYTICS TABLES
-- Author: Ganesh Gadicherla
-- ============================================

USE DATABASE JOBPREP_DB;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA ANALYTICS;

TRUNCATE TABLE ANALYTICS_QUESTION_BY_CATEGORY;
TRUNCATE TABLE ANALYTICS_COMPANY_INSIGHTS;
TRUNCATE TABLE ANALYTICS_SKILLS_DEMAND;

INSERT INTO ANALYTICS_QUESTION_BY_CATEGORY
SELECT 
    question_category_enhanced AS category,
    difficulty_level,
    COUNT(*) AS total_questions,
    ROUND(AVG(question_length), 2) AS avg_length,
    ROUND(AVG(word_count), 2) AS avg_word_count,
    ROUND(AVG(complexity_score), 3) AS avg_complexity,
    0 AS behavioral_count,
    COUNT(*) AS technical_count,
    CURRENT_TIMESTAMP() AS last_updated
FROM STAGING.STAGING_INTERVIEW_QUESTIONS
GROUP BY question_category_enhanced, difficulty_level;

INSERT INTO ANALYTICS_COMPANY_INSIGHTS
SELECT 
    company_name,
    COUNT(*) AS total_questions,
    ARRAY_AGG(DISTINCT question_category_enhanced) AS common_categories,
    ROUND(AVG(complexity_score), 3) AS avg_question_complexity,
    CURRENT_TIMESTAMP() AS last_updated
FROM STAGING.STAGING_INTERVIEW_QUESTIONS
GROUP BY company_name;

INSERT INTO ANALYTICS_SKILLS_DEMAND
WITH skills_flattened AS (
    SELECT 
        skill.value::STRING AS skill_name,
        company_name
    FROM STAGING.STAGING_INTERVIEW_QUESTIONS,
    LATERAL FLATTEN(input => skills_mentioned) skill
    WHERE skills_mentioned IS NOT NULL
      AND ARRAY_SIZE(skills_mentioned) > 0
)
SELECT 
    skill_name,
    COUNT(*) AS times_mentioned,
    ARRAY_AGG(DISTINCT company_name) AS companies_asking,
    CURRENT_TIMESTAMP() AS last_updated
FROM skills_flattened
WHERE skill_name IS NOT NULL
GROUP BY skill_name;

SELECT 'By Category' AS table_name, COUNT(*) FROM ANALYTICS_QUESTION_BY_CATEGORY
UNION ALL
SELECT 'Company Insights', COUNT(*) FROM ANALYTICS_COMPANY_INSIGHTS
UNION ALL  
SELECT 'Skills Demand', COUNT(*) FROM ANALYTICS_SKILLS_DEMAND;
