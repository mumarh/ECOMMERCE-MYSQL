-- Create the E_COMMERCE database
CREATE DATABASE E_COMMERCE;


-- Select the E_COMMERCE database for use
USE E_COMMERCE;


-- Create 'customer' table to store customer information
CREATE TABLE customer (
  CID INT PRIMARY KEY,              -- Customer ID (Primary Key)
  CNAME VARCHAR(50),                -- Customer Name
  CEMAIL VARCHAR(80)                -- Customer Email
);


-- Create 'category' table to store product categories
CREATE TABLE category (
  CAID INT PRIMARY KEY,             -- Category ID (Primary Key)
  CANAME VARCHAR(50)                -- Category Name
);


-- Create 'order1' table to store orders placed by customers
CREATE TABLE order1 (
  OID INT PRIMARY KEY,              -- Order ID (Primary Key)
  OAMOUNT INT,                      -- Order Amount
  CID INT,                          -- Customer ID (Foreign Key)
  FOREIGN KEY (CID) REFERENCES customer (CID)  -- Link to customer table
);


-- Create 'product' table to store product details
CREATE TABLE product (
  PID INT PRIMARY KEY,             -- Product ID (Primary Key)
  PNAME VARCHAR(50),               -- Product Name
  CAID INT,                        -- Category ID (Foreign Key)
  FOREIGN KEY (CAID) REFERENCES category (CAID)  -- Link to category table
);


-- Create 'payment' table to store payment information
CREATE TABLE payment (
  PAID INT PRIMARY KEY,           -- Payment ID (Primary Key)
  PMETHOD VARCHAR(50),            -- Payment Method
  OID INT,                        -- Order ID (Foreign Key)
  FOREIGN KEY (OID) REFERENCES order1 (OID)  -- Link to order table
);


-- Create 'review' table to store product reviews by customers
CREATE TABLE review (
  RID INT PRIMARY KEY,            -- Review ID (Primary Key)
  CID INT,                        -- Customer ID (Foreign Key)
  PID INT,                        -- Product ID (Foreign Key)
  RRATING INT,                    -- Rating given (assumed scale 1-5)
  FOREIGN KEY (CID) REFERENCES customer (CID),  -- Link to customer
  FOREIGN KEY (PID) REFERENCES product (PID)    -- Link to product
);


-- Create 'orderitem' table to track products in each order
CREATE TABLE orderitem (
  QUANTITY INT,                  -- Quantity of the product
  OID INT,                       -- Order ID (Foreign Key)
  PID INT,                       -- Product ID (Foreign Key)
  FOREIGN KEY (OID) REFERENCES order1 (OID),  -- Link to order
  FOREIGN KEY (PID) REFERENCES product (PID)  -- Link to product
);




-- Insert customer records into 'customer' table
INSERT INTO customer  
VALUES  
(5012, 'Umar Hassan', 'umar@email.com'), 
(5013, 'Ali Hassan', NULL), 
(5014, 'Yaqoob Hassan', NULL),  
(5015, 'Ahmed Hassan', NULL);


-- Insert category records into 'category' table
INSERT INTO category 
VALUES 
(101, 'Electronics'),
(102, 'Clothing');


-- Insert product records into 'product' table
INSERT INTO product 
VALUES 
(101, 'Handsfree', 101),
(102, 'Shirt', 102),
(105, 'Shoes', 102); 


-- Insert order records into 'order1' table
INSERT INTO order1 
VALUES 
(201, 500, 5012),
(202, 700, 5012),
(203, 1200, 5013),
(204, 2500, 5014),
(205, 850, 5015);


-- Insert order item details into 'orderitem' table
INSERT INTO orderitem
VALUES 
(2, 201, 101),  -- 2 Handsfree in order 201
(1, 201, 102);  -- 1 Shirt in order 201


-- Insert payment details into 'payment' table
INSERT INTO payment 
VALUES 
(301, 'Credit Card', 201), 
(302, 'Cash On Delivery', 202);


-- Insert product reviews into 'review' table
INSERT INTO review 
VALUES 
(401, 5012, 101, 5),   -- Umar Hassan rated Handsfree 5
(402, 5013, 102, 3),   -- Ali Hassan rated Shirt 3
(403, 5012, 101, 7),   -- (Note: rating 7 may be outside expected range)
(404, 5013, 102, 5);   -- Ali Hassan rated Shirt 5
