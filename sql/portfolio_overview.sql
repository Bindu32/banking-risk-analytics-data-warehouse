
SELECT
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    SUM(l.loan_amnt) AS total_portfolio_value,
    AVG(lp.default_flag) * 100 AS default_rate_percent
FROM loans l
JOIN loan_performance lp
ON l.loan_id = lp.loan_id
JOIN customers c
ON l.customer_id = c.customer_id
