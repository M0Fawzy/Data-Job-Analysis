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

