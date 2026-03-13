
SELECT
    YEAR(l.issue_d) AS loan_year,
    COUNT(*) AS loans,
    AVG(lp.default_flag) * 100 AS default_rate
FROM loans l
JOIN loan_performance lp
ON l.loan_id = lp.loan_id
GROUP BY loan_year
ORDER BY loan_year
