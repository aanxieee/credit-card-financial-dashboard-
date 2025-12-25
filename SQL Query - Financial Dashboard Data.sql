-- ye sql file main csv files se data ko database mein laane ke liye queries  hain

-- 0. pehle database create krrre, saara data isi mein aayega
CREATE DATABASE ccdb;

-- 1. ab cc_detail naam ki table banegi (card transaction details ke liye)

CREATE TABLE cc_detail (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(10),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);


-- 2. ab cust_detail naam ki table banega (customer details ke liye)

CREATE TABLE cust_detail (
    Client_Num INT,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_cd VARCHAR(50),
    Zipcode VARCHAR(20),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score INT
);


-- 3. ab csv se data sql mein daalna hai (neeche diye gaye file path ko apne system ke hisaab se change karna padega)

-- pehle cc_detail table mein data copy

COPY cc_detail
FROM 'D:\credit_card.csv' 
DELIMITER ',' 
CSV HEADER;


-- ab cust_detail table mein data copy 

COPY cust_detail
FROM 'D:\customer.csv' 
DELIMITER ',' 
CSV HEADER;

-- neeche wala error aa raha h, toh yeh steps :  
    -- error  date/time field value out of range: "0"
    --   alag "datestyle" setting use 

-- step 1: csv file ka date column check ,  dates sahi format yyyy-mm-dd mein hain ya nahi
--         agar galat ya missing dates hain toh pehle csv file mein hi sahi honi chiayen
--         jaise ki "0" ko sahi date se replace karna hoga wohin pe 
    -- ya phir
-- step 2: datestyle setting change karo, taaki postgres date ko sahi samajh sake:
SET datestyle TO 'ISO, DMY';

-- ab dobara se copy command chala ke csv files load kar ke dekh sakte h!


-- 4. extra data (week-53) bhi sql mein daal rahi, same copy function se

-- pehle cc_detail table mein week-53 ka extra data copy karna 

COPY cc_detail
FROM 'D:\cc_add.csv' 
DELIMITER ',' 
CSV HEADER;


-- ab cust_detail table mein week-53 ka extra customer data copy kar ke  (yahan bhi file path apne system ke hisaab se change karna hoga)

COPY cust_detail
FROM 'D:\cust_add.csv' 
DELIMITER ',' 
CSV HEADER;

