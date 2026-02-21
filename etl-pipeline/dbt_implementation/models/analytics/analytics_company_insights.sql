{{
    config(
        materialized='table'
    )
}}

SELECT 
    company_name,
    COUNT(*) AS total_questions,
    ARRAY_AGG(DISTINCT question_category_enhanced) AS common_categories,
    ROUND(AVG(complexity_score), 3) AS avg_question_complexity,
    CURRENT_TIMESTAMP() AS last_updated
    
FROM {{ ref('stg_interview_questions') }}

GROUP BY company_name
ORDER BY total_questions DESC
