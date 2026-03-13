
SELECT
    c.addr_state,
    COUNT(l.loan_id) AS total_loans,
    AVG(lp.default_flag) * 100 AS default_rate_percent
FROM loans l
JOIN loan_performance lp
ON l.loan_id = lp.loan_id
JOIN customers c
ON l.customer_id = c.customer_id
GROUP BY c.addr_state
HAVING COUNT(l.loan_id) > 5000
ORDER BY default_rate_percent DESC
LIMIT 10
