
SELECT
    YEAR(issue_d) AS loan_year,
    COUNT(*) AS total_loans,
    SUM(loan_amnt) AS total_lending
FROM loans
GROUP BY loan_year
ORDER BY loan_year
