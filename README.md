
## Overview
SQL-Based Analysis Of The Data Analyst Job Market, Examining Skills, Salaries, And Job Postings To Provide Insights Into Industry Trends And Requirements.


## Database Schema

### Main Tables
- `job_postings_fact`: Core Job Posting Information
- `company_dim`: Company Details
- `skills_dim`: Skills Information
- `skills_job_dim`: Mapping Table Linking Skills To Job Postings

### Key Fields
- `job_id`: Unique Identifier For Job Postings
- `company_id`: Unique Identifier For Companies
- `skill_id`: Unique Identifier For Skills
- `salary_year_avg`: Average Yearly Salary
- `job_title_short`: Standardized Job Titles
- `job_location`: Geographic Location Of The Position

## Queries

### 1. Top Paying Jobs (`Top_Paying_Jobs.sql`)
Lists The Top 100 Highest-Paying Data Analyst Positions, Including Company Details And Job Locations.

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
Analyzes The Most Common Skills Required In The Top 100 Highest-Paying Data Analyst Positions.

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
Lists The Top 10 Most Frequently Requested Skills Across All Data Analyst Job Postings.

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
| Skills      | Job Title Short | Skill Count |
|-------------|-----------------|-------------|
| SQL         | Data Analyst    | 92,628      |
| Excel       | Data Analyst    | 67,031      |
| Python      | Data Analyst    | 57,326      |
| Tableau     | Data Analyst    | 46,554      |
| Power BI    | Data Analyst    | 39,468      |
| R           | Data Analyst    | 30,075      |
| SAS         | Data Analyst    | 28,068      |
| PowerPoint  | Data Analyst    | 13,848      |
| Word        | Data Analyst    | 13,591      |
| SAP         | Data Analyst    | 11,297      |

*Top 10 Frequently Requested Skills*

### 4. Top Paying Skills (`Top_Paying_Skills.sql`)
Identifies Skills Associated With The Highest Average Salaries In Data Analyst Roles.

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
Identifies The Top 10 Skills Associated With Higher Salaries In Data Analyst Positions, Filtering For Skills That Appear In More Than 10 Job Postings.

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

