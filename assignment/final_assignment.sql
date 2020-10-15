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

