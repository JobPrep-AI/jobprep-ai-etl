{{
    config(
        materialized='table'
    )
}}

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
    
FROM {{ ref('stg_interview_questions') }}

GROUP BY question_category_enhanced, difficulty_level
ORDER BY total_questions DESC
