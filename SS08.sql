DROP DATABASE IF EXISTS Sales_Management_System_DB;
CREATE DATABASE Sales_Management_System_DB;
USE Sales_Management_System_DB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    address VARCHAR(255),
    gender TINYINT,
    birthday DATE
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    stock INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Order_Detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    CONSTRAINT fk_detail_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_detail_product FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Customer(full_name, email, phone, address, gender, birthday) VALUES
('Nguyen Van A', 'vana@gmail.com', '0901111111', 'Ha Noi', 1, '2005-05-20'),
('Tran Thi B', 'thib@gmail.com', '0902222222', 'Da Nang', 0, '1998-10-15'),
('Le Van C', 'vanc@gmail.com', '0903333333', 'Ho Chi Minh', 1, '2000-01-01'),
('Pham Thi D', 'thid@gmail.com', '0904444444', 'Can Tho', 0, '2008-12-12'),
('Hoang Van E', 'vane@gmail.com', '0905555555', 'Hai Phong', 1, '1995-03-30'),
('Khach Hang F', 'customerf@gmail.com', '0906666666', 'Ha Noi', 1, '1990-01-01');

INSERT INTO Category(category_name) VALUES
('Laptop'), ('Smartphone'), ('Tablet'), ('Accessory'), ('Electronics');

INSERT INTO Product(product_name, price, stock, category_id) VALUES
('Dell XPS 13', 25000000, 10, 1),
('Macbook Pro M3', 45000000, 5, 1),
('iPhone 15 Pro', 30000000, 15, 2),
('iPad Air 5', 18000000, 12, 3),
('Wireless Mouse', 500000, 50, 4),
('Smart TV Samsung', 12000000, 10, 5);

INSERT INTO Orders(customer_id, order_date, status) VALUES
(1, '2026-05-01', 'Completed'),
(2, '2026-05-02', 'Pending'),
(3, '2026-05-03', 'Completed'),
(4, '2026-05-04', 'Cancelled'),
(5, '2026-05-05', 'Completed');

INSERT INTO Order_Detail(order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 25000000),
(1, 5, 2, 500000),
(2, 3, 1, 30000000),
(3, 4, 1, 18000000),
(5, 6, 1, 12000000);

SET SQL_SAFE_UPDATES = 0;
UPDATE Product SET price = 26000000 WHERE product_id = 1;
UPDATE Customer SET email = 'tranb_new@gmail.com' WHERE customer_id = 2;
DELETE FROM Orders WHERE status = 'Cancelled';
SET SQL_SAFE_UPDATES = 1;

SELECT 
    full_name AS 'Họ Tên', 
    email AS 'Email',
    CASE 
        WHEN gender = 1 THEN 'Nam'
        WHEN gender = 0 THEN 'Nữ'
        ELSE 'Khác'
    END AS 'Giới tính'
FROM Customer;

SELECT 
    full_name, 
    birthday, 
    (YEAR(NOW()) - YEAR(birthday)) AS age
FROM Customer
ORDER BY age ASC
LIMIT 3;

SELECT o.order_id, c.full_name, o.order_date, o.status
FROM Orders o
INNER JOIN Customer c ON o.customer_id = c.customer_id;

SELECT c.category_name, COUNT(p.product_id) AS total_products
FROM Category c
LEFT JOIN Product p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
HAVING total_products >= 2;

SELECT product_name, price
FROM Product
WHERE price > (SELECT AVG(price) FROM Product);

SELECT full_name, email 
FROM Customer
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM Orders);

SELECT cat.category_name, SUM(od.quantity * od.unit_price) AS category_revenue
FROM Category cat
JOIN Product p ON cat.category_id = p.category_id
JOIN Order_Detail od ON p.product_id = od.product_id
GROUP BY cat.category_id, cat.category_name
HAVING category_revenue > (
    SELECT AVG(total_sales) * 1.2 
    FROM (
        SELECT SUM(quantity * unit_price) as total_sales 
        FROM Order_Detail 
        JOIN Product ON Order_Detail.product_id = Product.product_id
        GROUP BY category_id
    ) AS sub
);

SELECT p1.product_name, p1.price, p1.category_id
FROM Product p1
WHERE p1.price = (
    SELECT MAX(p2.price)
    FROM Product p2
    WHERE p2.category_id = p1.category_id
);

SELECT full_name 
FROM Customer 
WHERE customer_id IN (
    SELECT customer_id FROM Orders WHERE order_id IN (
        SELECT order_id FROM Order_Detail WHERE product_id IN (
            SELECT product_id FROM Product WHERE category_id IN (
                SELECT category_id FROM Category WHERE category_name = 'Electronics'
            )
        )
    )
);