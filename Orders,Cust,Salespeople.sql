create database order_cust_salespeople;
use	order_cust_salespeople;


#######################################################################################
# Q-1) Salespeople Table

CREATE TABLE salespeople (
  snum INT,
  sname VARCHAR(255),
  city VARCHAR(255),
  comm DECIMAL(4,2)
);

INSERT INTO salespeople (snum, sname, city, comm) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres','San Jose',  0.13),
(1003, 'Axelrod', 'New York',0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15),
(NULL, NULL, NULL, NULL);

select * from salespeople;

#######################################################################################
# Q-2) Cust Table

CREATE TABLE cust (
  cnum INT,
  cname VARCHAR(255),
  city VARCHAR(255),
  rating INT,
  snum INT
);

INSERT INTO cust (cnum, cname, city, rating, snum) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007),
(NULL, NULL, NULL, NULL, NULL);


select * from cust;

#######################################################################################
# Q-3) Orders Table

CREATE TABLE orders (
  onum INT,
  amt DECIMAL(8,2),
  odate DATE,
  cnum INT,
  snum INT
);

INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001),
(NULL, NULL, NULL, NULL, NULL);

Select * from orders;

#######################################################################################
# Q-4) Write a query to match the salespeople to the customers according to the city they are living

SELECT c.cname AS "Customer Name", c.city AS "Customer City", s.sname AS "Salesperson Name", s.city AS "Salesperson City"
FROM cust c
JOIN salespeople s ON c.city = s.city;



#######################################################################################
# Q-5) Write a query to select the names of customers and the salespersons who are providing service to them.

SELECT c.cname AS "Customer Name", s.sname AS "Salesperson Name"
FROM cust c
JOIN salespeople s ON c.snum = s.snum;


#######################################################################################
# Q-6) Write a query to find out all orders by customers not located in the same cities as their salespeople.

SELECT o.*
FROM orders o
JOIN cust c ON o.cnum = c.cnum
JOIN salespeople s ON c.snum = s.snum
WHERE c.city <> s.city;




#######################################################################################
# Q-7) Write a query that lists each order number followed by the name of the customer who made that order.

SELECT o.onum AS "Order Number", c.cname AS "Customer Name"
FROM orders o
 left JOIN cust c ON o.cnum = c.cnum;

#######################################################################################
# Q-8) Write a query that finds all pairs of customers having the same rating.

SELECT c1.cname AS "Customer 1", c2.cname AS "Customer 2", c1.rating AS "Rating"
FROM cust c1
JOIN cust c2 ON c1.rating = c2.rating AND c1.cnum < c2.cnum;




#######################################################################################
# Q-9) Write a query to find out all pairs of customers served by a single salesperson.

SELECT c1.cname AS "Customer 1", c2.cname AS "Customer 2", s.sname AS "Salesperson Name"
FROM cust c1
JOIN cust c2 ON c1.snum = c2.snum AND c1.cnum < c2.cnum
JOIN salespeople s ON c1.snum = s.snum;



#######################################################################################
# Q-10) Write a query that produces all pairs of salespeople who are living in the same city.

SELECT s1.sname AS "Salesperson 1", s2.sname AS "Salesperson 2", s1.city AS "City"
FROM salespeople s1
JOIN salespeople s2 ON s1.city = s2.city AND s1.snum < s2.snum;




#######################################################################################
# Q-11) Write a query to find all orders credited to the same salesperson who services Customer 2008.

SELECT o.*
FROM orders o
JOIN cust c ON o.cnum = c.cnum
WHERE c.snum = (SELECT snum FROM cust WHERE cnum = 2008);




#######################################################################################
# Q-12) Write a query to find out all orders that are greater than the average for October 4th

SELECT *
FROM orders
WHERE amt > (SELECT AVG(amt) FROM orders WHERE EXTRACT(MONTH FROM odate) = 10 AND EXTRACT(DAY FROM odate) = 4);


#######################################################################################
# Q-13) Write a query to find all orders attributed to salespeople in London.

SELECT o.*
FROM orders o
JOIN cust c ON o.cnum = c.cnum
JOIN salespeople s ON c.snum = s.snum
WHERE s.city = 'London';



#######################################################################################
# Q-14) Write a query to find all customers whose cnum is 1000 above the snum of Serres.

SELECT c.*
FROM cust c
JOIN salespeople s ON c.snum = s.snum
WHERE c.cnum = s.snum + 1000
  AND s.sname = 'Serres';


#######################################################################################
# Q-15) Write a query to count customers with ratings above San Jose’s average rating

SELECT COUNT(*) AS "Number of Customers"
FROM cust c
JOIN salespeople s ON c.snum = s.snum
WHERE c.rating > (SELECT AVG(rating) FROM cust WHERE city = 'San Jose');




#######################################################################################
# Q-16) Write a query to show each salesperson with multiple customers.

SELECT s.sname AS "Salesperson Name", COUNT(*) AS "Number of Customers"
FROM salespeople s
JOIN cust c ON s.snum = c.snum
GROUP BY s.sname
HAVING COUNT(*) > 1;



