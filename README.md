
## Overview
SQL-based analysis of the data analyst job market, examining skills, salaries, and job postings to provide insights into industry trends and requirements.


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

```sql
WITH Top_Paying_jobs AS(
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
LIMIT 100)
SELECT skills,
COUNT(*) AS 'Skill Usage'
FROM
Top_Paying_jobs t
INNER JOIN skills_job_dim sj ON t.job_id=sj.job_id
INNER JOIN skills_dim s ON s.skill_id=sj.skill_id
GROUP BY skills
ORDER BY "Skill Usage" DESC
LIMIT 10
```

### 3. Most Demanded Skills (`Most_Demanded_Skills.sql`)
Lists the top 10 most frequently requested skills across all data analyst job postings.

```sql
SELECT skills,job_title_short,COUNT(*) AS'Skill Count'
FROM
skills_dim s
LEFT JOIN skills_job_dim sj ON s.skill_id=sj.skill_id
LEFT JOIN job_postings_fact j ON sj.job_id=j.job_id
WHERE job_title_short='Data Analyst'
GROUP BY skills
ORDER BY "Skill Count" DESC
LIMIT 10
```

### 4. Top Paying Skills (`Top_Paying_Skills.sql`)
Identifies skills associated with the highest average salaries in data analyst roles.

```sql
SELECT DISTINCT skills,
CAST(AVG(salary_year_avg)  OVER(PARTITION BY skills)AS INT) AS 'Average Salary'
FROM
skills_dim s
LEFT JOIN skills_job_dim sj ON s.skill_id=sj.skill_id
LEFT JOIN job_postings_fact j ON sj.job_id=j.job_id
WHERE job_title_short='Data Analyst'
AND
salary_year_avg <> ''
ORDER BY "Average Salary" DESC
LIMIT 10
```

### 5. Optimal Skills Analysis (`Optimal_Skills.sql`)
Identifies the top 10 skills associated with higher salaries in data analyst positions, filtering for skills that appear in more than 10 job postings.

```sql
SELECT skills,job_title_short,COUNT(*) AS'Skill Count',CAST(AVG(salary_year_avg)AS INT) AS 'Average Salary'
FROM
skills_dim s
LEFT JOIN skills_job_dim sj ON s.skill_id=sj.skill_id
LEFT JOIN job_postings_fact j ON sj.job_id=j.job_id
WHERE job_title_short='Data Analyst'
AND
salary_year_avg <> ''
GROUP BY skills
HAVING
"Skill Count" > 10 
ORDER BY "Average Salary" DESC
LIMIT 10
```

