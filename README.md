# UPI Transaction Fraud Analysis

## 📌 Project Overview

This project focuses on analyzing UPI transaction data to identify fraud patterns, transactions behavior, and potential risk indicators.

The project uses **Python, Pandas, and PostgreSQL** to perform data cleaning, exploratory data analysis, database management, and SQL-based fraud analysis.

The analysis covers **20,000 UPI transactions** and identifies key transactions, users, and behavioral characteristics associated with higher observed fraud rates.

---

## 🛠️ Tools & Technologies

- Python
- Pandas
- NumPy
- PostgreSQL
- SQL
- Jupyter Notebook
- Matplotlib
- Seaborn
- Git and GitHub

---

## 📂 Datasets

The project contains four main datasets:

- `transactions.csv`
- `users.csv`
- `merchants.csv`
- `fraud_labels.csv`

A `data_dictionary.csv` file is also included to describe the dataset columns and their meanings.

---

## 🔍 Project Workflow

```text
Raw Data
    ↓
Data Cleaning & Validation
    ↓
Exploratory Data Analysis
    ↓
Python / Pandas Analysis
    ↓
PostgreSQL Database
    ↓
SQL Analysis
    ↓
Fraud & Risk Analysis
    ↓
Business Insights & Recommendations
```

---

## 📊 Dataset Overview

| Dataset | Records |
|---|---:|
| Users | 2,000 |
| Merchants | 400 |
| Transactions | 20,000 |
| Fraud Labels | 20,000 |

### Overall Fraud Statistics

- **Total transactions:** 20,000
- **Fraudulent transactions:** 763
- **Non-fraudulent transactions:** 19,237
- **Overall observed fraud rate:** 3.82%

---

## 🐍 Python / Pandas Analysis

The Python analysis included:

- Loading and exploring datasets
- Checking data types
- Checking duplicate records
- Missing-value analysis
- Data validation
- Transaction distribution analysis
- Fraud vs non-fraud comparison
- Group-by analysis
- Behavioral pattern analysis

### Fraud Analysis Dimensions

Fraud was analyzed across:

- Transaction type
- Payment application
- Device type
- Transaction status
- Hour and day
- KYC status
- City tier
- New device activity
- IP location mismatch
- Failed transaction attempts
- Transaction velocity
- Amount deviation

---

## 🐘 PostgreSQL & SQL Analysis

The cleaned data was imported into PostgreSQL for relational analysis.

### Database Work

- Created relational tables
- Defined primary keys
- Defined foreign keys
- Imported project datasets
- Validated imported record counts
- Established relationships between users, transactions, merchants, and fraud labels

### SQL Techniques Used

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- Aggregate functions
- `INNER JOIN`
- `COUNT(DISTINCT)`
- `CASE` statements
- CTEs
- Window functions
- Fraud-rate calculations
- Risk segmentation

---

# 🚨 Key Findings

## 1. New Device Transactions

Transactions involving a new device had an observed fraud rate of:

**12.35%**

Compared with:

**3.22%** for transactions without a new-device flag.

This represents approximately a **3.8× higher observed fraud rate**.

### 💡 Insight

New-device activity appears to be an important potential risk indicator and could be considered when prioritizing transactions for additional verification.

---

## 2. IP Location Mismatch

Transactions with an IP-location mismatch showed an observed fraud rate of:

**9.75%**

Compared with:

**3.58%** when no mismatch was present.

This represents approximately a **2.7× higher observed fraud rate**.

### 💡 Insight

An unexpected IP location may provide an additional signal for identifying potentially suspicious transactions.

---

## 3. Night-Time Transactions

Night-time transactions showed an observed fraud rate of:

**5.27%**

Compared with:

**3.12%** for non-night transactions.

This represents approximately a **1.7× higher observed fraud rate** during night-time transactions.

### 💡 Insight

Transaction timing can be considered as an additional contextual risk signal, particularly when combined with other suspicious indicators.

---

## 4. Failed Attempts & Transaction Velocity

Transactions with both high failed attempts and high transaction velocity showed an observed fraud rate of:

**9.74%**

Compared with:

**2.95%** for transactions with neither signal.

This represents approximately a **3.3× higher observed fraud rate**.

### 💡 Insight

A combination of repeated failed attempts and unusually high transaction activity may indicate elevated transaction risk.

---

## 5. KYC Status & Device

Non-verified users showed higher observed fraud rates across all analyzed device types.

| Device | Verified | Not Verified |
|---|---:|---:|
| Android | 3.56% | **5.51%** |
| iOS | 3.32% | **6.05%** |
| Web | 3.85% | **6.05%** |

### 💡 Insight

KYC status appears to be an important potential risk indicator across different device types.

---

## 6. Combined Risk Scoring

A simple **rule-based risk score** was developed using:

- New device
- IP location mismatch
- Night-time transaction

The resulting observed fraud rates were:

| Risk Category | Observed Fraud Rate |
|---|---:|
| Low Risk | **2.30%** |
| Medium Risk | **5.47%** |
| High Risk | **12.99%** |
| Very High Risk* | **25.00%** |

> **Note:** The Very High Risk category contained only 8 transactions and should therefore be interpreted cautiously.

