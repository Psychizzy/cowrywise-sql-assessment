# Data Analytics SQL Assessment – Case Study

This project simulates a real-life SQL analytics task involving a relational database with user accounts, transactions, and savings/investment plans. Each question represents a typical business scenario coming from departments like marketing, finance, or operations.

As an aspiring data analyst, I approached this task with both technical and business insight — using SQL to transform raw data into clear answers decision-makers can use. The queries were written in MySQL and structured for clarity, efficiency, and scalability.

---

## Project Context

The database consists of 4 tables:

- **users_customuser** – customer demographic info and account creation
- **plans_plan** – records of savings and investment plans per user
- **savings_savingsaccount** – deposit/inflow transactions into plans
- **withdrawals_withdrawal** – records of money withdrawn

Each question targets a specific business goal, and the result was generated through a combination of `JOIN`, `GROUP BY`, aggregation, date functions, and business rule logic.

---

## Question 1 – High-Value Customers with Multiple Products

The business wanted to identify customers who have both savings and investment plans (cross-sell opportunity).

To solve this:
- I used conditional counting to get savings and investment counts per customer.
- Joined with the savings transactions to calculate total deposits.
- Filtered for customers with at least one of each plan type.

This output allows the business to focus loyalty, upgrade, and referral campaigns on these top-tier users.

---

## Question 2 – Transaction Frequency Analysis

Marketing wants to classify users based on how often they transact monthly.

My approach:
- Counted monthly transaction volume per user using `DATE_FORMAT`.
- Averaged monthly frequency across the full user lifespan.
- Categorized them as:
  - **High Frequency**: ≥ 10/month
  - **Medium Frequency**: 3–9/month
  - **Low Frequency**: ≤ 2/month
 This output can drive engagement campaigns to convert medium-frequency users into high-value customers.

---

## Question 3 – Inactivity Alert for Plans

Operations wants to identify accounts that have been inactive (no inflow) for over 365 days.

Here’s how I tackled it:
- Used `LEFT JOIN` to connect `plans_plan` with `savings_savingsaccount`.
- Extracted the latest transaction per plan.
- Calculated days since that transaction using `DATEDIFF`.
- Filtered plans inactive for more than 1 year.

 This data helps the company re-engage dormant users or auto-deactivate stale plans.

---

## Question 4 – Customer Lifetime Value (CLV)

Marketing wants to estimate each customer's CLV based on their tenure and transactions.

Here’s the logic I followed:

- Calculated account age in months using `TIMESTAMPDIFF`.
- Assumed **profit per transaction = 0.1% of transaction amount**
- Applied the formula:  
  `(total_transactions / tenure_months) * 12 * avg_profit_per_tx`

The result helps rank customers by value — great for targeting rewards or early renewals.

---

## Final Observations

Each question simulates a real-world business problem, and the queries were designed to be modular, clean, and reusable. Beyond SQL syntax, the goal was to tell a data story — one that aligns technical insight with business strategy.

This exercise deepened my skills in:

- Customer segmentation
- Date/time calculations
- Plan performance monitoring
- Revenue modeling

And it reinforced how **SQL is more than a query tool — it’s a storytelling language for data.**
    
