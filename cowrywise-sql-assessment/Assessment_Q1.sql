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

