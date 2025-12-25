## Credit Card Financial Dashboard

Unmanageable data → clean metrics → business insight → automation

This project turns raw, hard‑to‑use credit card and customer CSV exports into a clean, modeled dataset and an interactive Power BI dashboard for financial and customer analytics.

---

## 1. Problem Statement

Banks and financial institutions often have:
- Large, flat CSV dumps of transactions and customer profiles.
- Inconsistent data types (dates as text, numeric values as strings, mixed codes like "yes/no", "0/1").
- No unified view that combines spend, fees, balances, risk and customer attributes.

This makes it hard to answer questions such as:
- Which customer segments generate the most revenue and fee income?
- How do utilization, balances, and delinquency trend over time?
- Which products (card categories, expense types) are driving profitability?

The goal of this project is to clean and model the data so that these questions can be answered through a self‑service Power BI dashboard and automated refresh.

---

## 2. Data Sources (Raw Files)

The project currently contains five CSV files and one SQL script:

- `credit_card.csv`
	- Weekly credit card metrics at customer level.
	- Key columns: `Client_Num`, `Card_Category`, `Annual_Fees`, `Activation_30_Days`, `Customer_Acq_Cost`, `Week_Start_Date`, `Week_Num`, `Qtr`, `current_year`, `Credit_Limit`, `Total_Revolving_Bal`, `Total_Trans_Amt`, `Total_Trans_Ct` (or `Total_Trans_Vol`), `Avg_Utilization_Ratio`, `Use Chip`, `Exp Type`, `Interest_Earned`, `Delinquent_Acc`.
	- Grain: one row per client per week.

- `customer.csv`
	- Customer profile and demographic data.
	- Key columns: `Client_Num`, `Customer_Age`, `Gender`, `Dependent_Count`, `Education_Level`, `Marital_Status`, `state_cd`, `Zipcode`, `Car_Owner`, `House_Owner`, `Personal_loan`, `contact`, `Customer_Job`, `Income`, `Cust_Satisfaction_Score`.
	- Grain: one row per client.

- `cc_add.csv`
	- Additional credit card data for Week‑53 (end‑of‑year extension of the main credit card dataset).
	- Same structure as `credit_card.csv` with `Week_Start_Date` around `31-12-2023` and `Week_Num = 'Week-53'`.

- `cust_add.csv`
	- Additional customer records that complement `customer.csv`.
	- Same column structure as `customer.csv`.

- `SQL Query - Financial Dashboard Data.sql`
	- PostgreSQL DDL and data‑load script.
	- Creates a database `ccdb` and two tables:
		- `cc_detail` for transaction/credit card metrics.
		- `cust_detail` for customer demographics.
	- Uses `COPY` commands to load data from the CSV files into the database, including the additional Week‑53 files.

---

## 3. Data Modeling & Cleaning Approach

### 3.1 Logical Model

- **Fact table**: `cc_detail`
	- Measures: transaction amount, transaction count, interest earned, annual fees, acquisition cost, revolving balances, utilization ratio, delinquency flag.
	- Dimensions embedded: card category, expense type, usage channel (chip/swipe/online), week, quarter, year.

- **Dimension table**: `cust_detail`
	- Attributes: age, gender, dependents, education, marital status, geography, asset ownership (car/house), product ownership (personal loan), contact channel, job, income, satisfaction score.

Both tables are linked by `Client_Num` and designed to support a star‑schema–style model in Power BI.

### 3.2 Data Cleaning Highlights

When loading and preparing the data, the following issues are addressed:
- **Date formats**: `Week_Start_Date` is stored as a proper `DATE` column in PostgreSQL (fixing text dates and datestyle issues noted in the SQL script).
- **Numeric types**: credit limits, balances, amounts, counts and ratios are cast to numeric/decimal types for accurate aggregation.
- **Categorical normalization**: values like `yes/no`, `0/1`, `Chip/Swipe/Online` are treated as consistent categories for segmentation.
- **Incremental data**: Week‑53 data (`cc_add.csv`, `cust_add.csv`) is appended using the same schema, keeping the model extensible over time.

This transformation takes the data from scattered CSVs to a well‑typed, queryable model ready for BI.

---

## 4. Business Insights Enabled

With the cleaned and modeled data feeding a Power BI report, you can build visuals and KPIs such as:

- **Revenue & Profitability**
	- Total transaction amount and volume by card category, expense type, and channel.
	- Interest earned and annual fees by segment.

- **Risk & Utilization**
	- Utilization ratio distribution across customers and card products.
	- Delinquent accounts by income band, age group, and geography.

- **Customer Segmentation**
	- High‑value customers by income, spend, and satisfaction score.
	- Cross‑sell opportunities using ownership flags (car, house, personal loan).

- **Time Trends**
	- Weekly and quarterly trends in spend, balances, and delinquency.
	- Impact of Week‑53 (year‑end) on portfolio metrics.

These insights help stakeholders move from raw data dumps to actionable decisions around pricing, risk, and marketing.

---

## 5. Technology Stack & Solution Flow

### 5.1 Technologies Used

- **Data storage & modeling**: PostgreSQL (database `ccdb`).
- **Data ingestion**: PostgreSQL `COPY` from CSV files.
- **Analytics & visualization**: Microsoft Power BI (dashboard built on top of `cc_detail` and `cust_detail`).

### 5.2 End‑to‑End Flow

1. **Unmanageable data (CSV exports)**
	 - Source files: `credit_card.csv`, `customer.csv` plus incremental `cc_add.csv`, `cust_add.csv`.
	 - Data is flat, untyped, and not joinable out‑of‑the‑box.

2. **Clean metrics (PostgreSQL model)**
	 - Run the SQL script to create `ccdb`, `cc_detail`, and `cust_detail`.
	 - Load all CSV files using `COPY` to enforce types and constraints.

3. **Business insight (Power BI dashboard)**
	 - Connect Power BI to PostgreSQL `ccdb`.
	 - Create relationships on `Client_Num` and build measures/KPIs.
	 - Design visuals for revenue, utilization, delinquency, and segmentation.

4. **Automation (refresh & extensibility)**
	 - Additional periods or customers can be added via new CSVs following the same schema.
	 - Scheduled refresh in Power BI (or a database job) can keep the dashboard up to date without manual intervention.

---

## 6. How to Run

1. **Set up PostgreSQL**
	 - Create a PostgreSQL instance and ensure you have permissions to create databases and run `COPY` from CSV files.

2. **Update file paths in the SQL script**
	 - In `SQL Query - Financial Dashboard Data.sql`, adjust the `COPY` commands to point to the correct absolute paths of your CSV files on your machine.

3. **Execute the SQL script**
	 - Run the script in a PostgreSQL client (e.g., psql, PgAdmin) to:
		 - Create database `ccdb`.
		 - Create tables `cc_detail` and `cust_detail`.
		 - Load all base and additional CSV files.

4. **Connect Power BI**
	 - In Power BI Desktop, connect to the PostgreSQL database `ccdb`.
	 - Import `cc_detail` and `cust_detail` and define the relationship on `Client_Num`.
	 - Create report pages, visuals, and measures as needed.

---

## 7. Possible Extensions

- Add more time periods or other product lines (e.g., loans, mortgages) using the same modeling approach.
- Introduce a dedicated date dimension table for richer time intelligence in Power BI.
- Implement role‑level security in Power BI based on geography or segment.
- Automate the CSV load with ETL/ELT tools (e.g., scheduled scripts or pipelines) instead of manual `COPY`.

This README documents how the project turns unstructured, unmanageable files into a robust data model and BI layer that produces repeatable, automated financial insights.
