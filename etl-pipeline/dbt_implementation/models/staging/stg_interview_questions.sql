{{
    config(
        materialized='table'
    )
}}

SELECT 
    -- Original fields (cleaned)
    id AS question_id,
    TRIM(UPPER(company_name)) AS company_name,
    TRIM(role_name) AS role_name,
    TRIM(interview_question) AS interview_question,
    COALESCE(TRIM(difficulty), 'Medium') AS difficulty_level,
    
    -- Enhanced categorization
    CASE 
        WHEN LOWER(interview_question) LIKE '%array%' 
             OR LOWER(interview_question) LIKE '%subarray%'
        THEN 'Technical - Arrays'
        
        WHEN LOWER(interview_question) LIKE '%string%' 
             OR LOWER(interview_question) LIKE '%anagram%'
             OR LOWER(interview_question) LIKE '%palindrome%'
        THEN 'Technical - Strings'
        
        WHEN LOWER(interview_question) LIKE '%tree%' 
             OR LOWER(interview_question) LIKE '%bst%'
             OR LOWER(interview_question) LIKE '%node%'
        THEN 'Technical - Trees & Graphs'
        
        WHEN LOWER(interview_question) LIKE '%sort%' 
             OR LOWER(interview_question) LIKE '%search%'
        THEN 'Technical - Sorting & Searching'
        
        WHEN LOWER(interview_question) LIKE '%longest%' 
             OR LOWER(interview_question) LIKE '%maximum%'
             OR LOWER(interview_question) LIKE '%subsequence%'
        THEN 'Technical - Dynamic Programming'
        
        WHEN LOWER(interview_question) LIKE '%count%' 
             OR LOWER(interview_question) LIKE '%calculate%'
        THEN 'Technical - Math & Logic'
        
        ELSE 'Technical - Coding Challenge'
    END AS question_category_enhanced,
    
    -- Skills extraction
    ARRAY_CONSTRUCT_COMPACT(
        CASE WHEN LOWER(interview_question) LIKE '%array%' THEN 'Arrays' END,
        CASE WHEN LOWER(interview_question) LIKE '%string%' THEN 'Strings' END,
        CASE WHEN LOWER(interview_question) LIKE '%tree%' THEN 'Trees' END,
        CASE WHEN LOWER(interview_question) LIKE '%python%' THEN 'Python' END
    ) AS skills_mentioned,
    
    -- Metrics
    LENGTH(interview_question) AS question_length,
    ARRAY_SIZE(SPLIT(interview_question, ' ')) AS word_count,
    
    -- Flags
    FALSE AS is_behavioral,
    TRUE AS is_technical,
    0.5 AS complexity_score,
    
    -- Metadata
    COALESCE(source, 'Unknown') AS source,
    date_collected,
    CURRENT_TIMESTAMP() AS processed_at
    
FROM {{ source('raw_data', 'interview_questions') }}
WHERE interview_question IS NOT NULL
  AND LENGTH(TRIM(interview_question)) > 10
