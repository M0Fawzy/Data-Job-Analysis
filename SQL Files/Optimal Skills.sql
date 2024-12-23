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
