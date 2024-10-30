--This is the continuation of the sql starterpack series. I'm going to use the data set I built in the Basicsql.sql file. 
--Last we left off we have two tables, customer_info and customer_loans.

SELECT * FROM customer_info;
SELECT * FROM customer_loans;

--Let's find some insights in our loan portfolio:
--1. AVG Balance, WAC, and WALA 
SELECT 
    ROUND(AVG(balance), 2) as average_balance,
    ROUND(SUM(rate * balance) / SUM(balance), 4) as WAC,
    ROUND(SUM(loanage * balance) / SUM(balance), 4) as WALA
FROM customer_loans;

-- Next, we will find who holds the top 3 the loans with the highest rate and how that compares to the WAC of the portfolio. 
SELECT 
    ci.firstname,
    ci.lastname,
    cl.balance,
    cl.rate
FROM customer_loans cl
JOIN customer_info ci ON cl.id = ci.id
ORDER BY cl.rate DESC
LIMIT 3;

--I didn't like the limit 3 because there could be more than just 3 loans with the highest rate. So I decided I wanted to see all the rates compared to the the portfolio wac
--Using our portfolio avg select as a CTE. 
WITH portavgs AS (
   SELECT 
    ROUND(AVG(balance), 2) as average_balance,
    ROUND(SUM(rate * balance) / SUM(balance), 4) as WAC,
    ROUND(SUM(loanage * balance) / SUM(balance), 4) as WALA
   FROM customer_loans;
SELECT 
    ci.firstname,
    ci.lastname,
    cl.balance,
    cl.rate,
    portavgs.WAC
FROM customer_loans cl
JOIN customer_info ci ON cl.id = ci.id
CROSS JOIN portavgs  
ORDER BY rate DESC

--This is great, but that WAC column looks repetitive. Let's use the CASE function and compare balance as well. 

WITH portavgs AS (
   SELECT 
    ROUND(AVG(balance), 2) as average_balance,
    ROUND(SUM(rate * balance) / SUM(balance), 4) as WAC,
    ROUND(SUM(loanage * balance) / SUM(balance), 4) as WALA
   FROM customer_loans)
SELECT 
    ci.firstname,
    ci.lastname,
    cl.balance,
    cl.rate,
    CASE 
        WHEN cl.rate > portavgs.WAC THEN 'Rate ABOVE portfolio WAC'
        WHEN cl.rate < portavgs.WAC THEN 'Rate BELOW portfoio WAC'
        ELSE 'Meets Average'
    END AS rate_comparison
    CASE 
        WHEN cl.balance > portavgs.average_balance THEN 'Balance ABOVE portfolio AVG'
        WHEN cl.balance < portavgs.average_balance THEN 'Balance BELOW portfoio AVG'
        ELSE 'Average Balance'
    END AS balance_comparison
FROM customer_loans cl
JOIN customer_info ci ON cl.id = ci.id
CROSS JOIN portavgs  
ORDER BY rate DESC

-- For the purpose of this exercise and to do some Join and Subquery work We're going to build a new table called borrower_credi_info. It will include credit score and some liabilities. 

CREATE TABLE borrower_credit_info (
    loanid VARCHAR(10) PRIMARY KEY,
    total_liabilities DECIMAL(10,2),
    credit_score INT(),
    FOREIGN KEY (id) REFERENCES customer_info(id)
    FOREIGN KEY (loanid) REFERENCES customer_loans(id)
);
