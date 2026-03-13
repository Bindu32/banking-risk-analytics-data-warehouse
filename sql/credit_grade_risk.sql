
SELECT
    cp.credit_band,
    l.grade,
    COUNT(*) AS loans,
    AVG(lp.default_flag) * 100 AS default_rate
FROM loans l
JOIN loan_performance lp
ON l.loan_id = lp.loan_id
JOIN credit_profiles cp
ON l.customer_id = cp.customer_id
GROUP BY cp.credit_band, l.grade
ORDER BY default_rate DESC
LIMIT 10
