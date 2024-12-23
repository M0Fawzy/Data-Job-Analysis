SELECT skills,job_title_short,COUNT(*) AS'Skill Count'
FROM
skills_dim s
LEFT JOIN skills_job_dim sj ON s.skill_id=sj.skill_id
LEFT JOIN job_postings_fact j ON sj.job_id=j.job_id
WHERE job_title_short='Data Analyst'
GROUP BY skills
ORDER BY "Skill Count" DESC
LIMIT 10