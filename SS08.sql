create database Sales_Management_System_DB;
use Sales_Management_System_DB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    address VARCHAR(255)
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    category_id INT NOT NULL,

    CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES Category(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id)
    REFERENCES Customer(customer_id)
);

CREATE TABLE Order_Detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Customer(full_name, email, phone, address)
VALUES
('Nguyen Van A', 'vana@gmail.com', '0901111111', 'Ha Noi'),
('Tran Thi B', 'thib@gmail.com', '0902222222', 'Da Nang'),
('Le Van C', 'vanc@gmail.com', '0903333333', 'Ho Chi Minh'),
('Pham Thi D', 'thid@gmail.com', '0904444444', 'Can Tho'),
('Hoang Van E', 'vane@gmail.com', '0905555555', 'Hai Phong');

INSERT INTO Category(category_name)
VALUES
('Laptop'),
('Smartphone'),
('Tablet'),
('Accessory'),
('Monitor');

INSERT INTO Product(product_name, price, stock, category_id)
VALUES
('Dell XPS 13', 25000000, 10, 1),
('iPhone 15', 30000000, 15, 2),
('iPad Air', 18000000, 12, 3),
('Wireless Mouse', 500000, 50, 4),
('LG UltraWide', 7000000, 8, 5);

INSERT INTO Orders(customer_id, order_date, status)
VALUES
(1, '2026-05-01', 'Completed'),
(2, '2026-05-02', 'Pending'),
(3, '2026-05-03', 'Completed'),
(4, '2026-05-04', 'Cancelled'),
(5, '2026-05-05', 'Completed');

INSERT INTO Order_Detail(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 25000000),
(1, 4, 2, 500000),
(2, 2, 1, 30000000),
(3, 3, 1, 18000000),
(5, 5, 2, 7000000);