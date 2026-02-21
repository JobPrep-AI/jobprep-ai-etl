# dbt Implementation - JobPrep ETL

## Author
Ganesh Gadicherla

## Overview

Modern ETL implementation using dbt (data build tool) for automated transformations, testing, and documentation.

## Setup

1. **Install dbt:**
```bash
pip install dbt-snowflake
```

2. **Configure credentials:**
```bash
cp profiles.yml.example ~/.dbt/profiles.yml
# Edit ~/.dbt/profiles.yml with your credentials
```

3. **Test connection:**
```bash
dbt debug
```

## Project Structure
```
models/
├── sources.yml              # Defines RAW_DATA sources
├── staging/                 # Stage 2: Cleaning
│   ├── stg_interview_questions.sql
│   └── schema.yml          # Tests for staging
└── analytics/              # Stage 4: Aggregations
    ├── analytics_question_by_category.sql
    ├── analytics_company_insights.sql
    ├── analytics_skills_demand.sql
    └── schema.yml          # Tests for analytics
```

## Running dbt
```bash
# Run all models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve

# Run everything (models + tests)
dbt build
```

## Models Created

### Staging
- `stg_interview_questions` → Creates DBT_JOBPREP_STAGING.STG_INTERVIEW_QUESTIONS

### Analytics  
- `analytics_question_by_category` → Creates DBT_JOBPREP_ANALYTICS.ANALYTICS_QUESTION_BY_CATEGORY
- `analytics_company_insights` → Creates DBT_JOBPREP_ANALYTICS.ANALYTICS_COMPANY_INSIGHTS
- `analytics_skills_demand` → Creates DBT_JOBPREP_ANALYTICS.ANALYTICS_SKILLS_DEMAND

## Outputs

Same transformations as manual SQL ETL, but automated:
- 20k+ questions in staging (cleaned)
- ~60 rows in analytics (aggregated)

## Advantages Over Manual SQL

- ✅ One command runs entire pipeline (`dbt run`)
- ✅ Automated testing (`dbt test`)
- ✅ Auto-generated documentation
- ✅ Dependency management (runs in correct order automatically)
- ✅ Incremental processing support
- ✅ Version controlled transformations

## Next Steps

- [ ] Add intermediate layer
- [ ] Add marts layer for AI agents
- [ ] Add more comprehensive tests
- [ ] Set up CI/CD for automated runs
