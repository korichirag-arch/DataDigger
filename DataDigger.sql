create database DataDigger
use DataDigger;

-- ============================================================
-- TABLE 1: Customers
-- ============================================================
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY identity(1,1),
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    Address VARCHAR(255)
);


-- ============================================================
-- TABLE 2: Products
-- ============================================================
CREATE TABLE Products (
    ProductID INT PRIMARY KEY identity(1,1),
    ProductName VARCHAR(150) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT DEFAULT 0
);

-- ============================================================
-- TABLE 3: Orders
-- ============================================================
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY identity(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- TABLE 4: OrderDetails
-- ============================================================
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY identity(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    SubTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ============================================================
-- INSERT: Customers (5 sample records)
-- ============================================================
INSERT INTO Customers (Name, Email, Address) VALUES
('Alice Johnson', 'alice.johnson@email.com', '123 Maple Street, Mumbai, MH 400001'),
('Bob Smith', 'bob.smith@email.com', '456 Oak Avenue, Delhi, DL 110001'),
('Charlie Brown', 'charlie.brown@email.com', '789 Pine Road, Bangalore, KA 560001'),
('Diana Prince', 'diana.prince@email.com', '321 Cedar Lane, Chennai, TN 600001'),
('Ethan Hunt', 'ethan.hunt@email.com', '654 Birch Drive, Kolkata, WB 700001');

-- ============================================================
-- INSERT: Products (5 sample records)
-- ============================================================
INSERT INTO Products (ProductName, Price, Stock) VALUES
('Wireless Mouse', 799.00, 50),
('Mechanical Keyboard', 2499.00, 30),
('USB-C Hub', 1299.00, 0),
('Laptop Stand', 899.00, 75),
('Webcam HD', 1899.00, 20);

-- ============================================================
-- INSERT: Orders (5 sample records)
-- ============================================================
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, DATEADD(DAY, -5, GETDATE()), 799.00),
(2, DATEADD(DAY, -15, GETDATE()), 2499.00),
(3, DATEADD(DAY, -25, GETDATE()), 2198.00),
(1, DATEADD(DAY, -40, GETDATE()), 899.00),
(4, DATEADD(DAY, -10, GETDATE()), 1899.00);
-- ============================================================
-- INSERT: OrderDetails (5 sample records)
-- ============================================================
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, SubTotal) VALUES
(1, 1, 1, 799.00),
(2, 2, 1, 2499.00),
(3, 1, 2, 1598.00),
(3, 4, 1, 600.00),
(5, 5, 1, 1899.00);

-- ============================================================
-- SECTION A: CUSTOMERS TABLE QUERIES
-- ============================================================

-- A1: Retrieve all customer details
SELECT * FROM Customers;

-- A2: Update a customer's address (CustomerID = 2)
UPDATE Customers
SET Address = '999 New Street, Gurgaon, HR 122001'
WHERE CustomerID = 2;

-- Verify the update
SELECT * FROM Customers WHERE CustomerID = 2;

-- A3: Delete a customer using their CustomerID (CustomerID = 5)
-- Note: ON DELETE CASCADE will also remove their orders
DELETE FROM Customers WHERE CustomerID = 5;

-- Verify the deletion
SELECT * FROM Customers;

-- A4: Display all customers whose name is 'Alice'
SELECT * FROM Customers WHERE Name = 'Alice Johnson';

-- Alternative: Using LIKE for partial match
SELECT * FROM Customers WHERE Name LIKE '%Alice%';


-- ============================================================
-- SECTION B: ORDERS TABLE QUERIES
-- ============================================================

-- B1: Retrieve all orders
SELECT * FROM Orders;

-- B2: Retrieve all orders made by a specific customer (CustomerID = 1)
SELECT * FROM Orders WHERE CustomerID = 1;

-- B3: Update an order's total amount (OrderID = 1)
UPDATE Orders
SET TotalAmount = 899.00
WHERE OrderID = 1;

-- Verify the update
SELECT * FROM Orders WHERE OrderID = 1;

-- B4: Delete an order using its OrderID (OrderID = 4)
DELETE FROM Orders WHERE OrderID = 4;

-- Verify the deletion
SELECT * FROM Orders;

-- B5: Retrieve orders placed in the last 30 days
SELECT * FROM Orders
WHERE OrderDate >= DATEADD(DAY, -30, GETDATE());

-- B6: Retrieve highest, lowest, and average order amount
SELECT
    MAX(TotalAmount) AS HighestOrderAmount,
    MIN(TotalAmount) AS LowestOrderAmount,
    ROUND(AVG(TotalAmount), 2) AS AverageOrderAmount
FROM Orders;


-- ============================================================
-- SECTION C: PRODUCTS TABLE QUERIES
-- ============================================================

-- C1: Retrieve all products
SELECT * FROM Products;

-- C2: Retrieve all products sorted by price in descending order
SELECT * FROM Products ORDER BY Price DESC;

-- C3: Update the price of a specific product (ProductID = 1)
UPDATE Products
SET Price = 849.00
WHERE ProductID = 1;

-- Verify the update
SELECT * FROM Products WHERE ProductID = 1;

-- C4: Delete a product if it's out of stock
DELETE FROM Products WHERE Stock = 0;

-- Verify the deletion
SELECT * FROM Products;

-- C5: Retrieve products whose price is between ₹500 and ₹2000
SELECT * FROM Products
WHERE Price BETWEEN 500 AND 2000;

-- C6: Retrieve the most expensive and cheapest product using MAX() and MIN()
SELECT
    MAX(Price) AS MostExpensivePrice,
    MIN(Price) AS CheapestPrice
FROM Products;

-- Detailed view of most expensive and cheapest products
SELECT * FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products)
   OR Price = (SELECT MIN(Price) FROM Products);


-- ============================================================
-- SECTION D: ORDERDETAILS TABLE QUERIES
-- ============================================================

-- D1: Retrieve all order details
SELECT * FROM OrderDetails;

-- D2: Retrieve all order details for a specific order (OrderID = 3)
SELECT * FROM OrderDetails WHERE OrderID = 3;

-- D3: Calculate total revenue generated from all orders using SUM()
SELECT SUM(SubTotal) AS TotalRevenue FROM OrderDetails;

-- Alternative: From Orders table
SELECT SUM(TotalAmount) AS TotalRevenue FROM Orders;

-- D4: Retrieve the top 3 most ordered products
SELECT TOP 3
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantityOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantityOrdered DESC;

-- D5: Count how many times a specific product has been sold (ProductID = 1)
SELECT
    p.ProductID,
    p.ProductName,
    COUNT(od.OrderDetailID) AS TimesSold,
    SUM(od.Quantity) AS TotalUnitsSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductID = 1
GROUP BY p.ProductID, p.ProductName;
