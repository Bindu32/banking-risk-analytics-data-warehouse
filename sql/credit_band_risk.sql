
SELECT
    cp.credit_band,
    COUNT(l.loan_id) AS total_loans,
    SUM(lp.default_flag) AS defaults,
    AVG(lp.default_flag) * 100 AS default_rate_percent
FROM loans l
JOIN loan_performance lp
ON l.loan_id = lp.loan_id
JOIN credit_profiles cp
ON l.customer_id = cp.customer_id
GROUP BY cp.credit_band
ORDER BY default_rate_percent DESC
