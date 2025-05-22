/* Q3. Account Inactivity Alert
Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)*/

-- Q3 Find active plans with no inflow transactions in the last 1 year

SELECT 
p.id AS plan_id,
p.owner_id,
    CASE 
WHEN p.is_regular_savings = 1 THEN 'Savings'
WHEN p.is_fixed_investment = 1 THEN 'Investment'
ELSE 'Other'
END AS type,
MAX(s.transaction_date) AS last_transaction_date,
-- Calculate days since last transaction
DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
ON p.id = s.plan_id
WHERE 
p.is_deleted = 0
AND p.is_archived = 0
GROUP BY 
p.id, p.owner_id, p.is_regular_savings, p.is_fixed_investment
HAVING 
last_transaction_date IS NULL 
OR DATEDIFF(CURDATE(), last_transaction_date) > 365
ORDER BY inactivity_days DESC;