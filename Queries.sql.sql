-- View all customer data
SELECT * FROM customer;

-- View all orders
SELECT * FROM order1;

-- View all products
SELECT * FROM product;

-- View all categories
SELECT * FROM category;

-- View all order items
SELECT * FROM orderitem;

-- View all payments
SELECT * FROM payment;

-- View all reviews
SELECT * FROM review;


-- Join customer and order1 to see which customer placed which order
SELECT 
  customer.CNAME,
  order1.OID
FROM order1
JOIN customer ON customer.CID = order1.CID;


-- Join product with category to see which product belongs to which category
SELECT 
  product.PID,
  category.CANAME
FROM product
JOIN category ON category.CAID = product.CAID;


-- List all products in descending order of Product ID
SELECT * FROM product ORDER BY PID DESC;


-- Get review info along with product name
SELECT 
  review.RID,
  review.RRATING,
  product.PNAME
FROM review
JOIN product ON product.PID = review.PID;


-- Show all order IDs and their total amount
SELECT OID, OAMOUNT FROM ORDER1;


-- Find customers who have never placed an order (right join + null check)
SELECT 
  customer.CID,
  order1.OID
FROM order1
RIGHT JOIN customer ON customer.CID = order1.CID
WHERE order1.OID IS NULL;


-- Find products that have never been ordered (using RIGHT JOIN and null check)
SELECT 
  product.PID,
  order1.OID
FROM orderitem
RIGHT JOIN order1 ON order1.OID = orderitem.OID
RIGHT JOIN product ON product.PID = orderitem.PID
WHERE order1.OID IS NULL;


-- Count of products in each category (❌ incorrect GROUP BY — should group by category ID)
SELECT 
  category.CAID, COUNT(PID)
FROM product
JOIN category ON category.CAID = product.CAID
GROUP BY category.CAID;


-- List all product names
SELECT product.PNAME FROM product;


-- Number of orders by each customer
SELECT 
  customer.CID, 
  COUNT(OID)
FROM order1
JOIN customer ON customer.CID = order1.CID
GROUP BY customer.CID;


-- Show rating info per customer
SELECT 
  customer.CID,
  review.RRATING
FROM review
JOIN customer ON customer.CID = review.CID
WHERE RRATING IS NOT NULL;


-- Products with average rating greater than 4
SELECT 
  product.PNAME, 
  AVG(RRATING)
FROM review
JOIN product ON product.PID = review.PID
GROUP BY product.PID
HAVING AVG(RRATING) > 4;


-- Show first 5 orders
SELECT * FROM order1 LIMIT 5;


-- Show orders with amount greater than 500
SELECT * FROM order1 WHERE OAMOUNT > 500;


-- Show payment methods for each order
SELECT 
  order1.OID,
  payment.PMETHOD
FROM payment
JOIN order1 ON order1.OID = payment.OID;


-- Total amount spent by each customer
SELECT 
  customer.CID,
  customer.CNAME,
  SUM(OAMOUNT)
FROM order1
JOIN customer ON customer.CID = order1.CID
GROUP BY customer.CID;


-- Top 3 customers by total order amount
SELECT 
  customer.CID,
  SUM(OAMOUNT)
FROM order1
JOIN customer ON customer.CID = order1.CID
GROUP BY customer.CID
LIMIT 3;


-- Products never ordered (repeat of earlier query)
SELECT 
  product.PID,
  order1.OID
FROM orderitem
RIGHT JOIN order1 ON order1.OID = orderitem.OID
RIGHT JOIN product ON product.PID = orderitem.PID
WHERE order1.OID IS NULL;


-- Total quantity sold per category
SELECT 
  category.CANAME,
  SUM(QUANTITY)
FROM category
JOIN product ON product.CAID = category.CAID
JOIN orderitem ON product.PID = orderitem.PID
GROUP BY category.CANAME;


-- Average order amount per customer
SELECT
  customer.CID,
  AVG(OAMOUNT)
FROM order1
JOIN customer ON customer.CID = order1.CID
GROUP BY customer.CID;


-- Average rating per product
SELECT
  product.PID,
  AVG(RRATING)
FROM review
JOIN product ON product.PID = review.PID
GROUP BY product.PID;


-- Orders below a certain amount
SELECT * FROM order1 WHERE OAMOUNT < 700;

-- Customers who placed 2 or more orders
SELECT 
  customer.CID,
  customer.CNAME,
  COUNT(order1.OID)
FROM order1
JOIN customer ON order1.CID = customer.CID
GROUP BY order1.CID
HAVING COUNT(order1.OID) >= 2;


-- Add PRICE column to product and update it
ALTER TABLE product ADD PRICE INT;
UPDATE product SET PRICE = 500 WHERE PID = 101;  
UPDATE product SET PRICE = 700 WHERE PID = 102;  


-- Calculate total revenue per product
SELECT
  product.PID,
  product.PNAME,
  SUM(orderitem.QUANTITY * product.PRICE) AS TotalRevenue
FROM orderitem
JOIN product ON product.PID = orderitem.PID
GROUP BY product.PID, product.PNAME;


-- Maximum rating per product and category
SELECT
  category.CAID,
  product.PID,
  MAX(RRATING)
FROM review
JOIN product ON product.PID = review.PID
JOIN category ON category.CAID = product.CAID
GROUP BY product.PID, category.CAID;


-- ✅ Get the most sold product by quantity
SELECT 
  product.PID,
  product.PNAME,
  SUM(orderitem.QUANTITY) AS TotalSold
FROM product
JOIN orderitem ON product.PID = orderitem.PID
GROUP BY product.PID
ORDER BY TotalSold DESC
LIMIT 1;


-- ✅ Use CASE to categorize orders based on amount
SELECT 
  OID,
  OAMOUNT,
  CASE 
    WHEN OAMOUNT > 2000 THEN 'High Value'
    WHEN OAMOUNT BETWEEN 1000 AND 2000 THEN 'Medium Value'
    ELSE 'Low Value'
  END AS OrderCategory
FROM order1;


-- ✅ Find customers who reviewed more than one product
SELECT 
  CID,
  COUNT(RID) AS TotalReviews
FROM review
GROUP BY CID
HAVING COUNT(RID) > 1;


-- ✅ Use subquery to get products with highest average rating
SELECT PNAME
FROM product
WHERE PID IN (
  SELECT PID
  FROM review
  GROUP BY PID
  HAVING AVG(RRATING) = (
    SELECT MAX(avg_rating)
    FROM (
      SELECT AVG(RRATING) AS avg_rating
      FROM review
      GROUP BY PID
    ) AS ratings
  )
);


-- ✅ Use window function to rank products by total revenue
SELECT
  product.PID,
  product.PNAME,
  SUM(orderitem.QUANTITY * product.PRICE) AS Revenue,
  RANK() OVER (ORDER BY SUM(orderitem.QUANTITY * product.PRICE) DESC) AS RevenueRank
FROM product
JOIN orderitem ON product.PID = orderitem.PID
GROUP BY product.PID, product.PNAME;


-- ✅ List all customers and show total amount spent, even if they never ordered
SELECT 
  customer.CID,
  customer.CNAME,
  IFNULL(SUM(order1.OAMOUNT), 0) AS TotalSpent
FROM customer
LEFT JOIN order1 ON customer.CID = order1.CID
GROUP BY customer.CID;


-- ✅ Get the latest order placed by each customer
SELECT 
  customer.CID,
  customer.CNAME,
  MAX(order1.OID) AS LastOrderID
FROM customer
LEFT JOIN order1 ON customer.CID = order1.CID
GROUP BY customer.CID;
