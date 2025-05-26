------------ ONLINE SHOPPING PROJECT ------------

------ CREATE TABLE CUTOMERS -----

CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

------ CREATE TABLE PRODUCTS ------

CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10,2),
    Stock INT
);

------- CREATE TABLE ORDERS -------

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    OrderDate DATE,
    Status VARCHAR(20)
);

------ CREATE TABLE ORDERITEMS -------

CREATE TABLE OrderItems (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    Price DECIMAL(10,2)
);

------- CREATE TABLE PAYMENTS -----

CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    PaymentDate DATE,
    Amount DECIMAL(10,2),
    PaymentMethod VARCHAR(20)
);

------- CREATE TABLE CART --------

CREATE TABLE Cart (
    CartID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT
);

------- CREATE TABLE REVIEWS ---------

CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    ProductID INT REFERENCES Products(ProductID),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT
);

------ 

SELECT * FROM CUSTOMERS;
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERS;
SELECT * FROM ORDERITEMS;
SELECT * FROM PAYMENTS;
SELECT * FROM CART;
SELECT * FROM REVIEWS;

------------------ BASIC QUERIES --------------

-- 1. List all customers

SELECT * FROM CUSTOMERS;

-- 2. Show all products with price and stock

SELECT PRODUCTNAME,PRICE,STOCK FROM PRODUCTS;

-- 3. Find all orders placed by CustomerID 1

SELECT * FROM ORDERS
WHERE CUSTOMERID = 1;

-- 4. List products with stock less than 50

SELECT PRODUCTNAME, STOCK FROM PRODUCTS
WHERE STOCK < 50;

--------------- INTERMEDIATE QUERIES --------------

-- 5. Total number of orders per customer

SELECT CUSTOMERID ,COUNT(*) FROM ORDERS
GROUP BY CUSTOMERID;

-- 6. Average rating for each product

SELECT PRODUCTID, AVG(RATING) FROM REVIEWS
GROUP BY PRODUCTID;

-- 7. Top 5 most expensive products

SELECT PRODUCTNAME,PRICE FROM PRODUCTS 
ORDER BY  PRICE DESC LIMIT 5;

-- 8. Total revenue from each product (based on OrderItems)

SELECT PRODUCTID ,SUM(QUANTITY*PRICE) AS TOTAL_REVENUE
FROM ORDERITEMS 
GROUP BY PRODUCTID
ORDER BY TOTAL_REVENUE DESC;

------------------------ ADVANCED QUERIES ------------------------

-- 9. Customer with the highest total payment

SELECT C.CUSTOMERID,C.FIRSTNAME,C.LASTNAME, SUM(P.AMOUNT)AS TOTAL_PAYMENT
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUSTOMERID = O.CUSTOMERID
JOIN PAYMENTS P 
ON O.ORDERID = P.ORDERID
GROUP BY C.CUSTOMERID,C.FIRSTNAME,C.LASTNAME
ORDER BY TOTAL_PAYMENT DESC LIMIT 1;

-- 10. List all customers who haven’t placed any orders
-- SUB QUERY APPLY --

SELECT DISTINCT CustomerID FROM Orders;

SELECT CUSTOMERID,FIRSTNAME,LASTNAME FROM CUSTOMERS 
WHERE CUSTOMERID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- 11. List all products that have never been orders

SELECT DISTINCT ProductID FROM OrderItems;

SELECT PRODUCTID,PRODUCTNAME FROM PRODUCTS
WHERE PRODUCTID NOT IN (SELECT DISTINCT ProductID FROM OrderItems);

-- 12. Total items in cart per customer

SELECT CUSTOMERID , SUM(QUANTITY) FROM CART
GROUP BY CUSTOMERID;

-- 13. Most reviewed product

SELECT PRODUCTID, COUNT(*) AS TOTALREVIEWS FROM REVIEWS
GROUP BY PRODUCTID 
ORDER BY TOTALREVIEWS DESC
LIMIT 1;

-- 14. Customer-wise product reviews (with names)

SELECT c.FirstName, c.LastName, p.ProductName, r.Rating, r.Comment
FROM Reviews r JOIN Customers c 
ON r.CustomerID = c.CustomerID
JOIN Products p
ON r.ProductID = p.ProductID
ORDER BY r.Rating DESC;

-- 15. List all orders with customer name and order status

SELECT O.ORDERID , C.FIRSTNAME,C.LASTNAME, O.ORDERDATE,O.STATUS
FROM CUSTOMERS C JOIN ORDERS O
ON C.CUSTOMERID = O.CUSTOMERID
ORDER BY O.ORDERDATE DESC;

-- 16. Find products ordered more than 1 time in total

SELECT PRODUCTID ,SUM(QUANTITY) AS TOTALRECORD
FROM ORDERITEMS
GROUP BY PRODUCTID;

-- 17. Top 3 customers who ordered the most items

SELECT O.CUSTOMERID,C.FIRSTNAME,C.LASTNAME ,SUM(OI.QUANTITY) AS TOTAL_ITEMS
FROM ORDERS O JOIN CUSTOMERS C
ON O.CUSTOMERID = C.CUSTOMERID
JOIN ORDERITEMS OI
ON O.ORDERID = OI.ORDERID
GROUP BY O.CUSTOMERID,C.FIRSTNAME,C.LASTNAME
ORDER BY TOTAL_ITEMS DESC
LIMIT 3;

-- 18. List orders with total amount per order

SELECT O.ORDERID,SUM(OI.QUANTITY)AS TOTAL_AMOUNT 
FROM ORDERS O JOIN ORDERITEMS OI
ON O.ORDERID = OI.ORDERID
GROUP BY O.ORDERID ;

-- 19. Show stock status: Out of stock, Low stock (< 10), Enough stock

SELECT PRODUCTNAME, STOCK,
CASE
WHEN STOCK = 0 THEN 'OUT OF STOCK'
WHEN STOCK < 10 THEN 'LOW STOCK'
ELSE 'IN STOCK'
END AS STOCKSTATUS
FROM PRODUCTS;

-- 20. List customers who gave reviews with rating 5

SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName
FROM Reviews r JOIN Customers c 
ON r.CustomerID = c.CustomerID
WHERE r.Rating = 5;


