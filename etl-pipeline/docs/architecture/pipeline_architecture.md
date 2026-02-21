# ETL Pipeline Architecture

## Current Implementation

### 3-Layer Architecture

#### Layer 1: RAW_DATA (Bronze)
- Schema: RAW_DATA
- Table: INTERVIEW_QUESTIONS
- Records: 25k+
- Owner: Data ingestion team

#### Layer 2: STAGING (Silver)
- Schema: STAGING
- Table: STAGING_INTERVIEW_QUESTIONS  
- Records: 25k+
- Transformations: Clean, categorize, extract skills
- Owner: Ganesh Gadicherla (ETL pipeline)

#### Layer 3: ANALYTICS (Gold)
- Schema: ANALYTICS
- Tables: 3 aggregated tables (~60 rows)
- Transformations: GROUP BY aggregations
- Owner: Ganesh Gadicherla (ETL pipeline)

## ETL Pattern

**Method**: Full Refresh (TRUNCATE + INSERT)
**Execution**: Manual (can be automated)
**Frequency**: On-demand when new data arrives
