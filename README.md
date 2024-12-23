
## Overview
SQL-based analysis of the data analyst job market, examining skills, salaries, and job postings to provide insights into industry trends and requirements.

## Queries

### 1. Top Paying Jobs (`Top_Paying_Jobs.sql`)
Lists the top 100 highest-paying data analyst positions, including company details and job locations.

``` sql
SELECT job_id,
name AS 'Company Name',
job_title_short,
salary_year_avg,
job_title,
job_posted_date,
job_location
FROM 
job_postings_fact j
LEFT JOIN  company_dim c on j.company_id=c.company_id
WHERE job_title_short='Data Analyst'
AND
salary_year_avg <> ''
ORDER BY salary_year_avg DESC
LIMIT 100;
```
### 2. Top Paying Jobs Skills (`Top_Paying_Jobs_Skills.sql`)
Analyzes the most common skills required in the top 100 highest-paying data analyst positions.

### 3. Most Demanded Skills (`Most_Demanded_Skills.sql`)
Lists the top 10 most frequently requested skills across all data analyst job postings.

### 4. Top Paying Skills (`Top_Paying_Skills.sql`)
Identifies skills associated with the highest average salaries in data analyst roles.

### 5. Optimal Skills Analysis (`Optimal_Skills.sql`)
Identifies the top 10 skills associated with higher salaries in data analyst positions, filtering for skills that appear in more than 10 job postings.

## Database Schema

### Main Tables
- `job_postings_fact`: Core job posting information
- `company_dim`: Company details
- `skills_dim`: Skills information
- `skills_job_dim`: Mapping table linking skills to job postings

### Key Fields
- `job_id`: Unique identifier for job postings
- `company_id`: Unique identifier for companies
- `skill_id`: Unique identifier for skills
- `salary_year_avg`: Average yearly salary
- `job_title_short`: Standardized job titles
- `job_location`: Geographic location of the position
