create database Online_Retail_Sales;
use Online_Retail_Sales;

 -- 1.	Create tables for Customers, Products, Orders, and Sales with proper relationships (primary & foreign keys).--
 
 -- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Sales Table
CREATE TABLE Sales (
    sales_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
 
 INSERT INTO Customers (customer_id, customer_name, email, city, country) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York', 'USA'),
(2, 'Bob Smith', 'bob@example.com', 'Los Angeles', 'USA'),
(3, 'Charlie Brown', 'charlie@example.com', 'London', 'UK'),
(4, 'David Lee', 'david@example.com', 'Toronto', 'Canada'),
(5, 'Eva Green', 'eva@example.com', 'Paris', 'France'),
(6, 'Frank Martin', 'frank@example.com', 'Berlin', 'Germany');

INSERT INTO Products (product_id, product_name, category, price) VALUES
(101, 'Laptop', 'Electronics', 800.00),
(102, 'Smartphone', 'Electronics', 600.00),
(103, 'Headphones', 'Accessories', 100.00),
(104, 'Shoes', 'Fashion', 120.00),
(105, 'Backpack', 'Fashion', 80.00),
(106, 'Smartwatch', 'Electronics', 200.00);

INSERT INTO Orders (order_id, customer_id, order_date) VALUES
(1001, 1, '2025-01-05'),
(1002, 2, '2025-01-10'),
(1003, 3, '2025-02-15'),
(1004, 1, '2025-02-20'),
(1005, 4, '2025-03-01'),
(1006, 5, '2025-03-05'),
(1007, 6, '2025-03-20');

INSERT INTO Sales (sales_id, order_id, product_id, quantity) VALUES
(1, 1001, 101, 1),   -- Alice buys 1 Laptop
(2, 1001, 103, 2),   -- Alice buys 2 Headphones
(3, 1002, 102, 1),   -- Bob buys 1 Smartphone
(4, 1002, 104, 1),   -- Bob buys 1 Shoes
(5, 1003, 105, 3),   -- Charlie buys 3 Backpacks
(6, 1004, 101, 1),   -- Alice buys 1 Laptop again
(7, 1005, 106, 2),   -- David buys 2 Smartwatches
(8, 1006, 102, 1),   -- Eva buys 1 Smartphone
(9, 1006, 105, 1),   -- Eva buys 1 Backpack
(10, 1007, 104, 2);  -- Frank buys 2 Shoes

-- 2. SQL Queries --
-- a) Top 5 customers by total spending --

SELECT c.customer_id, c.customer_name, 
       SUM(p.price * s.quantity) AS total_spending
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Sales s ON o.order_id = s.order_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;

-- b) Best-selling products--

SELECT p.product_id, p.product_name, 
       SUM(s.quantity) AS total_sold
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- c) Monthly revenue trend--

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.price * s.quantity) AS monthly_revenue
FROM Orders o
JOIN Sales s ON o.order_id = s.order_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 3. Customers who bought more than 5 products (using GROUP BY + HAVING) -- 

SELECT c.customer_id, c.customer_name, 
       COUNT(DISTINCT s.product_id) AS total_products
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Sales s ON o.order_id = s.order_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT s.product_id) > 5;

-- 4. JOINs to combine order, customer, and product details--

SELECT o.order_id, o.order_date, 
       c.customer_name, p.product_name, 
       s.quantity, (p.price * s.quantity) AS total_price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Sales s ON o.order_id = s.order_id
JOIN Products p ON s.product_id = p.product_id
ORDER BY o.order_date;

-- 5. Create a view for management – Daily Sales Summary --

CREATE VIEW Daily_Sales_Summary AS
SELECT o.order_date, 
       SUM(p.price * s.quantity) AS total_sales,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM Orders o
JOIN Sales s ON o.order_id = s.order_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- To check the view: -- 

SELECT * FROM Daily_Sales_Summary;
