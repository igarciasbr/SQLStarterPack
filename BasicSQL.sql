--1. First, we'll build 2 tables (Customer Info and Customer Loans) *Used Claude AI to fill the dataframes
-- Create customer_info table
CREATE TABLE customer_info (
    id INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    city VARCHAR(50),
    email VARCHAR(100)
);

-- Insert sample data into customer_info
INSERT INTO customer_info (id, firstname, lastname, city, email) VALUES
(1, 'John', 'Smith', 'New York', 'john.smith@email.com'),
(2, 'Maria', 'Garcia', 'Miami', 'maria.g@email.com'),
(3, 'Robert', 'Johnson', 'Chicago', 'rob.johnson@email.com'),
(4, 'Sarah', 'Williams', 'Los Angeles', 'sarah.w@email.com'),
(5, 'Michael', 'Brown', 'Houston', 'michael.b@email.com'),
(6, 'Lisa', 'Davis', 'Phoenix', 'lisa.davis@email.com'),
(7, 'James', 'Wilson', 'Philadelphia', 'james.w@email.com'),
(8, 'Jennifer', 'Martinez', 'San Diego', 'jen.martinez@email.com'),
(9, 'David', 'Anderson', 'Dallas', 'david.a@email.com'),
(10, 'Emma', 'Taylor', 'San Francisco', 'emma.t@email.com');

SELECT * FROM customer_info;
-- Create customer_loans table
CREATE TABLE customer_loans (
    id INT,
    loanid VARCHAR(10) PRIMARY KEY,
    balance DECIMAL(10,2),
    rate DECIMAL(4,2),
    term INT,
    FOREIGN KEY (id) REFERENCES customer_info(id)
);

-- Insert sample data into customer_loans
INSERT INTO customer_loans (id, loanid, balance, rate, term) VALUES
(1, 'L001', 25000.00, 5.25, 60),
(2, 'L002', 15000.00, 4.75, 36),
(3, 'L003', 50000.00, 6.00, 120),
(4, 'L004', 30000.00, 5.50, 72),
(5, 'L005', 10000.00, 4.50, 24),
(6, 'L006', 40000.00, 5.75, 84),
(7, 'L007', 20000.00, 5.00, 48),
(8, 'L008', 35000.00, 5.25, 60),
(9, 'L009', 45000.00, 6.25, 96),
(10, 'L010', 12000.00, 4.25, 36);

-- For this exercise, I'm going to remove some records becuase not every customer has a loan with the bank. I'm also going to update some of the loan_ids to hightlight the UPDATE function. 

SELECT * FROM customer_loans;

UPDATE customer_loans SET loanid= 'S123' WHERE loanid="L005";
UPDATE customer_loans SET loanid= 'B726' WHERE loanid="L009";
UPDATE customer_loans SET loanid= 'C301' WHERE loanid="L010";

SELECT * FROM customer_loans;

DELETE FROM customer_loans WHERE id=3;
SELECT * FROM customer_loans;

--2. Progression of Basic queries using above tables. I'm going to use the order of operations the SQL engine uses as a guide.  
-- FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, and finally, LIMIT/OFFSET

-- Select all records from the customer_info table.
SELECT * 
FROM customer_info;  

-- Select first and last name, email from customer_info
SELECT firstname,lastname,email
FROM customer_info;

--Select same but only where city is from Dallas
SELECT firstname,lastname,email
FROM customer_info 
WHERE city = "Dallas";

--Select first, last name, and city where the city starts with the letter "P".
SELECT firstname,lastname,email
FROM customer_info 
WHERE city LIKE "P%";

--Let's target some Refi customers. Let's find which customers have mortgage rates above 5.5%. We're going to need a JOIN here

SELECT 
    ci.firstname,
    ci.lastname,
    cl.rate,
    cl.balance
FROM customer_info ci
JOIN customer_loans cl ON ci.id = cl.id
WHERE cl.rate > 5.5
ORDER BY cl.rate DESC; 

-- Going to add first payment date for all the loans to highlight ALTER TABLE

ALTER TABLE customer_loans
ADD first_payment_date DATE;


UPDATE customer_loans SET first_payment_date= '2022-11-01' WHERE id=1;
UPDATE customer_loans SET first_payment_date= '2024-01-01' WHERE id=2;
UPDATE customer_loans SET first_payment_date= '2024-01-01' WHERE id=3; 
UPDATE customer_loans SET first_payment_date= '2023-12-01' WHERE id=4;
UPDATE customer_loans SET first_payment_date= '2023-11-01' WHERE id=5;
UPDATE customer_loans SET first_payment_date= '2022-06-01' WHERE id=6;
UPDATE customer_loans SET first_payment_date= '2024-05-01' WHERE id=7;
UPDATE customer_loans SET first_payment_date= '2023-05-01' WHERE id=8;
UPDATE customer_loans SET first_payment_date= '2023-02-01' WHERE id=9;
UPDATE customer_loans SET first_payment_date= '2023-07-01' WHERE id=10;

-- Then I realized I need to add loanage to calc the portfolio wala in the next section.

ALTER TABLE customer_loans
  ADD loanage INT;

UPDATE customer_loans SET loanage= 24 WHERE id=1;
UPDATE customer_loans SET loanage= 9 WHERE id=2;
UPDATE customer_loans SET loanage= 9 WHERE id=3;
UPDATE customer_loans SET loanage= 11 WHERE id=4;
UPDATE customer_loans SET loanage= 12 WHERE id=5;
UPDATE customer_loans SET loanage= 28 WHERE id=6;
UPDATE customer_loans SET loanage= 5 WHERE id=7;
UPDATE customer_loans SET loanage= 19 WHERE id=8;
UPDATE customer_loans SET loanage= 20 WHERE id=9;
UPDATE customer_loans SET loanage= 17 WHERE id=10;


--TODO: This section needs debugging. I tried using datediff, datesub and dat add, but something wasn't quite right.
--UPDATE customer_loans
--SET origination_date = DATEADD(month, -1, first_payment_date),
--SET loanage = DATEDIFF(month, GETDATE(), origination_date);


--Let's get into some statistics of our dataset. I want to see the Average Balance, Weighted Avgerage Coupon, and remaining term. (This would be typical of a collateralized loan portfolio)

SELECT 
    AVG(balance) as average_balance,
    ROUND(SUM(rate * balance) / SUM(balance), 4) as WAC,
    ROUND(SUM(loanage * balance) / SUM(balance), 4) as WALA,
FROM customer_loans;

--Next Section located in https://github.com/igarciasbr/SQLStarterPack/blob/main/SQLqueries.sql
