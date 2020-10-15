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
** select the top two
*/

SELECT customerNumber, customerName, COUNT(*) FROM output_table
WHERE weekday(paymentDate) regexp '6|7'
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

