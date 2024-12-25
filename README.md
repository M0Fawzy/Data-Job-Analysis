
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

![image](https://github.com/user-attachments/assets/e2a27949-3fe2-4db0-a426-6d8e61d5327b)

*Bar Chart Made In Power BI That Showcases The Top 10 Highest Paying Jobs*

**Breakdown Of The Results:**
- The highest-paying position is a Data Analyst role with a salary of $650,000.
- The majority of top-paying roles are leadership or senior positions.

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
| Skills      | Skill Usage |
|-------------|-------------|
| Python      | 54          |
| SQL         | 50          |
| Tableau     | 37          |
| R           | 28          |
| Excel       | 19          |
| Spark       | 13          |
| AWS         | 12          |
| Power BI    | 11          |
| Go          | 10          |
| SAS         | 10          |

*The Most Demanded Skills For The Highest Paying Jobs*

**Breakdown Of The Results:**
- Python and SQL are the most commonly required skills for the highest-paying Data Analyst positions.
- Visualization tools like Tableau and Power BI also feature prominently, indicating their importance in top-tier roles.
- Cloud technologies (e.g., AWS) and advanced programming skills (e.g., R, Spark) are valued for high-paying positions.
  
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

**Breakdown Of The Results:**
- SQL is the most frequently requested skill across all Data Analyst job postings, highlighting its fundamental role in the field.
- Python, Excel, and Tableau consistently rank high, underscoring their widespread utility in data analysis tasks.
- Power BI, R, and SAS are also significant, reflecting a balance between technical programming skills and business intelligence tools.

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
| Skills      | Average Salary |
|-------------|----------------|
| SVN         | 400,000        |
| Solidity    | 179,000        |
| Couchbase   | 160,515        |
| DataRobot   | 155,485        |
| Golang      | 155,000        |
| MXNet       | 149,000        |
| dplyr       | 147,633        |
| VMware      | 147,500        |
| Terraform   | 146,733        |
| Twilio      | 138,500        |

*The Skills With The Highest Salaries*

**Breakdown Of The Results:**
- Specialized and emerging skills like SVN, Solidity, and Couchbase command the highest average salaries, suggesting they are niche but in demand.
- Tools and technologies associated with machine learning (e.g., DataRobot, Golang, dplyr) appear prominently, emphasizing the growing importance of advanced analytics.
  
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
| Skills      | Job Title Short | Skill Count | Average Salary |
|-------------|-----------------|-------------|----------------|
| Kafka       | Data Analyst    | 40          | 129,999        |
| PyTorch     | Data Analyst    | 20          | 125,226        |
| Perl        | Data Analyst    | 20          | 124,685        |
| TensorFlow  | Data Analyst    | 24          | 120,646        |
| Cassandra   | Data Analyst    | 11          | 118,406        |
| Atlassian   | Data Analyst    | 15          | 117,965        |
| Airflow     | Data Analyst    | 71          | 116,387        |
| Scala       | Data Analyst    | 59          | 115,479        |
| Linux       | Data Analyst    | 58          | 114,883        |
| Confluence  | Data Analyst    | 62          | 114,153        |

*Top !0 Highest salary Skills That Are Used In More Than 10 Job Postings*

**Breakdown Of The Results:**

- Skills like Kafka, PyTorch, and TensorFlow are associated with higher salaries and appear in a substantial number of job postings, indicating their relevance in high-demand and lucrative roles.
- Linux, Airflow, and Scala demonstrate the increasing importance of workflow automation and programming in data-related roles.
- These findings provide a guide for skill prioritization for individuals aiming to maximize their earning potential in Data Analyst careers.
