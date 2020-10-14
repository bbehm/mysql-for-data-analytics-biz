
/* Creating a database */

CREATE DATABASE IF NOT EXISTS Test;

USE Test;

/* Creating table with columns */

CREATE TABLE countries (COUNTRY_ID varchar(3), COUNTRY_NAME varchar(45), REGION_ID int(10));

/* Copying a table without copying the actual data */

CREATE TABLE dup_countries LIKE countries;

/* Dropping a table */

DROP TABLE dup_countries;

/* Copying a table with data included */

CREATE TABLE dup_countries AS SELECT * FROM countries;

/* Creating a table that doesn't allow for NULL values */

CREATE TABLE countries2 (
	COUNTRY_ID varchar(2) NOT NULL,
	COUNTRY_NAME varchar(40) NOT NULL,
	REGION_ID decimal(10,0) NOT NULL
);

/* Creating tables with specific constraints */

CREATE TABLE countries3 (
	COUNTRY_ID varchar(2),
	COUNTRY_NAME ENUM('Finland', 'Sweden', 'Denmark'),
	REGION_ID decimal(10,0)
);

/* Creating a table and inserting data */

CREATE TABLE memory(Happy_date date, Happy_time time default null);
INSERT INTO memory values (20170112, 111111);
INSERT INTO memory (Happy_date) values (20170113);
INSERT INTO memory values (curdate(), curtime());

/* More table creating */

CREATE TABLE city (
	ID int(11) NOT NULL AUTO_INCREMENT,
	Name char(35) NOT NULL DEFAULT '',
	CountryCode char(3) NOT NULL DEFAULT '',
	District char(20) NOT NULL DEFAULT '',
	Population int(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (ID)
);

CREATE TABLE offices2 (
	officeCode varchar(10) NOT NULL,
	city varchar(50) NOT NULL,
	phone varchar(50) NOT NULL,
	addressLine1 varchar(50) NOT NULL,
	addressLine2 varchar(50) DEFAULT NULL,
	state varchar(50) DEFAULT NULL,
	country varchar(50) NOT NULL,
	postalCode varchar(15) NOT NULL,
	territory varchar(10) NOT NULL,
	PRIMARY KEY (officeCode)
);