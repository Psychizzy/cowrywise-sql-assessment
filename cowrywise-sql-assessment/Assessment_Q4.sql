/*4. Customer Lifetime Value (CLV) Estimation
Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest */

SELECT 
u.id AS customer_id,
u.first_name,
TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
COUNT(s.id) AS total_transactions,

  -- Estimated CLV using simplified formula
    ROUND((
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
        * 12 
        * (SUM(s.amount) * 0.001 / COUNT(s.id))
    ), 2) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
GROUP BY u.id, u.name, u.date_joined
ORDER BY estimated_clv DESC;