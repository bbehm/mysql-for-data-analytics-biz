/********** FINAL ASSIGNMENT **********/

/*
** Exercise 1
** Find customer who placed most orders in 2004
*/

SELECT customerNumber, COUNT(*) FROM orders
WHERE year(orderDate) = 2004
GROUP BY customerNumber
ORDER BY COUNT(*) DESC;

/*
** Exercise 2 
** Find customers who most often pay during the weekend
*/

/* First we create a new table with all the info we need in one table */

CREATE TABLE output_table AS
SELECT 
   payments.customerNumber,
   payments.paymentDate,
   customers.customerName
FROM payments
LEFT JOIN customers ON payments.customerNumber=customers.customerNumber;

/*
** From that table we can count the amount of payments done during weekdays and
** select the top two. Note that weekday() function starts from monday=0.
*/

SELECT customerNumber, customerName, COUNT(*) FROM output_table
WHERE weekday(paymentDate) regexp '5|6'
GROUP BY customerNumber, customerName
ORDER BY COUNT(*) DESC LIMIT 0,2;

/*
** Exercise 3
** Which sales representative has collected the most revenue
*/

/*
** First I create the table sales_revenue to get all the info
** I need in one place.
*/

CREATE TABLE sales_revenue AS
SELECT
	payments.amount,
	customers.salesRepEmployeeNumber
FROM payments
LEFT JOIN customers ON payments.customerNumber=customers.customerNumber;

/*
** Then we add up all the amounts with the same salesrep number and check
** which one has the highest amount. Rounded amount to whole numbers for clarity.
*/

SELECT salesRepEmployeeNumber, ROUND(SUM(amount), 0) AS amount
FROM sales_revenue
GROUP BY salesRepEmployeeNumber
ORDER BY amount DESC;

/*
** Exercise 4
** Find the company with highest ratio of cases "closed with relief",
** only companies with more than 30 total cases are considered.
*/

/*
** First, let's create our desired view. I'm taking quite a few interim
** steps, could probably be done a lot smoother :D
*/

CREATE VIEW interim AS
SELECT company, company_response, COUNT(*) AS amount
FROM cfpb_complaints_2500
GROUP BY company, company_response;

CREATE VIEW interim2 AS
SELECT distinct company, COUNT(*) AS total_amount
FROM cfpb_complaints_2500
GROUP BY company
ORDER BY COUNT(*) DESC;

CREATE VIEW final AS
SELECT 
   interim.company,
   interim.amount,
   interim2.total_amount,
   interim.company_response
FROM interim
LEFT JOIN interim2 ON interim.company=interim2.company;

/*
** Final command to get the desired info
*/

SELECT company, amount, total_amount, (amount / total_amount) AS ratio
FROM final
WHERE company_response = 'Closed with relief' AND total_amount > 30
ORDER BY ratio DESC;

/*
** Exercise 5
** Find the company with most issues on Wednesdays regarding loans in a
** state starting with 'A'.
*/

SELECT company, COUNT(*)
FROM cfpb_complaints_2500
WHERE issue LIKE '%loan%' and weekday(Data_received) = 2 and State LIKE 'A%'
GROUP BY company
ORDER BY COUNT(*) DESC;

/*
** Exercise 6
** Calculating mean statusquo for females who voted for  Pinochet from
** different income levels.
*/

/* First we add new column with income level */

ALTER table chile
ADD income_level VARCHAR(15);

UPDATE chile
SET income_level =
CASE
WHEN chile.income < 10000 then "low_income"
WHEN chile.income > 100000 then "high_income"
ELSE "middle_income"
END;

/* Then we create a view with only females who voted yes */

CREATE VIEW info AS
SELECT income_level, statusquo
FROM chile
WHERE sex = 'F' and vote = 'Y'
GROUP BY income_level, statusquo
ORDER BY income_level;

/* Finally calculating average for each income level */

SELECT income_level, ROUND(AVG(statusquo), 3) AS mean_statusquo
FROM info
GROUP BY income_level
ORDER BY mean_statusquo DESC;

/*
** Exercise 7
*/

SELECT company, COUNT(*) as frequency
FROM cfpb_complaints_2500
WHERE Consumer_disputed = 'Yes'
AND weekday(Data_received) = 4
AND DATEDIFF(Data_sent_to_company, Data_received) > 5
GROUP BY company
ORDER BY frequency DESC;