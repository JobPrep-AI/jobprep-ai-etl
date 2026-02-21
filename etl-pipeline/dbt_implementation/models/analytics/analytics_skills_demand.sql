{{
    config(
        materialized='table'
    )
}}

WITH skills_flattened AS (
    SELECT 
        skill.value::STRING AS skill_name,
        company_name
    FROM {{ ref('stg_interview_questions') }},
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
GROUP BY skill_name
ORDER BY times_mentioned DESC