High-risk transactions had approximately **5.6× the observed fraud rate of low-risk transactions**.

### 💡 Insight

The increase from **2.30% → 5.47% → 12.99%** shows a clear relationship between the number of risk signals and observed fraud rate in this dataset.

---

## 7. User-Level Fraud Patterns

The analysis identified a small group of users with repeated fraudulent transactions.

The highest observed case had:

**5 fraudulent transactions out of 15 total transactions**

Resulting in an observed fraud rate of:

**33.33%**

### 💡 Insight

Users showing repeated suspicious activity could be prioritized for additional monitoring or investigation.

A high observed fraud rate does not by itself prove intentional fraudulent behavior.

---

## 8. Geographic Fraud Variation

Among cities with at least 100 transactions, the highest observed fraud rates included:

| City | Observed Fraud Rate |
|---|---:|
| Guwahati | **5.62%** |
| Ranchi | 5.42% |
| Solapur | 5.22% |
| Amritsar | 5.12% |
| Ahmedabad | 5.05% |

### 💡 Insight

Fraud patterns varied across geographic locations in the dataset, suggesting that location can be considered as an additional analytical dimension.

---

# 💡 Business Insights

The analysis suggests that fraud risk is not evenly distributed across all transactions.

Several behavioral and contextual indicators were associated with higher observed fraud rates, particularly:

- New device activity
- IP location mismatch
- High transaction velocity
- Multiple failed attempts
- Night-time activity
- Non-verified KYC status
- Combination of multiple risk signals

Combining multiple indicators appears useful for prioritizing transactions for additional monitoring.

---

# 🎯 Business Recommendations

Based on the analysis, a payment platform could consider:

### 1. Risk-Based Monitoring

Prioritize transactions based on the number and severity of potential risk signals.

### 2. Additional Authentication

Transactions involving multiple risk indicators could trigger additional verification.

### 3. New Device Monitoring

Transactions from previously unseen devices could receive additional scrutiny.

### 4. IP Mismatch Monitoring

Unexpected IP-location changes could be incorporated into transaction risk evaluation.

### 5. Behavioral Monitoring

High transaction velocity and repeated failed attempts could be used as additional behavioral signals.

### 6. Repeated Activity Monitoring

Users with repeated suspicious transactions could be prioritized for further investigation.

### 7. Multi-Signal Risk Evaluation

Fraud monitoring should consider multiple transaction, user, and behavioral indicators rather than relying on a single signal.

---

# ⚠️ Project Limitations

- The analysis is based on a dataset of **20,000 transactions**.
- Some behavioral variables contain missing values.
- The risk score is **rule-based** and is not a machine-learning model.
- Observed relationships do not establish causation.
- Some high fraud-rate groups have relatively small sample sizes.
- The findings should not be directly generalized to real-world UPI transactions without additional data.

---

# 📁 Project Structure

```text
UPI Transaction Fraud Analysis/
│
├── LICENSE
├── README.md
├── UPI Transaction Fraud Analysis.docx
├── UPI_Transaction_Insight.ipynb
├── fraud_labels.csv
├── merchants.csv
├── transactions.csv
├── upi_fraud_analysis.sql
├── users.csv
└── data_dictionary.csv
```

---

# 📈 Project Outcome

Developed an **end-to-end UPI fraud analytics project** using Python, Pandas, PostgreSQL, and SQL to clean and analyze transaction data, identify fraud patterns, evaluate potential risk indicators, and generate business-focused insights.

The project analyzed **20,000 UPI transactions** and identified multiple potential fraud indicators, including:

- New-device activity
- IP-location mismatch
- Transaction velocity
- Failed attempts
- Night-time activity
- KYC status

A rule-based risk scoring approach combining multiple transaction risk signals showed a clear increase in observed fraud rates across risk levels.

The project demonstrates practical skills in:

- Data cleaning
- Exploratory data analysis
- Python / Pandas
- SQL
- PostgreSQL
- Relational database analysis
- Risk segmentation
- Business insight generation

---

# 🧠 Skills Demonstrated

### Python

- Pandas
- NumPy
- Data cleaning
- Exploratory data analysis

### SQL

- Joins
- Aggregations
- CTEs
- CASE statements
- Window functions
- Filtering
- Analytical queries

### Database

- PostgreSQL
- Relational database design
- Primary keys
- Foreign keys

### Data Analytics

- Fraud analysis
- Risk indicator analysis
- Segmentation
- Pattern identification
- Business insights
- Data-driven recommendations

---

# ✅ Project Status

**Completed**

The project includes:

- Python/Pandas data analysis
- Data validation
- PostgreSQL database setup
- SQL-based fraud analysis
- Risk indicator analysis
- Rule-based risk scoring
- Business insights
- Business recommendations
- Detailed project report

---

# 👨‍💻 Author

**Ratan Kumar**

**Aspiring Data Analyst**

**Skills:** Python | Pandas | SQL | PostgreSQL | Data Analysis

---

# 📌 Note

The fraud rates and findings presented in this project represent patterns observed within the provided dataset.

They should be interpreted as **analytical associations and potential risk indicators**, not as evidence of causation or production-ready fraud detection rules.
