--First we're going to do an inner join, also known just as a JOIN. This will return all matching columns.

SELECT ci.lastname, ci.city, cl.loanid, cl.balance
FROM customer_info ci
JOIN customer_loans cl on ci.id = cl.id
GROUP BY balance
ORDER BY lastname ASC
;

--With a left join it will return all items from the left table, even if there is a null in the right table. We know there's a null for reported income in the borrower_credit_info. 
--In this example we want to find any loans with missing reported income, and the outstanding balance. Then to find the customer name and email.

SELECT DISTINCT(bci.loanid), cl.id, balance, reported_income, credit_score 
FROM customer_loans cl
LEFT JOIN borrower_credit_info bci ON cl.loanid = bci.loanid
ORDER BY reported_income DESC;  --This puts the null values at the top. We can also use a WHERE reported_income = null, but then we don't can't see the other records.

--We can use that last query as a subquery, but then we lose the context.
SELECT 
	ci.lastname, ci.email, ci.id
FROM customer_info ci
WHERE ci.id = 
     (SELECT DISTINCT(cl.id) 
      FROM customer_loans cl
      LEFT JOIN borrower_credit_info bci ON cl.loanid = bci.loanid
      WHERE reported_income IS null)
	  ; 
--To find the user name, now we just need to join the table with the user name on the id in both the id and loan in the customer loans table. 
-- Small adjustment to the table so that we can add a field for full name. 
ALTER TABLE customer_info
ADD full_name varchar(50);

UPDATE customer_info SET full_name = CONCAT(firstname, ' ',lastname);

SELECT * FROM customer_info;

--Now we have a full_name field, let's run it using two joins concurrently

SELECT DISTINCT(cl.loanid), ci.id, ci.full_name, ci.email, bci.reported_income as missing_reported_income
FROM customer_info ci
JOIN customer_loans cl ON ci.id = cl.id
LEFT JOIN borrower_credit_info  bci ON cl.loanid = bci.loanid
WHERE bci.reported_income IS NULL;

--See missing reported income in tables directory 


