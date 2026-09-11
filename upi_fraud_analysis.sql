
-- =========================================================
-- UPI TRANSACTION FRAUD ANALYSIS
-- PostgreSQL Database Setup & Validation
-- =========================================================


-- 
-- 1. CREATE USERS TABLE
-- 

CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    age_group VARCHAR(20),
    city VARCHAR(100),
    city_tier VARCHAR(20),
    kyc_status VARCHAR(30),
    account_age_days INT,
    linked_bank_count INT,
    avg_monthly_transactions INT,
    avg_transaction_value NUMERIC(12,2),
    preferred_app VARCHAR(50),
    preferred_device VARCHAR(30),
    user_loyalty_score NUMERIC(5,2),
    is_high_risk_user INT
);


-- 
-- 2. CREATE MERCHANTS TABLE
-- 

CREATE TABLE merchants (
    merchant_id VARCHAR(20) PRIMARY KEY,
    merchant_name VARCHAR(150),
    merchant_category VARCHAR(100),
    merchant_size VARCHAR(30),
    city VARCHAR(100),
    city_tier VARCHAR(20),
    avg_daily_transactions INT,
    is_registered INT,
    rating NUMERIC(3,2)
);


-- 
-- 3. CREATE TRANSACTIONS TABLE
-- 

CREATE TABLE transactions (
    transaction_id VARCHAR(30) PRIMARY KEY,
    user_id VARCHAR(20),
    receiver_id VARCHAR(30),
    receiver_type VARCHAR(20),
    amount NUMERIC(12,2),
    timestamp TIMESTAMP,
    date DATE,
    hour_of_day INT,
    day_of_week VARCHAR(20),
    is_weekend INT,
    is_night_transaction INT,
    time_since_last_txn_min NUMERIC(10,2),
    transaction_type VARCHAR(30),
    payment_app VARCHAR(50),
    device_type VARCHAR(30),
    status VARCHAR(20),
    user_city_tier VARCHAR(20),
    user_kyc_status VARCHAR(30),
    user_avg_monthly_txn INT,
    user_avg_txn_value NUMERIC(12,2),
    user_loyalty_score NUMERIC(5,2),
    new_device_flag INT,
    ip_location_mismatch INT,
    failed_attempts_last_24h INT,
    transaction_velocity NUMERIC(10,2),
    amount_deviation_score NUMERIC(10,4),
    is_fraud INT,
    recurring_payment_flag INT,
    balance_after_transaction NUMERIC(12,2),
    transaction_frequency_score NUMERIC(10,4),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- 
-- 4. CREATE FRAUD LABELS TABLE
-- 

CREATE TABLE fraud_labels (
    transaction_id VARCHAR(30) PRIMARY KEY,
    user_id VARCHAR(20),
    receiver_id VARCHAR(30),
    amount NUMERIC(12,2),
    timestamp TIMESTAMP,
    is_fraud INT,
    new_device_flag INT,
    ip_location_mismatch INT,
    failed_attempts_last_24h INT,
    transaction_velocity NUMERIC(10,2),
    amount_deviation_score NUMERIC(10,4),

    FOREIGN KEY (transaction_id)
        REFERENCES transactions(transaction_id),

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);


-- =========================================================
-- 5. DATA VALIDATION
-- =========================================================

-- Check number of users
SELECT *
FROM users;


-- Check number of merchants
SELECT COUNT(*)
FROM merchants;


-- Check number of transactions
SELECT COUNT(*)
FROM transactions;


-- Check number of fraud labels
SELECT COUNT(*)
FROM fraud_labels;


-- View sample transactions
SELECT *
FROM transactions
LIMIT 5;


-- Check a specific transaction
SELECT *
FROM transactions
WHERE transaction_id = 'TXN0003501';


-- Check fraud labels table
SELECT *
FROM fraud_labels
LIMIT 5;


-- 
-- END OF DATABASE SETUP & VALIDATION
-- 


-- Check whether every transaction belongs to a valid user

SELECT COUNT(*) AS invalid_user_transactions
FROM transactions t
LEFT JOIN users u
    ON t.user_id = u.user_id
WHERE u.user_id IS NULL;

-- Check whether every fraud label belongs to a valid transaction

SELECT COUNT(*) AS invalid_fraud_transactions
FROM fraud_labels f
LEFT JOIN transactions t
    ON f.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;

-- Check duplicate transaction IDs

SELECT transaction_id, COUNT(*) AS duplicate_count
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Check duplicate user IDs

SELECT user_id, COUNT(*) AS duplicate_count
FROM users
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Check duplicate transaction IDs in fraud labels

SELECT transaction_id, COUNT(*) AS duplicate_count
FROM fraud_labels
GROUP BY transaction_id
HAVING COUNT(*) > 1;


/*
QUESTION 1:

Find the total number of transactions,
the number of fraudulent transactions,
and the fraud rate percentage.

Table: transactions

Columns you may need:
- transaction_id
- is_fraud

Return:
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage
*/

select count(transaction_id) as total_transactions ,
sum(is_fraud)  as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions
;

/*
QUESTION 2:

Find the fraud rate for each transaction type.

Table: transactions

Return:
- transaction_type
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Sort by fraud_rate_percentage from highest to lowest.
*/
select transaction_type,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions
group by transaction_type
order by fraud_rate_percentage desc;

/*
QUESTION 3:

Find the fraud rate for each payment app.

Table: transactions

Return:
- payment_app
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Sort by fraud_rate_percentage from highest to lowest.
*/
select payment_app,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions
group by payment_app

order by fraud_rate_percentage desc;

/*
QUESTION 4:

Find the fraud rate for each device type.

Table: transactions

Return:
- device_type
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Sort by fraud_rate_percentage from highest to lowest.
*/

select device_type,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions
group by device_type

order by fraud_rate_percentage desc;


/*
QUESTION 4:

Find the total number of transactions and
total transaction amount for each user.

Use:
- users
- transactions

Return:
- user_id
- city
- total_transactions
- total_amount

Sort by total_amount from highest to lowest.
*/
select u.user_id,
u.city,
count(t.transaction_id) as total_transactions,
sum(t.amount) as total_amount
from transactions t join users u
on t.user_id=u.user_id
group by u.user_id,u.city
ORDER BY total_amount DESC;

/*
QUESTION 5:

Find the total transactions, fraudulent transactions,
and fraud rate for each city.

Use:
- users
- transactions

Return:
- city
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Sort by fraud_rate_percentage from highest to lowest.
*/


select u.city,
count(t.transaction_id) as total_transactions,
sum(t.is_fraud) as fraudulent_transactions,
round(sum(t.is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
group by u.city

order by fraud_rate_percentage desc;

/*
QUESTION 6:

Find the fraud rate for high-risk vs non-high-risk users.

Use:
- users
- transactions

Join them using user_id.

Return:
- is_high_risk_user
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Sort by fraud_rate_percentage from highest to lowest.
*/

select u.is_high_risk_user,
count(t.transaction_id) as total_transactions,
sum(t.is_fraud) as fraudulent_transactions,
round(sum(t.is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
group by u.is_high_risk_user

order by fraud_rate_percentage desc;

/*
QUESTION 7:

Find the fraud rate for each merchant category.

Use:
- transactions
- merchants

Only include transactions where receiver_type = 'Merchant'.

Join the tables using:
- transactions.receiver_id
- merchants.merchant_id

Return:
- merchant_category
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage


Sort by fraud_rate_percentage from highest to lowest.
*/


select m.category as merchant_category,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join merchants m
on t.receiver_id=m.merchant_id
where receiver_type='Merchant'
group by m.category
order by fraud_rate_percentage desc;

/*
QUESTION 8:

Find users who have made more than 10 transactions
and have at least 1 fraudulent transaction.

Use:
- users
- transactions

Join using user_id.

Return:
- user_id
- city
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Only include users with:
- more than 10 total transactions
- at least 1 fraudulent transaction

Sort by fraud_rate_percentage from highest to lowest.
*/

select u.user_id,u.city,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
group by u.user_id,u.city
having count(transaction_id)>10 and sum(is_fraud) >=1
order by fraud_rate_percentage desc
;

/*
QUESTION 9:

Find the merchant with the highest fraud rate.

Use:
- transactions
- merchants

Consider only transactions where receiver_type = 'Merchant'.

Return:
- merchant_id
- merchant_name
- merchant_category
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Show only the merchant with the highest fraud rate.

Sort by fraud_rate_percentage from highest to lowest.
*/

select m.merchant_id ,m.merchant_name,category,
count(t.transaction_id) as total_transactions,
sum(t.is_fraud) as fraudulent_transactions,
round(sum(t.is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join merchants m
on t.receiver_id=m.merchant_id
where t.receiver_type='Merchant'
group by m.merchant_id,merchant_name,m.category
order by fraud_rate_percentage desc
limit 1;

/*
QUESTION 10:

Find the top 10 high-risk users based on total fraudulent
transactions.

Use:
- users
- transactions

A high-risk user is one where:
is_high_risk_user = 1

Return:
- user_id
- city
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Only include high-risk users.

Sort by fraudulent_transactions from highest to lowest
and show the top 10 users.
*/
select u.user_id,u.city,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
where is_high_risk_user=1
group by u.user_id,u.city

order by fraudulent_transactions desc
limit 10
;

/*
QUESTION 11:

Compare high-risk users and non-high-risk users based on
their transaction behavior.

Return:
- is_high_risk_user
- total_users
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage
- average_transaction_amount

Use:
- users
- transactions

Join using user_id.

Group by high-risk status.

Sort by fraud_rate_percentage from highest to lowest.
*/

select  u.is_high_risk_user, count( distinct u.user_id) as total_users,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage,
round(avg(amount),2)as average_transaction_amount
from transactions t join users u
on t.user_id=u.user_id

group by u.is_high_risk_user

order by fraud_rate_percentage desc

;

/*
QUESTION 12:

Find the top 10 users with the highest fraud rate.

Return:
- user_id
- city
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage
- average_transaction_amount

Only include users who have made at least 10 transactions.

Sort by fraud_rate_percentage from highest to lowest.
Show the top 10 users.
*/

select u.user_id,u.city,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage,
round(avg(amount),2)as average_transaction_amount
from transactions t join users u
on t.user_id=u.user_id

group by u.user_id,u.city
having count(transaction_id) >=10
order by fraud_rate_percentage desc
limit 10
;

/*
QUESTION 13:

Find the top 20 fraudulent transactions by transaction amount.

Return:
- transaction_id
- user_id
- amount
- transaction_type
- payment_app
- device_type
- is_night_transaction
- new_device_flag
- ip_location_mismatch
- failed_attempts_last_24h

Only include fraudulent transactions.

Sort by amount from highest to lowest.

Show the top 20 transactions.
*/

select 
 transaction_id,
 user_id,
 amount,
 transaction_type,
 payment_app,
 device_type,
 is_night_transaction,
 new_device_flag,
 ip_location_mismatch,
 failed_attempts_last_24h
from transactions
where is_fraud=1
order by amount desc
limit 20;

/*
QUESTION 14:

For each of these risk signals, calculate the observed fraud rate
when the signal is present versus absent.

Signals:

1. new_device_flag
2. ip_location_mismatch
3. failed_attempts_last_24h >= 3
4. transaction_velocity >= 2

Return one result for each signal with:

- risk_signal
- signal_status
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Sort by fraud_rate_percentage from highest to lowest.

Use UNION ALL to combine the four analyses.
*/
select 
 CASE
    WHEN failed_attempts_last_24h >= 3
         AND transaction_velocity >= 2
        THEN 'Both Signals'
    WHEN failed_attempts_last_24h >= 3
        THEN 'High Failed Attempts Only'
    WHEN transaction_velocity >= 2
        THEN 'High Velocity Only'
    ELSE 'Neither'
END AS risk_group,
COUNT(*) AS total_transactions,
 sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage,
round(avg(amount),2)as average_transaction_amount
from transactions
group by risk_group
ORDER BY fraud_rate_percentage DESC;

--Transactions with both high failed attempts (≥3) and high transaction velocity (≥2) had a 9.74% observed fraud rate, compared with 2.95% when neither signal was present.

/*
QUESTION 15:

Compare fraud rates between night and non-night transactions.

Use the transactions table.

Return:
-- is_night_transaction
-- total_transactions
-- fraudulent_transactions
-- fraud_rate_percentage
-- average_transaction_amount

Group by is_night_transaction.

Sort by fraud_rate_percentage DESC.
*/

select 
is_night_transaction,
COUNT(*) AS total_transactions,
 sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage,
round(avg(amount),2)as average_transaction_amount
from transactions
group by is_night_transaction
ORDER BY fraud_rate_percentage DESC;


--Night-time transactions showed a higher observed fraud rate (5.27%) than non-night transactions (3.12%), indicating that transaction timing may be an important risk indicator.

-- Which users have experienced multiple fraudulent transactions?

-- Return:

-- user_id
-- city
-- total_transactions
-- fraudulent_transactions
-- fraud_rate_percentage

-- Conditions:

-- User must have at least 2 fraudulent transactions
-- User must have made at least 5 total transactions
-- Sort by fraudulent_transactions DESC
-- Return the top 10 users

select u.user_id,u.city,
count(transaction_id) as total_transactions,
sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
group by u.user_id,u.city
having sum(is_fraud)>=2 and count(transaction_id)>=5 
order by fraudulent_transactions desc
limit 10
;

--A small group of users showed repeated fraudulent transactions, with the highest-risk user recording 5 fraudulent transactions out of 15 transactions (33.33%), indicating potential recurring fraud patterns that may warrant additional monitoring.

-- Question 17 — Fraud by transaction amount 💰

-- Now I want to investigate whether higher-value transactions are associated with higher fraud rates.

-- Use these amount groups:

-- < ₹500 → Low
-- ₹500–₹1,000 → Medium
-- ₹1,000–₹5,000 → High
-- ₹5,000–₹10,000 → Very High
-- > ₹10,000 → Extreme

-- Return:

-- amount_category
-- total_transactions
-- fraudulent_transactions
-- fraud_rate_percentage
-- average_transaction_amount

-- Sort by fraud_rate_percentage DESC.

select case
when amount<500 then 'Low'
when amount between 500 and 1000 then 'Medium'
when amount between 1000 and 5000 then 'High'
when amount between 5000 and 10000 then 'Very High'
else  'Extreme' end as amount_groups,
COUNT(*) AS total_transactions,
 sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage,
round(avg(amount),2)as average_transaction_amount
from transactions
group by amount_groups
ORDER BY fraud_rate_percentage DESC;

/*
QUESTION 18:

Analyze fraud rates based on device type AND KYC status together.

Use the transactions table.

Return:
- device_type
- user_kyc_status
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Group by:
- device_type
- user_kyc_status

Sort by fraud_rate_percentage DESC.

Use GROUP BY with both columns.
*/

select 
device_type,
kyc_status as user_kyc_status,
COUNT(*) AS total_transactions,
 sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
group by device_type,kyc_status
order by fraud_rate_percentage desc;

--The Not Verified groups consistently have higher observed fraud rates across all three device types:

--Web: 6.05% vs 3.85%
--iOS: 6.05% vs 3.32%
--Android: 5.51% vs 3.56%

--Across Web, iOS, and Android, non-verified users showed higher observed fraud rates than verified users, suggesting that KYC status may be an important risk indicator regardless of device type.


/*
QUESTION 19:

Identify cities with the highest observed fraud rates.

Use the transactions and users tables.

Return:
- city
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Only include cities with at least 100 transactions.

Sort by fraud_rate_percentage DESC.

Return the top 10 cities.
*/
select city,
COUNT(*) AS total_transactions,
 sum(is_fraud) as fraudulent_transactions,
round(sum(is_fraud)*100.0/count(*),2) as fraud_rate_percentage
from transactions t join users u
on t.user_id=u.user_id
group by city
having count(*) >= 100
order by fraud_rate_percentage desc
limit 10
;

--Among cities with at least 100 transactions:

--Guwahati had the highest observed fraud rate at 5.62% (14 frauds / 249 transactions).
--Ranchi: 5.42%
--Solapur: 5.22%
--Amritsar: 5.12%
--Ahmedabad: 5.05%

--Fraud rates varied across cities, with Guwahati showing the highest observed rate among cities with at least 100 transactions at 5.62%. This suggests geographic location may be a useful segmentation factor for further fraud-risk analysis

/*
We've now got 5 potential key findings:

🔥 Risk-signal combination — 9.74% vs 2.95%
🌙 Night transactions — 5.27% vs 3.12%
👤 Repeated fraud users — some users above 20% fraud rate
🔐 KYC + device — non-verified users consistently higher
📍 City variation — Guwahati 5.62% among cities with ≥100 transactions
*/

/*
QUESTION 20:

Identify merchant categories with elevated fraud risk.

Use the transactions and merchants tables.

Return:
- merchant_category
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage
- average_transaction_amount

Only include merchant categories with at least 500 transactions.

Sort by fraud_rate_percentage DESC.

Return all qualifying merchant categories.

Use:
- JOIN
- WHERE receiver_type = 'Merchant'
- GROUP BY
- HAVING
*/

select m.category as merchant_category,
count(*) as total_transactions,
sum(t.is_fraud)as fraudulent_transactions,
round(sum(t.is_fraud)*100.0/count(*),2) as fraud_rate_percentage,
round(avg(t.amount),2) as average_transaction_amount
from transactions t join merchants m
on t.receiver_id = m.merchant_id
where t.receiver_type ='Merchant'
group by m.category
having count(*) >=500
order by fraud_rate_percentage desc;

--Merchant category showed variation in observed fraud rates, with Grocery (4.70%) and Food & Dining (4.37%) recording relatively higher rates, while Entertainment had the lowest rate (2.58%).

/*
QUESTION 21:

Compare the observed fraud rate for different binary risk indicators.

Analyze these three indicators from the transactions table:

1. new_device_flag
2. ip_location_mismatch
3. is_night_transaction

For each indicator, return:
- risk_indicator
- indicator_value
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage

Use a CTE and UNION ALL.

Sort by fraud_rate_percentage DESC.

The goal is to identify which risk indicators show the strongest
difference in observed fraud rate between their 0 and 1 groups.
*/

WITH risk_analysis AS (

    SELECT
        'new_device_flag' AS risk_indicator,
        new_device_flag AS indicator_value,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraudulent_transactions,
        ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
    FROM transactions
    GROUP BY new_device_flag

    UNION ALL

    SELECT
        'ip_location_mismatch' AS risk_indicator,
        ip_location_mismatch AS indicator_value,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraudulent_transactions,
        ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
    FROM transactions
    GROUP BY ip_location_mismatch

    UNION ALL

    SELECT
        'is_night_transaction' AS risk_indicator,
        is_night_transaction AS indicator_value,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraudulent_transactions,
        ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
    FROM transactions
    GROUP BY is_night_transaction
)

SELECT *
FROM risk_analysis
ORDER BY fraud_rate_percentage DESC;

/*New-device transactions showed the strongest association with fraud, with an
observed fraud rate of 12.35% compared with 3.22% for transactions from existing
devices. IP-location mismatches also showed elevated fraud risk (9.75% vs. 3.58%),
while night-time transactions had a moderately higher rate (5.27% vs. 3.12%). These 
indicators could be considered as inputs to a transaction risk-monitoring system. */

/*
QUESTION 22:

Rank users based on their observed fraud rate.

Use the transactions and users tables.

Return:
- user_id
- city
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage
- fraud_rank

Requirements:
- Only include users with at least 10 transactions.
- Calculate fraud rate for each user.
- Rank users from highest to lowest fraud rate.
- Use a WINDOW FUNCTION to create fraud_rank.
- Return the top 10 users.

Do not use LIMIT alone to create the ranking.
*/
WITH user_info AS (

    SELECT
        u.user_id,
        u.city,
        COUNT(*) AS total_transactions,
        SUM(t.is_fraud) AS fraudulent_transactions,
        ROUND(
            SUM(t.is_fraud) * 100.0 / COUNT(*),
            2
        ) AS fraud_rate_percentage
    FROM transactions t
    JOIN users u
        ON t.user_id = u.user_id
    GROUP BY u.user_id, u.city

),

ranked_users AS (

    SELECT
        user_id,
        city,
        total_transactions,
        fraudulent_transactions,
        fraud_rate_percentage,
        DENSE_RANK() OVER (
            ORDER BY fraud_rate_percentage DESC
        ) AS fraud_rank
    FROM user_info
    WHERE total_transactions >= 10

)

SELECT *
FROM ranked_users
WHERE fraud_rank <= 10
ORDER BY fraud_rank;

/*A small group of users showed substantially elevated observed fraud rates.
The highest-ranked user had 5 fraudulent transactions out of 15 total transactions
(33.33%), while several other users exceeded 20%. This concentration suggests that
user-level historical transaction behavior could be useful for ongoing fraud monitoring.
*/

/*
QUESTION 23:

Create a simple transaction risk score using these three indicators:

1. new_device_flag = 1       → +1 point
2. ip_location_mismatch = 1   → +1 point
3. is_night_transaction = 1   → +1 point

Create a risk_score from 0 to 3.

Then classify transactions as:

- 0 points → 'Low Risk'
- 1 point  → 'Medium Risk'
- 2 points → 'High Risk'
- 3 points → 'Very High Risk'

Return:
- risk_category
- total_transactions
- fraudulent_transactions
- fraud_rate_percentage
- average_transaction_amount

Use:
- CASE
- aggregation
- GROUP BY
- ORDER BY

Sort from highest fraud rate to lowest.

Use only the transactions table.
*/

WITH risk_scored AS (

    SELECT
        CASE
            WHEN new_device_flag = 1
                 AND ip_location_mismatch = 1
                 AND is_night_transaction = 1
                THEN 'Very High Risk'

            WHEN (new_device_flag + ip_location_mismatch + is_night_transaction) = 2
                THEN 'High Risk'

            WHEN (new_device_flag + ip_location_mismatch + is_night_transaction) = 1
                THEN 'Medium Risk'

            ELSE 'Low Risk'
        END AS risk_category,

        amount,
        is_fraud

    FROM transactions
)

SELECT
    risk_category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraudulent_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage,
    ROUND(AVG(amount), 2) AS average_transaction_amount
FROM risk_scored
GROUP BY risk_category
ORDER BY fraud_rate_percentage DESC;

/*A combined risk score based on new-device usage, IP-location mismatch, and night-time 
activity showed a clear increase in observed fraud rates as risk signals accumulated.
Transactions classified as High Risk had a 12.99% fraud rate compared with 2.30% for
Low Risk transactions, indicating that combining multiple behavioral and contextual signals
may improve transaction-risk prioritization.
*/
