use `cowry_da_assessment`;

SHOW TABLES;

/*Q1 High-Value Customers with Multiple Products
Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.*/

SELECT  
  u.id AS owner_id, 
  u.first_name, 
COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id 
    END) AS savings_count,
COUNT(DISTINCT CASE WHEN p.is_fixed_investment = 1 THEN p.id 
    END) AS investment_count,
    
ROUND(SUM(s.amount),0) AS total_deposits 
FROM users_customuser u 
LEFT JOIN plans_plan p ON u.id = p.owner_id 
LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id 
GROUP BY u.id, u.first_name
HAVING savings_count >= 1 AND investment_count >= 1 
LIMIT 50;

/*Q2 Transaction Frequency Analysis
Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)*/

-- Q2 Transaction Frequency Analysis - Categorize customers based on average monthly transactions

WITH monthly_transactions AS 
( SELECT owner_id,
DATE_FORMAT(transaction_date, '%Y-%m') AS month_year,
COUNT(*) AS tx_count
FROM savings_savingsaccount
GROUP BY owner_id, month_year),

average_monthly_tx AS (
SELECT 
owner_id,
AVG(tx_count) AS avg_tx_per_month
FROM monthly_transactions
GROUP BY owner_id)
SELECT 
u.id AS customer_id,
u.first_name,
ROUND(a.avg_tx_per_month, 2) AS avg_tx_per_month,
CASE 
WHEN a.avg_tx_per_month >= 10 THEN 'High Frequency'
WHEN a.avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
ELSE 'Low Frequency'
END AS frequency_category
FROM average_monthly_tx a
JOIN users_customuser u ON u.id = a.owner_id
ORDER BY avg_tx_per_month DESC;


/*3. Account Inactivity Alert
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