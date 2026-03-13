
SELECT
    l.grade,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amnt) AS total_exposure,
    AVG(lp.default_flag) * 100 AS default_rate_percent
FROM loans l
JOIN loan_performance lp
ON l.loan_id = lp.loan_id
GROUP BY l.grade
ORDER BY l.grade
