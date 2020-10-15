/* MySQL for string manipulation - using cfp_complaints_2500.sql */

/* complaints for specific dates */

SELECT *
FROM cfpb_complaints_2500
WHERE Data_received IN ('2012-01-01', '2012-02-01', '2012-03-01','2012-04-01','2012-05-01');

/* Issues including "ATM" and "ATM" or "theft" for Bank of America */

SELECT *
FROM cfpb_complaints_2500
WHERE Company = 'Bank of America' AND Issue LIKE '%ATM%';

SELECT *
FROM cfpb_complaints_2500
WHERE Company = 'Bank of America' AND (Issue LIKE '%ATM%' OR Issue LIKE '%theft%');

/* Finding top 3 companies with most complaints regardin ATM */

SELECT Company, COUNT(*) AS freq
FROM cfpb_complaints_2500
WHERE Issue LIKE '%ATM%'
GROUP BY Company
ORDER BY freq DESC
LIMIT 3;

/* Finding all issues with exactly 7 characters */

SELECT *
FROM cfpb_complaints_2500
WHERE Issue like '_______';

/* regexp where issue is loan, savings or credit */

SELECT *
FROM cfpb_complaints_2500
WHERE Issue regexp 'loan|saving|credit';

/* Gives back a list of all companies included in the data */

SELECT distinct Company
FROM cfpb_complaints_2500;

/* All different products and how many times they occur in the data */

SELECT Product, count(*)
FROM cfpb_complaints_2500
GROUP BY Product;

/* Different options of submission and popularity */

SELECT Submitted_via, count(*)
FROM cfpb_complaints_2500
GROUP BY Submitted_via;

/* first and last 5 characters of all issues */

SELECT left(Issue, 5), right(Issue,5)
FROM cfpb_complaints_2500;

/* Last two words of issues */

SELECT SUBSTRING_INDEX(Issue, ' ', -2) AS Issue
FROM cfpb_complaints_2500;

/* selecting issues including fee and replacing fee with cost */

SELECT
REPLACE(Issue, 'fee', 'cost') AS Issue
FROM cfpb_complaints_2500
WHERE Issue LIKE '%fee%';

