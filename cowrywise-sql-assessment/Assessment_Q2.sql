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