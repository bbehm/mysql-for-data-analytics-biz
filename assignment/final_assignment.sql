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

/*
** Exercise 8
** Which product produces highest revenue?
*/

/*
** The buy and sell prices vary for the same products which makes it a bit more complicated.
** First I create a view where I add a revenue column as the difference between buy and sell price
** and join the columns from two tables based on productCode.
*/

CREATE VIEW info AS
SELECT orderdetails.productCode, products.productName, orderdetails.quantityOrdered, ROUND((priceEach - products.buyPrice),2) AS revenue
FROM orderdetails
LEFT JOIN products ON products.productCode=orderdetails.productCode;

/*
** For the second view I add the total revenue column where I multiply the revenue for a single product with
** the quantity ordered
*/

CREATE VIEW info2 AS
SELECT productName, productCode, revenue, SUM(quantityOrdered) AS quantity, (quantityOrdered * revenue) AS total_revenue FROM info
GROUP BY productName, productCode, revenue, quantityOrdered
ORDER BY productName;

/*
** Finally we sum up the total revenue for data points regarding the same product to get the final amount
*/

SELECT productName, SUM(total_revenue) as total_revenue
FROM info2
GROUP BY productName
ORDER BY total_revenue DESC;

/*
** Exercise 9
*/

/*
** 9.1 Likelihood for customers from  different cuuntries to become
** re-patronage travelers. Re-patronage customers / total customers
*/

/*
** First I create a more manageable view
*/

CREATE VIEW repat AS
SELECT repatronage_review_assignment.user_id, repatronage_user_assignment.country, COUNT(*) as frequency
FROM repatronage_review_assignment
LEFT JOIN repatronage_user_assignment ON repatronage_review_assignment.user_id=repatronage_user_assignment.user_id
GROUP BY user_id, country
ORDER BY frequency DESC;

/*
** Using nested SELECT statements to get the likelihood --> 0,0875
*/

SELECT ((SELECT COUNT(*)
FROM repat
WHERE frequency > 1 and country = 'Denmark') / (SELECT COUNT(*)
FROM repat
WHERE country = 'Denmark'));

/*
** Same for Austria --> 0,0503
*/

SELECT ((SELECT COUNT(*)
FROM repat
WHERE frequency > 1 and country = 'Austria') / (SELECT COUNT(*)
FROM repat
WHERE country = 'Austria'));

/*
** 9.2 Comparing average ratings between first patronage and second patronage
*/

/*
** First I create a table with the first visit data - only taking into
** consideration re-patronage visitors.
*/

CREATE TABLE first_visit_average (SELECT user_id, hotel_id, MIN(review_date)
AS first_visit, COUNT(review_date) AS freq, overall_rating, rooms_rating, service_rating, location_rating, value_rating
FROM repatronage_review_assignment
WHERE user_id IS NOT NULL
GROUP BY user_id, hotel_id, overall_rating, rooms_rating, service_rating, location_rating, value_rating
HAVING freq > 1
ORDER BY freq DESC);

/*
** Then I show the average ratings from all of the reviews in that category
*/

SELECT AVG(overall_rating), AVG(rooms_rating), AVG(service_rating), AVG(location_rating), AVG(value_rating)
FROM first_visit_average;

/*
** Then I create a table for the second visit reviews
*/

CREATE TABLE second_visit_average (SELECT rra.user_id, rra.hotel_id, MIN(rra.review_date) AS second_visit, rra.overall_rating, rra.rooms_rating, rra.location_rating, rra.service_rating, rra.value_rating
FROM repatronage_review_assignment rra, first_visit_average fv
WHERE rra.review_date != fv.first_visit AND rra.user_id = fv.user_id
GROUP BY rra.user_id, rra.hotel_id, rra.overall_rating, rra.rooms_rating, rra.location_rating, rra.service_rating, rra.value_rating);

/*
** and finally showing the average of those
*/

SELECT AVG(overall_rating), AVG(rooms_rating), AVG(service_rating), AVG(location_rating), AVG(value_rating)
FROM second_visit_average;

/*
** 9.3 Which hotel has shorter average time between first and
** second visit?
*/

/*
** Here I use the tables created in question 9.2 with the respective
** samples and use datediff to calculate the average difference
*/

SELECT fva.hotel_id, AVG(DATEDIFF(second_visit, first_visit)) AS average_difference
FROM first_visit_average fva
INNER JOIN second_visit_average sva
ON fva.user_id = sva.user_id
GROUP BY hotel_id;
