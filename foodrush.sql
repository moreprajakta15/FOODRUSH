
CREATE DATABASE foodrush;

use foodrush;
select database();

-- TABLE CREATION 
-- 5.1 customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    address VARCHAR(255),
    city VARCHAR(50),
    registration_date DATE,
    status ENUM('Active', 'Inactive', 'Blocked') DEFAULT 'Active'
);

-- 5.2 restaurants
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50) NOT NULL,
    cuisine_type VARCHAR(50),
    opening_time TIME,
    closing_time TIME,
    rating DECIMAL(2,1),
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- 5.3 food categories

-- 3. FOOD CATEGORIES
CREATE TABLE food_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);


-- 5.4. MENU ITEMS
CREATE TABLE menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    FOREIGN KEY (category_id)
        REFERENCES food_categories(category_id)
);

-- 5. DELIVERY PARTNERS
CREATE TABLE delivery_partners (
    delivery_partner_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    joining_date DATE,
    vehicle_type VARCHAR(50),
    vehicle_number VARCHAR(30) UNIQUE,

    status ENUM('Available', 'Busy', 'Offline', 'Inactive')
    DEFAULT 'Available'
);

-- 6. ORDERS
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    delivery_partner_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivery_address VARCHAR(255) NOT NULL,

    subtotal DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    discount DECIMAL(10,2) DEFAULT 0,
    tax DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) DEFAULT 0,

    order_status ENUM(
        'Placed',
        'Confirmed',
        'Preparing',
        'Out for Delivery',
        'Delivered',
        'Cancelled',
        'Rejected'
    ) DEFAULT 'Placed',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    FOREIGN KEY (delivery_partner_id)
        REFERENCES delivery_partners(delivery_partner_id)
);
-- 7. ORDER ITEMS
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id)
);
-- 8. PAYMENTS
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    payment_method ENUM(
        'UPI',
        'Credit Card',
        'Debit Card',
        'Cash',
        'Wallet',
        'Net Banking'
    ) NOT NULL,

    amount DECIMAL(10,2) NOT NULL,

    payment_status ENUM(
        'Successful',
        'Pending',
        'Failed',
        'Refunded'
    ) DEFAULT 'Pending',

    transaction_reference VARCHAR(100) UNIQUE,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 9. DELIVERIES
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    delivery_partner_id INT NOT NULL,

    assigned_time DATETIME,
    pickup_time DATETIME,
    delivery_time DATETIME,

    delivery_status ENUM(
        'Assigned',
        'Picked Up',
        'Delivered',
        'Failed',
        'Cancelled'
    ) DEFAULT 'Assigned',

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (delivery_partner_id)
        REFERENCES delivery_partners(delivery_partner_id)
);

-- 10. COUPONS
CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),

    discount_type ENUM('Percentage', 'Flat') NOT NULL,

    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order_amount DECIMAL(10,2) DEFAULT 0,
    maximum_discount DECIMAL(10,2),

    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    status ENUM('Active', 'Inactive', 'Expired')
    DEFAULT 'Active'
);


-- 11. ORDER COUPONS
CREATE TABLE order_coupons (
    order_coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    coupon_id INT NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (coupon_id)
        REFERENCES coupons(coupon_id)
);


-- 12. REVIEWS
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,

    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),

    review_text VARCHAR(500),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);



SHOW TABLES;


-- PART2:INSERT SAMPLE DATA



-- 1. FOOD CATEGORIES: 10 RECORDS
INSERT INTO food_categories (category_name, description) VALUES
('Pizza', 'Different types of pizzas'),
('Burger', 'Veg and non-veg burgers'),
('Indian', 'Traditional Indian food'),
('Chinese', 'Chinese and Indo-Chinese food'),
('Desserts', 'Sweet dishes and desserts'),
('Beverages', 'Cold and hot drinks'),
('South Indian', 'South Indian dishes'),
('Fast Food', 'Quick snacks and fast food'),
('Biryani', 'Veg and non-veg biryani'),
('Italian', 'Italian cuisine and pasta');

-- 2. CUSTOMERS: 50 RECORDS
INSERT INTO customers (first_name, last_name, email, phone, address, city, registration_date, status) VALUES
('Aarav', 'Sharma', 'aarav.sharma1@gmail.com', '9800000000', 'Andheri West', 'Mumbai', '2025-01-01', 'Active'),
('Priya', 'Patil', 'priya.patil2@gmail.com', '9800000001', 'Bandra West', 'Mumbai', '2025-01-05', 'Active'),
('Rohan', 'Mehta', 'rohan.mehta3@gmail.com', '9800000002', 'Dadar', 'Mumbai', '2025-01-09', 'Active'),
('Sneha', 'Kulkarni', 'sneha.kulkarni4@gmail.com', '9800000003', 'Powai', 'Pune', '2025-01-13', 'Active'),
('Rahul', 'Verma', 'rahul.verma5@gmail.com', '9800000004', 'Borivali', 'Pune', '2025-01-17', 'Active'),
('Ananya', 'Gupta', 'ananya.gupta6@gmail.com', '9800000005', 'Chembur', 'Thane', '2025-01-21', 'Active'),
('Vikram', 'Singh', 'vikram.singh7@gmail.com', '9800000006', 'Goregaon', 'Navi Mumbai', '2025-01-25', 'Active'),
('Neha', 'Joshi', 'neha.joshi8@gmail.com', '9800000007', 'Mulund', 'Mumbai', '2025-01-29', 'Active'),
('Aditya', 'Deshmukh', 'aditya.deshmukh9@gmail.com', '9800000008', 'Kothrud', 'Mumbai', '2025-02-02', 'Active'),
('Pooja', 'Shah', 'pooja.shah10@gmail.com', '9800000009', 'Wakad', 'Mumbai', '2025-02-06', 'Active'),
('Karan', 'Malhotra', 'karan.malhotra11@gmail.com', '9800000010', 'Baner', 'Pune', '2025-02-10', 'Active'),
('Isha', 'Nair', 'isha.nair12@gmail.com', '9800000011', 'Hinjewadi', 'Pune', '2025-02-14', 'Active'),
('Siddharth', 'Rao', 'siddharth.rao13@gmail.com', '9800000012', 'Viman Nagar', 'Thane', '2025-02-18', 'Active'),
('Kavya', 'Iyer', 'kavya.iyer14@gmail.com', '9800000013', 'Airoli', 'Navi Mumbai', '2025-02-22', 'Active'),
('Arjun', 'Kapoor', 'arjun.kapoor15@gmail.com', '9800000014', 'Vashi', 'Mumbai', '2025-02-26', 'Active'),
('Meera', 'Jadhav', 'meera.jadhav16@gmail.com', '9800000015', 'Thane West', 'Mumbai', '2025-03-02', 'Active'),
('Yash', 'Bansal', 'yash.bansal17@gmail.com', '9800000016', 'Kalyan', 'Mumbai', '2025-03-06', 'Active'),
('Riya', 'Yadav', 'riya.yadav18@gmail.com', '9800000017', 'Andheri West', 'Pune', '2025-03-10', 'Active'),
('Om', 'Jain', 'om.jain19@gmail.com', '9800000018', 'Bandra West', 'Pune', '2025-03-14', 'Active'),
('Tanvi', 'Khan', 'tanvi.khan20@gmail.com', '9800000019', 'Dadar', 'Thane', '2025-03-18', 'Active'),
('Aditi', 'Chavan', 'aditi.chavan21@gmail.com', '9800000020', 'Powai', 'Navi Mumbai', '2025-03-22', 'Active'),
('Nikhil', 'Shetty', 'nikhil.shetty22@gmail.com', '9800000021', 'Borivali', 'Mumbai', '2025-03-26', 'Active'),
('Sakshi', 'Pawar', 'sakshi.pawar23@gmail.com', '9800000022', 'Chembur', 'Mumbai', '2025-03-30', 'Active'),
('Varun', 'Agrawal', 'varun.agrawal24@gmail.com', '9800000023', 'Goregaon', 'Mumbai', '2025-04-03', 'Active'),
('Simran', 'Naik', 'simran.naik25@gmail.com', '9800000024', 'Mulund', 'Pune', '2025-04-07', 'Active'),
('Akshay', 'More', 'akshay.more26@gmail.com', '9800000025', 'Kothrud', 'Pune', '2025-04-11', 'Active'),
('Divya', 'Sawant', 'divya.sawant27@gmail.com', '9800000026', 'Wakad', 'Thane', '2025-04-15', 'Active'),
('Manav', 'Mishra', 'manav.mishra28@gmail.com', '9800000027', 'Baner', 'Navi Mumbai', '2025-04-19', 'Active'),
('Nisha', 'Pandey', 'nisha.pandey29@gmail.com', '9800000028', 'Hinjewadi', 'Mumbai', '2025-04-23', 'Active'),
('Harsh', 'Bose', 'harsh.bose30@gmail.com', '9800000029', 'Viman Nagar', 'Mumbai', '2025-04-27', 'Active'),
('Ishaan', 'Gawade', 'ishaan.gawade31@gmail.com', '9800000030', 'Airoli', 'Mumbai', '2025-05-01', 'Active'),
('Shreya', 'Thakur', 'shreya.thakur32@gmail.com', '9800000031', 'Vashi', 'Pune', '2025-05-05', 'Active'),
('Atharva', 'Bhagat', 'atharva.bhagat33@gmail.com', '9800000032', 'Thane West', 'Pune', '2025-05-09', 'Active'),
('Madhura', 'Chopra', 'madhura.chopra34@gmail.com', '9800000033', 'Kalyan', 'Thane', '2025-05-13', 'Active'),
('Ritesh', 'Menon', 'ritesh.menon35@gmail.com', '9800000034', 'Andheri West', 'Navi Mumbai', '2025-05-17', 'Active'),
('Komal', 'Shinde', 'komal.shinde36@gmail.com', '9800000035', 'Bandra West', 'Mumbai', '2025-05-21', 'Active'),
('Saurabh', 'Saxena', 'saurabh.saxena37@gmail.com', '9800000036', 'Dadar', 'Mumbai', '2025-05-25', 'Active'),
('Bhavna', 'Das', 'bhavna.das38@gmail.com', '9800000037', 'Powai', 'Mumbai', '2025-05-29', 'Active'),
('Tejas', 'Reddy', 'tejas.reddy39@gmail.com', '9800000038', 'Borivali', 'Pune', '2025-06-02', 'Active'),
('Pallavi', 'Kamble', 'pallavi.kamble40@gmail.com', '9800000039', 'Chembur', 'Pune', '2025-06-06', 'Active'),
('Abhishek', 'Sharma', 'abhishek.sharma41@gmail.com', '9800000040', 'Goregaon', 'Thane', '2025-06-10', 'Active'),
('Mitali', 'Patil', 'mitali.patil42@gmail.com', '9800000041', 'Mulund', 'Navi Mumbai', '2025-06-14', 'Active'),
('Gaurav', 'Mehta', 'gaurav.mehta43@gmail.com', '9800000042', 'Kothrud', 'Mumbai', '2025-06-18', 'Active'),
('Swati', 'Kulkarni', 'swati.kulkarni44@gmail.com', '9800000043', 'Wakad', 'Mumbai', '2025-06-22', 'Inactive'),
('Chirag', 'Verma', 'chirag.verma45@gmail.com', '9800000044', 'Baner', 'Mumbai', '2025-06-26', 'Inactive'),
('Sonali', 'Gupta', 'sonali.gupta46@gmail.com', '9800000045', 'Hinjewadi', 'Pune', '2025-06-30', 'Inactive'),
('Pranav', 'Singh', 'pranav.singh47@gmail.com', '9800000046', 'Viman Nagar', 'Pune', '2025-07-04', 'Inactive'),
('Rutuja', 'Joshi', 'rutuja.joshi48@gmail.com', '9800000047', 'Airoli', 'Thane', '2025-07-08', 'Inactive'),
('Dev', 'Deshmukh', 'dev.deshmukh49@gmail.com', '9800000048', 'Vashi', 'Navi Mumbai', '2025-07-12', 'Blocked'),
('Ayesha', 'Shah', 'ayesha.shah50@gmail.com', '9800000049', 'Thane West', 'Mumbai', '2025-07-16', 'Blocked');

-- 3. RESTAURANTS: 15 RECORDS
INSERT INTO restaurants (restaurant_name, owner_name, phone, email, address, city, cuisine_type, opening_time, closing_time, rating, status) VALUES
('Spice Garden', 'Rajesh Patil', '9000000001', 'spicegarden@gmail.com', 'Andheri', 'Mumbai', 'Indian', '10:00:00', '23:00:00', 4.5, 'Active'),
('Pizza Paradise', 'Amit Shah', '9000000002', 'pizzaparadise@gmail.com', 'Bandra', 'Mumbai', 'Italian', '11:00:00', '23:30:00', 4.6, 'Active'),
('Burger Hub', 'Rohit Mehta', '9000000003', 'burgerhub@gmail.com', 'Dadar', 'Mumbai', 'Fast Food', '10:00:00', '22:00:00', 4.2, 'Active'),
('Mumbai Biryani House', 'Sameer Khan', '9000000004', 'biryanihouse@gmail.com', 'Kurla', 'Mumbai', 'Biryani', '11:00:00', '23:00:00', 4.7, 'Active'),
('Dragon Wok', 'Kevin Wong', '9000000005', 'dragonwok@gmail.com', 'Powai', 'Mumbai', 'Chinese', '12:00:00', '23:00:00', 4.3, 'Active'),
('Sweet Treats', 'Priya Joshi', '9000000006', 'sweettreats@gmail.com', 'Borivali', 'Mumbai', 'Desserts', '09:00:00', '22:00:00', 4.4, 'Active'),
('Dosa Delight', 'Suresh Iyer', '9000000007', 'dosadelight@gmail.com', 'Vashi', 'Navi Mumbai', 'South Indian', '08:00:00', '22:00:00', 4.5, 'Active'),
('Pasta Palace', 'Ankit Sharma', '9000000008', 'pastapalace@gmail.com', 'Kothrud', 'Pune', 'Italian', '11:00:00', '22:30:00', 4.1, 'Active'),
('Punjabi Tadka', 'Harpreet Singh', '9000000009', 'punjabitadka@gmail.com', 'Wakad', 'Pune', 'Indian', '11:00:00', '23:00:00', 4.6, 'Active'),
('Chinese Bowl', 'Akash Jain', '9000000010', 'chinesebowl@gmail.com', 'Hinjewadi', 'Pune', 'Chinese', '12:00:00', '23:00:00', 4.0, 'Active'),
('Burger Express', 'Vikas Gupta', '9000000011', 'burgerexpress@gmail.com', 'Baner', 'Pune', 'Fast Food', '10:00:00', '22:00:00', 3.9, 'Active'),
('Royal Biryani', 'Imran Sheikh', '9000000012', 'royalbiryani@gmail.com', 'Thane West', 'Thane', 'Biryani', '11:00:00', '23:30:00', 4.8, 'Active'),
('Dessert World', 'Neha Kapoor', '9000000013', 'dessertworld@gmail.com', 'Mulund', 'Mumbai', 'Desserts', '10:00:00', '22:00:00', 4.3, 'Active'),
('Pizza Town', 'Manish Verma', '9000000014', 'pizzatown@gmail.com', 'Airoli', 'Navi Mumbai', 'Italian', '11:00:00', '23:00:00', 4.2, 'Inactive'),
('South Spice', 'Ramesh Nair', '9000000015', 'southspice@gmail.com', 'Chembur', 'Mumbai', 'South Indian', '08:00:00', '22:30:00', 4.4, 'Active');

-- 4. DELIVERY PARTNERS: 25 RECORDS
INSERT INTO delivery_partners (first_name, last_name, phone, email, joining_date, vehicle_type, vehicle_number, status) VALUES
('Aman', 'Kumar', '9100000001', 'aman.kumar1@gmail.com', '2024-01-10', 'Scooter', 'MH01AB1001', 'Available'),
('Rakesh', 'Patil', '9100000002', 'rakesh.patil2@gmail.com', '2024-01-22', 'Bike', 'MH02AB1002', 'Busy'),
('Sanjay', 'Sharma', '9100000003', 'sanjay.sharma3@gmail.com', '2024-02-03', 'Bike', 'MH03AB1003', 'Offline'),
('Vijay', 'Jadhav', '9100000004', 'vijay.jadhav4@gmail.com', '2024-02-15', 'Scooter', 'MH04AB1004', 'Inactive'),
('Rohit', 'Singh', '9100000005', 'rohit.singh5@gmail.com', '2024-02-27', 'Bike', 'MH05AB1005', 'Available'),
('Kunal', 'Mehta', '9100000006', 'kunal.mehta6@gmail.com', '2024-03-10', 'Bike', 'MH06AB1006', 'Busy'),
('Deepak', 'Verma', '9100000007', 'deepak.verma7@gmail.com', '2024-03-22', 'Scooter', 'MH07AB1007', 'Offline'),
('Arjun', 'Yadav', '9100000008', 'arjun.yadav8@gmail.com', '2024-04-03', 'Bike', 'MH08AB1008', 'Inactive'),
('Nikhil', 'Rao', '9100000009', 'nikhil.rao9@gmail.com', '2024-04-15', 'Bike', 'MH09AB1009', 'Available'),
('Sameer', 'Khan', '9100000010', 'sameer.khan10@gmail.com', '2024-04-27', 'Scooter', 'MH10AB1010', 'Busy'),
('Mahesh', 'More', '9100000011', 'mahesh.more11@gmail.com', '2024-05-09', 'Bike', 'MH11AB1011', 'Available'),
('Suresh', 'Joshi', '9100000012', 'suresh.joshi12@gmail.com', '2024-05-21', 'Bike', 'MH12AB1012', 'Available'),
('Ajay', 'Gupta', '9100000013', 'ajay.gupta13@gmail.com', '2024-06-02', 'Scooter', 'MH13AB1013', 'Busy'),
('Ganesh', 'Chavan', '9100000014', 'ganesh.chavan14@gmail.com', '2024-06-14', 'Bike', 'MH14AB1014', 'Available'),
('Prakash', 'Sawant', '9100000015', 'prakash.sawant15@gmail.com', '2024-06-26', 'Bike', 'MH15AB1015', 'Available'),
('Ravi', 'Naik', '9100000016', 'ravi.naik16@gmail.com', '2024-07-08', 'Scooter', 'MH16AB1016', 'Busy'),
('Dinesh', 'Pawar', '9100000017', 'dinesh.pawar17@gmail.com', '2024-07-20', 'Bike', 'MH17AB1017', 'Available'),
('Anil', 'Deshmukh', '9100000018', 'anil.deshmukh18@gmail.com', '2024-08-01', 'Bike', 'MH18AB1018', 'Available'),
('Sunil', 'Shinde', '9100000019', 'sunil.shinde19@gmail.com', '2024-08-13', 'Scooter', 'MH19AB1019', 'Busy'),
('Raj', 'Bhosale', '9100000020', 'raj.bhosale20@gmail.com', '2024-08-25', 'Bike', 'MH20AB1020', 'Available'),
('Mohan', 'Mishra', '9100000021', 'mohan.mishra21@gmail.com', '2024-09-06', 'Bike', 'MH01AB1021', 'Available'),
('Hemant', 'Thakur', '9100000022', 'hemant.thakur22@gmail.com', '2024-09-18', 'Scooter', 'MH02AB1022', 'Busy'),
('Vivek', 'Kapoor', '9100000023', 'vivek.kapoor23@gmail.com', '2024-09-30', 'Bike', 'MH03AB1023', 'Available'),
('Akash', 'Nair', '9100000024', 'akash.nair24@gmail.com', '2024-10-12', 'Bike', 'MH04AB1024', 'Available'),
('Kishor', 'Shetty', '9100000025', 'kishor.shetty25@gmail.com', '2024-10-24', 'Scooter', 'MH05AB1025', 'Busy');
select * from menu_items;
-- 5. MENU ITEMS: 100 RECORDS
INSERT INTO menu_items (restaurant_id, category_id, item_name, description, price, is_vegetarian, is_available) VALUES
(1, 3, 'Paneer Butter Masala', 'Freshly prepared paneer butter masala', 320.00, 1, 1),
(1, 3, 'Dal Tadka', 'Freshly prepared dal tadka', 220.00, 1, 1),
(1, 3, 'Chicken Curry', 'Freshly prepared chicken curry', 380.00, 0, 1),
(1, 3, 'Butter Naan', 'Freshly prepared butter naan', 45.00, 1, 1),
(1, 3, 'Veg Biryani', 'Freshly prepared veg biryani', 260.00, 1, 1),
(1, 6, 'Masala Chaas', 'Freshly prepared masala chaas', 70.00, 1, 1),
(1, 5, 'Gulab Jamun', 'Freshly prepared gulab jamun', 90.00, 1, 1),
(2, 1, 'Margherita Pizza', 'Freshly prepared margherita pizza', 299.00, 1, 1),
(2, 1, 'Farmhouse Pizza', 'Freshly prepared farmhouse pizza', 399.00, 1, 1),
(2, 1, 'Pepperoni Pizza', 'Freshly prepared pepperoni pizza', 449.00, 0, 1),
(2, 10, 'Penne Alfredo Pasta', 'Freshly prepared penne alfredo pasta', 329.00, 1, 1),
(2, 10, 'Arrabbiata Pasta', 'Freshly prepared arrabbiata pasta', 309.00, 1, 1),
(2, 6, 'Cold Coffee', 'Freshly prepared cold coffee', 120.00, 1, 1),
(2, 5, 'Chocolate Brownie', 'Freshly prepared chocolate brownie', 160.00, 1, 1),
(3, 2, 'Classic Veg Burger', 'Freshly prepared classic veg burger', 179.00, 1, 1),
(3, 2, 'Cheese Burger', 'Freshly prepared cheese burger', 219.00, 1, 1),
(3, 2, 'Chicken Burger', 'Freshly prepared chicken burger', 249.00, 0, 1),
(3, 8, 'French Fries', 'Freshly prepared french fries', 119.00, 1, 1),
(3, 8, 'Veg Nuggets', 'Freshly prepared veg nuggets', 149.00, 1, 1),
(3, 6, 'Lemon Iced Tea', 'Freshly prepared lemon iced tea', 80.00, 1, 1),
(3, 5, 'Brownie Sundae', 'Freshly prepared brownie sundae', 170.00, 1, 1),
(4, 9, 'Chicken Biryani', 'Freshly prepared chicken biryani', 349.00, 0, 1),
(4, 9, 'Mutton Biryani', 'Freshly prepared mutton biryani', 449.00, 0, 1),
(4, 9, 'Veg Biryani', 'Freshly prepared veg biryani', 279.00, 1, 1),
(4, 3, 'Chicken Tikka', 'Freshly prepared chicken tikka', 329.00, 0, 1),
(4, 3, 'Paneer Tikka', 'Freshly prepared paneer tikka', 269.00, 1, 1),
(4, 6, 'Sweet Lassi', 'Freshly prepared sweet lassi', 95.00, 1, 1),
(4, 5, 'Phirni', 'Freshly prepared phirni', 110.00, 1, 1),
(5, 4, 'Veg Hakka Noodles', 'Freshly prepared veg hakka noodles', 229.00, 1, 1),
(5, 4, 'Chicken Hakka Noodles', 'Freshly prepared chicken hakka noodles', 269.00, 0, 1),
(5, 4, 'Veg Fried Rice', 'Freshly prepared veg fried rice', 219.00, 1, 1),
(5, 4, 'Chicken Fried Rice', 'Freshly prepared chicken fried rice', 259.00, 0, 1),
(5, 4, 'Veg Manchurian', 'Freshly prepared veg manchurian', 239.00, 1, 1),
(5, 4, 'Chicken Manchurian', 'Freshly prepared chicken manchurian', 279.00, 0, 1),
(5, 6, 'Green Tea', 'Freshly prepared green tea', 70.00, 1, 1),
(6, 5, 'Chocolate Cake', 'Freshly prepared chocolate cake', 220.00, 1, 1),
(6, 5, 'Red Velvet Cake', 'Freshly prepared red velvet cake', 250.00, 1, 1),
(6, 5, 'Cheesecake', 'Freshly prepared cheesecake', 280.00, 1, 1),
(6, 5, 'Ice Cream Sundae', 'Freshly prepared ice cream sundae', 180.00, 1, 1),
(6, 5, 'Brownie', 'Freshly prepared brownie', 150.00, 1, 1),
(6, 6, 'Mango Shake', 'Freshly prepared mango shake', 140.00, 1, 1),
(6, 6, 'Cold Coffee', 'Freshly prepared cold coffee', 130.00, 1, 1),
(7, 7, 'Masala Dosa', 'Freshly prepared masala dosa', 150.00, 1, 1),
(7, 7, 'Mysore Dosa', 'Freshly prepared mysore dosa', 180.00, 1, 1),
(7, 7, 'Idli Sambar', 'Freshly prepared idli sambar', 120.00, 1, 1),
(7, 7, 'Medu Vada', 'Freshly prepared medu vada', 110.00, 1, 1),
(7, 7, 'Uttapam', 'Freshly prepared uttapam', 160.00, 1, 1),
(7, 6, 'Filter Coffee', 'Freshly prepared filter coffee', 60.00, 1, 1),
(7, 5, 'Kesari', 'Freshly prepared kesari', 80.00, 1, 1),
(8, 10, 'Veg Alfredo Pasta', 'Freshly prepared veg alfredo pasta', 310.00, 1, 1),
(8, 10, 'Chicken Alfredo Pasta', 'Freshly prepared chicken alfredo pasta', 370.00, 0, 1),
(8, 10, 'Spaghetti Arrabbiata', 'Freshly prepared spaghetti arrabbiata', 320.00, 1, 1),
(8, 1, 'Cheese Pizza', 'Freshly prepared cheese pizza', 330.00, 1, 1),
(8, 1, 'Chicken Pizza', 'Freshly prepared chicken pizza', 410.00, 0, 1),
(8, 6, 'Iced Tea', 'Freshly prepared iced tea', 90.00, 1, 1),
(8, 5, 'Tiramisu', 'Freshly prepared tiramisu', 230.00, 1, 1),
(9, 3, 'Butter Chicken', 'Freshly prepared butter chicken', 390.00, 0, 1),
(9, 3, 'Paneer Tikka Masala', 'Freshly prepared paneer tikka masala', 320.00, 1, 1),
(9, 3, 'Dal Makhani', 'Freshly prepared dal makhani', 250.00, 1, 1),
(9, 3, 'Chole Bhature', 'Freshly prepared chole bhature', 220.00, 1, 1),
(9, 3, 'Veg Thali', 'Freshly prepared veg thali', 299.00, 1, 1),
(9, 6, 'Sweet Lassi', 'Freshly prepared sweet lassi', 100.00, 1, 1),
(9, 5, 'Kulfi', 'Freshly prepared kulfi', 90.00, 1, 1),
(10, 4, 'Schezwan Noodles', 'Freshly prepared schezwan noodles', 250.00, 1, 1),
(10, 4, 'Chicken Schezwan Noodles', 'Freshly prepared chicken schezwan noodles', 290.00, 0, 1),
(10, 4, 'Veg Spring Roll', 'Freshly prepared veg spring roll', 180.00, 1, 1),
(10, 4, 'Chicken Spring Roll', 'Freshly prepared chicken spring roll', 220.00, 0, 1),
(10, 4, 'Schezwan Fried Rice', 'Freshly prepared schezwan fried rice', 240.00, 1, 1),
(10, 6, 'Peach Iced Tea', 'Freshly prepared peach iced tea', 90.00, 1, 1),
(10, 5, 'Fortune Cookie Dessert', 'Freshly prepared fortune cookie dessert', 60.00, 1, 1),
(11, 2, 'Double Cheese Burger', 'Freshly prepared double cheese burger', 240.00, 1, 1),
(11, 2, 'Crispy Chicken Burger', 'Freshly prepared crispy chicken burger', 280.00, 0, 1),
(11, 2, 'Veg Supreme Burger', 'Freshly prepared veg supreme burger', 230.00, 1, 1),
(11, 8, 'Loaded Fries', 'Freshly prepared loaded fries', 160.00, 1, 1),
(11, 8, 'Chicken Nuggets', 'Freshly prepared chicken nuggets', 210.00, 0, 1),
(11, 6, 'Cola', 'Freshly prepared cola', 60.00, 1, 1),
(11, 5, 'Chocolate Shake', 'Freshly prepared chocolate shake', 140.00, 1, 1),
(12, 9, 'Royal Chicken Biryani', 'Freshly prepared royal chicken biryani', 370.00, 0, 1),
(12, 9, 'Hyderabadi Mutton Biryani', 'Freshly prepared hyderabadi mutton biryani', 470.00, 0, 1),
(12, 9, 'Veg Dum Biryani', 'Freshly prepared veg dum biryani', 290.00, 1, 1),
(12, 3, 'Chicken Kebab', 'Freshly prepared chicken kebab', 310.00, 0, 1),
(12, 3, 'Raita', 'Freshly prepared raita', 70.00, 1, 1),
(12, 6, 'Masala Chaas', 'Freshly prepared masala chaas', 75.00, 1, 1),
(12, 5, 'Shahi Tukda', 'Freshly prepared shahi tukda', 130.00, 1, 1),
(13, 5, 'Chocolate Lava Cake', 'Freshly prepared chocolate lava cake', 190.00, 1, 1),
(13, 5, 'Blueberry Cheesecake', 'Freshly prepared blueberry cheesecake', 270.00, 1, 1),
(13, 5, 'Waffle', 'Freshly prepared waffle', 210.00, 1, 1),
(13, 5, 'Donut Box', 'Freshly prepared donut box', 180.00, 1, 1),
(13, 5, 'Brownie Sundae', 'Freshly prepared brownie sundae', 200.00, 1, 1),
(13, 6, 'Oreo Shake', 'Freshly prepared oreo shake', 150.00, 1, 1),
(14, 1, 'Veggie Pizza', 'Freshly prepared veggie pizza', 280.00, 1, 1),
(14, 1, 'Paneer Pizza', 'Freshly prepared paneer pizza', 360.00, 1, 1),
(14, 1, 'BBQ Chicken Pizza', 'Freshly prepared bbq chicken pizza', 430.00, 0, 1),
(14, 10, 'Veg Lasagna', 'Freshly prepared veg lasagna', 340.00, 1, 1),
(14, 10, 'Chicken Pasta', 'Freshly prepared chicken pasta', 380.00, 0, 1),
(14, 6, 'Cola', 'Freshly prepared cola', 60.00, 1, 1),
(15, 7, 'Plain Dosa', 'Freshly prepared plain dosa', 110.00, 1, 1),
(15, 7, 'Masala Dosa', 'Freshly prepared masala dosa', 150.00, 1, 1),
(15, 7, 'Onion Uttapam', 'Freshly prepared onion uttapam', 170.00, 1, 1),
(15, 7, 'Idli Vada Combo', 'Freshly prepared idli vada combo', 140.00, 1, 1);
-- 6. COUPONS: 20 RECORDS
INSERT INTO coupons (coupon_code, description, discount_type, discount_value, minimum_order_amount, maximum_discount, start_date, end_date, status) VALUES
('WELCOME50', 'Welcome discount for new users', 'Flat', '50', '199', NULL, '2025-01-01', '2025-05-01', 'Expired'),
('SAVE10', 'Save 10 percent', 'Percentage', '10', '299', '100', '2025-01-11', '2025-05-11', 'Expired'),
('FOOD20', 'FoodRush special offer', 'Percentage', '20', '499', '150', '2025-01-21', '2025-05-21', 'Expired'),
('FREEDEL', 'Free delivery offer', 'Flat', '40', '249', NULL, '2025-01-31', '2025-05-31', 'Expired'),
('WEEKEND15', 'Weekend special discount', 'Percentage', '15', '399', '120', '2025-02-10', '2025-06-10', 'Expired'),
('PIZZA75', 'Pizza discount', 'Flat', '75', '399', NULL, '2025-02-20', '2025-06-20', 'Active'),
('BURGER20', 'Burger special offer', 'Percentage', '20', '299', '80', '2025-03-02', '2025-06-30', 'Active'),
('BIRYANI60', 'Biryani discount', 'Flat', '60', '349', NULL, '2025-03-12', '2025-07-10', 'Inactive'),
('SWEET10', 'Dessert discount', 'Percentage', '10', '199', '50', '2025-03-22', '2025-07-20', 'Active'),
('UPI25', 'UPI payment offer', 'Flat', '25', '299', NULL, '2025-04-01', '2025-07-30', 'Active'),
('FESTIVE30', 'Festival discount', 'Percentage', '30', '599', '200', '2025-04-11', '2025-08-09', 'Active'),
('FIRST100', 'First order offer', 'Flat', '100', '499', NULL, '2025-04-21', '2025-08-19', 'Active'),
('MEAL15', 'Meal combo discount', 'Percentage', '15', '349', '100', '2025-05-01', '2025-08-29', 'Inactive'),
('LUNCH40', 'Lunch time offer', 'Flat', '40', '299', NULL, '2025-05-11', '2025-09-08', 'Active'),
('DINNER50', 'Dinner special offer', 'Flat', '50', '499', NULL, '2025-05-21', '2025-09-18', 'Active'),
('APP20', 'App exclusive offer', 'Percentage', '20', '399', '150', '2025-05-31', '2025-09-28', 'Active'),
('SAVE30', 'Limited time saving', 'Flat', '30', '249', NULL, '2025-06-10', '2025-10-08', 'Active'),
('MONSOON15', 'Monsoon special', 'Percentage', '15', '399', '100', '2025-06-20', '2025-10-18', 'Active'),
('FRIDAY50', 'Friday deal', 'Flat', '50', '349', NULL, '2025-06-30', '2025-10-28', 'Active'),
('BIGSAVE25', 'Big saving offer', 'Percentage', '25', '699', '250', '2025-07-10', '2025-11-07', 'Active');

-- 7. ORDERS: 300 RECORDS
INSERT INTO orders (customer_id, restaurant_id, delivery_partner_id, order_date, delivery_address, subtotal, delivery_fee, discount, tax, total_amount, order_status) VALUES
(1, 7, 1, '2025-01-08 15:07:00', 'Andheri West, Mumbai', 200.00, 40.00, 0.00, 10.00, 250.00, 'Delivered'),
(2, 14, NULL, '2025-01-11 10:14:00', 'Bandra West, Mumbai', 400.00, 40.00, 0.00, 20.00, 460.00, 'Cancelled'),
(3, 6, 3, '2025-01-14 15:21:00', 'Dadar, Mumbai', 590.00, 0.00, 0.00, 29.50, 619.50, 'Delivered'),
(4, 13, 4, '2025-01-17 10:28:00', 'Powai, Pune', 400.00, 40.00, 0.00, 20.00, 460.00, 'Delivered'),
(5, 5, 5, '2025-01-20 15:35:00', 'Borivali, Pune', 548.00, 0.00, 27.40, 27.40, 548.00, 'Delivered'),
(6, 12, NULL, '2025-01-23 10:42:00', 'Chembur, Thane', 840.00, 0.00, 0.00, 42.00, 882.00, 'Cancelled'),
(7, 4, 7, '2025-01-26 15:49:00', 'Goregaon, Navi Mumbai', 1008.00, 0.00, 0.00, 50.40, 1058.40, 'Delivered'),
(8, 11, 8, '2025-01-29 10:56:00', 'Mulund, Mumbai', 490.00, 40.00, 0.00, 24.50, 554.50, 'Delivered'),
(9, 3, 9, '2025-02-01 15:03:00', 'Kothrud, Mumbai', 298.00, 40.00, 0.00, 14.90, 352.90, 'Delivered'),
(10, 10, 10, '2025-02-04 10:10:00', 'Wakad, Mumbai', 240.00, 40.00, 12.00, 12.00, 280.00, 'Delivered'),
(11, 2, 11, '2025-02-07 15:17:00', 'Baner, Pune', 848.00, 0.00, 0.00, 42.40, 890.40, 'Delivered'),
(12, 9, NULL, '2025-02-10 10:24:00', 'Hinjewadi, Pune', 690.00, 0.00, 0.00, 34.50, 724.50, 'Placed'),
(13, 1, 13, '2025-02-13 15:31:00', 'Viman Nagar, Thane', 500.00, 0.00, 0.00, 25.00, 525.00, 'Delivered'),
(14, 8, 14, '2025-02-16 10:38:00', 'Airoli, Navi Mumbai', 540.00, 0.00, 0.00, 27.00, 567.00, 'Delivered'),
(15, 15, 15, '2025-02-19 15:45:00', 'Vashi, Mumbai', 580.00, 0.00, 29.00, 29.00, 580.00, 'Delivered'),
(16, 7, NULL, '2025-02-22 10:52:00', 'Thane West, Mumbai', 280.00, 40.00, 0.00, 14.00, 334.00, 'Placed'),
(17, 14, NULL, '2025-02-25 15:59:00', 'Kalyan, Mumbai', 920.00, 0.00, 0.00, 46.00, 966.00, 'Confirmed'),
(18, 6, 18, '2025-02-28 10:06:00', 'Andheri West, Pune', 440.00, 40.00, 0.00, 22.00, 502.00, 'Delivered'),
(19, 13, 19, '2025-03-03 15:13:00', 'Bandra West, Pune', 610.00, 0.00, 0.00, 30.50, 640.50, 'Delivered'),
(20, 5, 20, '2025-03-06 10:20:00', 'Dadar, Thane', 528.00, 0.00, 26.40, 26.40, 528.00, 'Delivered'),
(21, 12, NULL, '2025-03-09 15:27:00', 'Powai, Navi Mumbai', 360.00, 40.00, 0.00, 18.00, 418.00, 'Cancelled'),
(22, 4, 22, '2025-03-12 10:34:00', 'Borivali, Mumbai', 300.00, 40.00, 0.00, 15.00, 355.00, 'Delivered'),
(23, 11, 23, '2025-03-15 15:41:00', 'Chembur, Mumbai', 470.00, 40.00, 0.00, 23.50, 533.50, 'Delivered'),
(24, 3, NULL, '2025-03-18 10:48:00', 'Goregaon, Mumbai', 607.00, 0.00, 0.00, 30.35, 637.35, 'Cancelled'),
(25, 10, 25, '2025-03-21 15:55:00', 'Mulund, Pune', 270.00, 40.00, 13.50, 13.50, 310.00, 'Delivered'),
(26, 2, 1, '2025-03-24 10:02:00', 'Kothrud, Pune', 449.00, 40.00, 0.00, 22.45, 511.45, 'Delivered'),
(27, 9, NULL, '2025-03-27 15:09:00', 'Wakad, Thane', 740.00, 0.00, 0.00, 37.00, 777.00, 'Cancelled'),
(28, 1, 3, '2025-03-30 10:16:00', 'Baner, Navi Mumbai', 350.00, 40.00, 0.00, 17.50, 407.50, 'Delivered'),
(29, 8, 4, '2025-04-02 15:23:00', 'Hinjewadi, Mumbai', 1100.00, 0.00, 0.00, 55.00, 1155.00, 'Delivered'),
(30, 15, 5, '2025-04-05 10:30:00', 'Viman Nagar, Mumbai', 260.00, 40.00, 13.00, 13.00, 300.00, 'Delivered'),
(31, 7, NULL, '2025-04-08 15:37:00', 'Airoli, Mumbai', 540.00, 0.00, 0.00, 27.00, 567.00, 'Preparing'),
(32, 14, 7, '2025-04-11 10:44:00', 'Vashi, Pune', 1440.00, 0.00, 0.00, 72.00, 1512.00, 'Delivered'),
(33, 6, 8, '2025-04-14 15:51:00', 'Thane West, Pune', 760.00, 0.00, 0.00, 38.00, 798.00, 'Delivered'),
(34, 13, 9, '2025-04-17 10:58:00', 'Kalyan, Thane', 560.00, 0.00, 0.00, 28.00, 588.00, 'Delivered'),
(35, 5, NULL, '2025-04-20 15:05:00', 'Andheri West, Navi Mumbai', 658.00, 0.00, 32.90, 32.90, 658.00, 'Cancelled'),
(36, 12, 11, '2025-04-23 10:12:00', 'Bandra West, Mumbai', 1070.00, 0.00, 0.00, 53.50, 1123.50, 'Delivered'),
(37, 4, NULL, '2025-04-26 15:19:00', 'Dadar, Mumbai', 1356.00, 0.00, 0.00, 67.80, 1423.80, 'Cancelled'),
(38, 11, 13, '2025-04-29 10:26:00', 'Powai, Mumbai', 700.00, 0.00, 0.00, 35.00, 735.00, 'Delivered'),
(39, 3, 14, '2025-05-02 15:33:00', 'Borivali, Pune', 468.00, 40.00, 0.00, 23.40, 531.40, 'Delivered'),
(40, 10, 15, '2025-05-05 10:40:00', 'Chembur, Pune', 400.00, 40.00, 20.00, 20.00, 440.00, 'Delivered'),
(41, 2, NULL, '2025-05-08 15:47:00', 'Goregaon, Thane', 609.00, 0.00, 0.00, 30.45, 639.45, 'Cancelled'),
(42, 9, NULL, '2025-05-11 10:54:00', 'Mulund, Navi Mumbai', 399.00, 40.00, 0.00, 19.95, 458.95, 'Cancelled'),
(43, 1, NULL, '2025-05-14 15:01:00', 'Kothrud, Mumbai', 820.00, 0.00, 0.00, 41.00, 861.00, 'Preparing'),
(44, 8, 19, '2025-05-17 10:08:00', 'Wakad, Mumbai', 540.00, 0.00, 0.00, 27.00, 567.00, 'Delivered'),
(45, 15, 20, '2025-05-20 15:15:00', 'Baner, Mumbai', 320.00, 40.00, 16.00, 16.00, 360.00, 'Out for Delivery'),
(46, 7, 21, '2025-05-23 10:22:00', 'Hinjewadi, Pune', 270.00, 40.00, 0.00, 13.50, 323.50, 'Delivered'),
(47, 14, 22, '2025-05-26 15:29:00', 'Viman Nagar, Pune', 900.00, 0.00, 0.00, 45.00, 945.00, 'Out for Delivery'),
(48, 6, 23, '2025-05-29 10:36:00', 'Airoli, Thane', 540.00, 0.00, 0.00, 27.00, 567.00, 'Delivered'),
(49, 13, 24, '2025-06-01 15:43:00', 'Vashi, Navi Mumbai', 690.00, 0.00, 0.00, 34.50, 724.50, 'Delivered'),
(50, 5, 25, '2025-06-04 10:50:00', 'Thane West, Mumbai', 697.00, 0.00, 34.85, 34.85, 697.00, 'Delivered'),
(1, 12, 1, '2025-06-07 15:57:00', 'Andheri West, Mumbai', 365.00, 40.00, 0.00, 18.25, 423.25, 'Delivered'),
(2, 4, 2, '2025-06-10 10:04:00', 'Bandra West, Mumbai', 608.00, 0.00, 0.00, 30.40, 638.40, 'Out for Delivery'),
(3, 11, 3, '2025-06-13 15:11:00', 'Dadar, Mumbai', 440.00, 40.00, 0.00, 22.00, 502.00, 'Delivered'),
(4, 3, NULL, '2025-06-16 10:18:00', 'Powai, Pune', 299.00, 40.00, 0.00, 14.95, 353.95, 'Cancelled'),
(5, 10, 5, '2025-06-19 15:25:00', 'Borivali, Pune', 490.00, 40.00, 24.50, 24.50, 530.00, 'Delivered'),
(6, 2, 6, '2025-06-22 10:32:00', 'Chembur, Thane', 469.00, 40.00, 0.00, 23.45, 532.45, 'Delivered'),
(7, 9, 7, '2025-06-25 15:39:00', 'Goregaon, Navi Mumbai', 310.00, 40.00, 0.00, 15.50, 365.50, 'Delivered'),
(8, 1, 8, '2025-06-28 10:46:00', 'Mulund, Mumbai', 160.00, 40.00, 0.00, 8.00, 208.00, 'Delivered'),
(9, 8, NULL, '2025-07-01 15:53:00', 'Kothrud, Mumbai', 500.00, 0.00, 0.00, 25.00, 525.00, 'Preparing'),
(10, 15, 10, '2025-07-04 10:00:00', 'Wakad, Mumbai', 490.00, 40.00, 24.50, 24.50, 530.00, 'Delivered'),
(11, 7, NULL, '2025-07-07 15:07:00', 'Baner, Pune', 480.00, 40.00, 0.00, 24.00, 544.00, 'Cancelled'),
(12, 14, NULL, '2025-07-10 10:14:00', 'Hinjewadi, Pune', 940.00, 0.00, 0.00, 47.00, 987.00, 'Cancelled'),
(13, 6, 13, '2025-07-13 15:21:00', 'Viman Nagar, Thane', 400.00, 40.00, 0.00, 20.00, 460.00, 'Delivered'),
(14, 13, NULL, '2025-07-16 10:28:00', 'Airoli, Navi Mumbai', 450.00, 40.00, 0.00, 22.50, 512.50, 'Cancelled'),
(15, 5, 15, '2025-07-19 15:35:00', 'Vashi, Mumbai', 369.00, 40.00, 18.45, 18.45, 409.00, 'Delivered'),
(16, 12, 16, '2025-07-22 10:42:00', 'Thane West, Mumbai', 205.00, 40.00, 0.00, 10.25, 255.25, 'Delivered'),
(17, 4, NULL, '2025-07-25 15:49:00', 'Kalyan, Mumbai', 1147.00, 0.00, 0.00, 57.35, 1204.35, 'Cancelled'),
(18, 11, 18, '2025-07-28 10:56:00', 'Andheri West, Pune', 330.00, 40.00, 0.00, 16.50, 386.50, 'Delivered'),
(19, 3, 19, '2025-07-31 15:03:00', 'Bandra West, Pune', 289.00, 40.00, 0.00, 14.45, 343.45, 'Delivered'),
(20, 10, 20, '2025-08-03 10:10:00', 'Dadar, Thane', 700.00, 0.00, 35.00, 35.00, 700.00, 'Delivered'),
(21, 2, 21, '2025-08-06 15:17:00', 'Powai, Navi Mumbai', 918.00, 0.00, 0.00, 45.90, 963.90, 'Delivered'),
(22, 9, 22, '2025-08-09 10:24:00', 'Borivali, Mumbai', 500.00, 0.00, 0.00, 25.00, 525.00, 'Delivered'),
(23, 1, 23, '2025-08-12 15:31:00', 'Chembur, Mumbai', 350.00, 40.00, 0.00, 17.50, 407.50, 'Out for Delivery'),
(24, 8, 24, '2025-08-15 10:38:00', 'Goregaon, Mumbai', 640.00, 0.00, 0.00, 32.00, 672.00, 'Out for Delivery'),
(25, 15, 25, '2025-08-18 15:45:00', 'Mulund, Pune', 490.00, 40.00, 24.50, 24.50, 530.00, 'Delivered'),
(26, 7, 1, '2025-08-21 10:52:00', 'Kothrud, Pune', 260.00, 40.00, 0.00, 13.00, 313.00, 'Delivered'),
(27, 14, 2, '2025-08-24 15:59:00', 'Wakad, Thane', 640.00, 0.00, 0.00, 32.00, 672.00, 'Delivered'),
(28, 6, 3, '2025-08-27 10:06:00', 'Baner, Navi Mumbai', 440.00, 40.00, 0.00, 22.00, 502.00, 'Delivered'),
(29, 13, NULL, '2025-08-30 15:13:00', 'Hinjewadi, Mumbai', 560.00, 0.00, 0.00, 28.00, 588.00, 'Preparing'),
(30, 5, 5, '2025-09-02 10:20:00', 'Viman Nagar, Mumbai', 309.00, 40.00, 15.45, 15.45, 349.00, 'Delivered'),
(31, 12, 6, '2025-09-05 15:27:00', 'Airoli, Mumbai', 840.00, 0.00, 0.00, 42.00, 882.00, 'Out for Delivery'),
(32, 4, 7, '2025-09-08 10:34:00', 'Vashi, Pune', 768.00, 0.00, 0.00, 38.40, 806.40, 'Delivered'),
(33, 11, 8, '2025-09-11 15:41:00', 'Thane West, Pune', 490.00, 40.00, 0.00, 24.50, 554.50, 'Delivered'),
(34, 3, 9, '2025-09-14 10:48:00', 'Kalyan, Thane', 368.00, 40.00, 0.00, 18.40, 426.40, 'Delivered'),
(35, 10, 10, '2025-09-17 15:55:00', 'Andheri West, Navi Mumbai', 300.00, 40.00, 15.00, 15.00, 340.00, 'Delivered'),
(36, 2, 11, '2025-09-20 10:02:00', 'Bandra West, Mumbai', 978.00, 0.00, 0.00, 48.90, 1026.90, 'Delivered'),
(37, 9, 12, '2025-09-23 15:09:00', 'Dadar, Mumbai', 988.00, 0.00, 0.00, 49.40, 1037.40, 'Delivered'),
(38, 1, NULL, '2025-09-26 10:16:00', 'Powai, Mumbai', 390.00, 40.00, 0.00, 19.50, 449.50, 'Confirmed'),
(39, 8, NULL, '2025-09-29 15:23:00', 'Borivali, Pune', 560.00, 0.00, 0.00, 28.00, 588.00, 'Placed'),
(40, 15, 15, '2025-10-02 10:30:00', 'Chembur, Pune', 280.00, 40.00, 14.00, 14.00, 320.00, 'Delivered'),
(41, 7, 16, '2025-10-05 15:37:00', 'Goregaon, Thane', 460.00, 40.00, 0.00, 23.00, 523.00, 'Delivered'),
(42, 14, 17, '2025-10-08 10:44:00', 'Mulund, Navi Mumbai', 990.00, 0.00, 0.00, 49.50, 1039.50, 'Out for Delivery'),
(43, 6, 18, '2025-10-11 15:51:00', 'Kothrud, Mumbai', 500.00, 0.00, 0.00, 25.00, 525.00, 'Delivered'),
(44, 13, 19, '2025-10-14 10:58:00', 'Wakad, Mumbai', 680.00, 0.00, 0.00, 34.00, 714.00, 'Delivered'),
(45, 5, 20, '2025-10-17 15:05:00', 'Baner, Mumbai', 498.00, 40.00, 24.90, 24.90, 538.00, 'Delivered'),
(46, 12, 21, '2025-10-20 10:12:00', 'Hinjewadi, Pune', 460.00, 40.00, 0.00, 23.00, 523.00, 'Delivered'),
(47, 4, 22, '2025-10-23 15:19:00', 'Viman Nagar, Pune', 424.00, 40.00, 0.00, 21.20, 485.20, 'Delivered'),
(48, 11, NULL, '2025-10-26 10:26:00', 'Airoli, Thane', 560.00, 0.00, 0.00, 28.00, 588.00, 'Cancelled'),
(49, 3, 24, '2025-10-29 15:33:00', 'Vashi, Navi Mumbai', 559.00, 0.00, 0.00, 27.95, 586.95, 'Delivered'),
(50, 10, 25, '2025-11-01 10:40:00', 'Thane West, Mumbai', 610.00, 0.00, 30.50, 30.50, 610.00, 'Delivered'),
(1, 2, 1, '2025-11-04 15:47:00', 'Andheri West, Mumbai', 818.00, 0.00, 0.00, 40.90, 858.90, 'Delivered'),
(2, 9, 2, '2025-11-07 10:54:00', 'Bandra West, Mumbai', 698.00, 0.00, 0.00, 34.90, 732.90, 'Delivered'),
(3, 1, 3, '2025-11-10 15:01:00', 'Dadar, Mumbai', 520.00, 0.00, 0.00, 26.00, 546.00, 'Delivered'),
(4, 8, 4, '2025-11-13 10:08:00', 'Powai, Pune', 1030.00, 0.00, 0.00, 51.50, 1081.50, 'Delivered'),
(5, 15, 5, '2025-11-16 15:15:00', 'Borivali, Pune', 310.00, 40.00, 15.50, 15.50, 350.00, 'Delivered'),
(6, 7, 6, '2025-11-19 10:22:00', 'Chembur, Thane', 540.00, 0.00, 0.00, 27.00, 567.00, 'Delivered'),
(7, 14, 7, '2025-11-22 15:29:00', 'Goregaon, Navi Mumbai', 900.00, 0.00, 0.00, 45.00, 945.00, 'Delivered'),
(8, 6, 8, '2025-11-25 10:36:00', 'Mulund, Mumbai', 310.00, 40.00, 0.00, 15.50, 365.50, 'Delivered'),
(9, 13, 9, '2025-11-28 15:43:00', 'Kothrud, Mumbai', 500.00, 0.00, 0.00, 25.00, 525.00, 'Delivered'),
(10, 5, 10, '2025-12-01 10:50:00', 'Wakad, Mumbai', 379.00, 40.00, 18.95, 18.95, 419.00, 'Delivered'),
(11, 12, 11, '2025-12-04 15:57:00', 'Baner, Pune', 205.00, 40.00, 0.00, 10.25, 255.25, 'Delivered'),
(12, 4, 12, '2025-12-07 10:04:00', 'Hinjewadi, Pune', 798.00, 0.00, 0.00, 39.90, 837.90, 'Delivered'),
(13, 11, 13, '2025-12-10 15:11:00', 'Viman Nagar, Thane', 300.00, 40.00, 0.00, 15.00, 355.00, 'Delivered'),
(14, 3, 14, '2025-12-13 10:18:00', 'Airoli, Navi Mumbai', 428.00, 40.00, 0.00, 21.40, 489.40, 'Delivered'),
(15, 10, 15, '2025-12-16 15:25:00', 'Vashi, Mumbai', 510.00, 0.00, 25.50, 25.50, 510.00, 'Delivered'),
(16, 2, NULL, '2025-12-19 10:32:00', 'Thane West, Mumbai', 758.00, 0.00, 0.00, 37.90, 795.90, 'Preparing'),
(17, 9, 17, '2025-12-22 15:39:00', 'Kalyan, Mumbai', 1079.00, 0.00, 0.00, 53.95, 1132.95, 'Delivered'),
(18, 1, 18, '2025-12-25 10:46:00', 'Andheri West, Pune', 160.00, 40.00, 0.00, 8.00, 208.00, 'Delivered'),
(19, 8, 19, '2025-12-28 15:53:00', 'Bandra West, Pune', 420.00, 40.00, 0.00, 21.00, 481.00, 'Delivered'),
(20, 15, 20, '2025-12-31 10:00:00', 'Dadar, Thane', 250.00, 40.00, 12.50, 12.50, 290.00, 'Out for Delivery'),
(21, 7, 21, '2026-01-03 15:07:00', 'Powai, Navi Mumbai', 300.00, 40.00, 0.00, 15.00, 355.00, 'Delivered'),
(22, 14, 22, '2025-01-06 10:14:00', 'Borivali, Mumbai', 500.00, 0.00, 0.00, 25.00, 525.00, 'Delivered'),
(23, 6, 23, '2025-01-09 15:21:00', 'Chembur, Mumbai', 430.00, 40.00, 0.00, 21.50, 491.50, 'Delivered'),
(24, 13, 24, '2025-01-12 10:28:00', 'Goregaon, Mumbai', 510.00, 0.00, 0.00, 25.50, 535.50, 'Delivered'),
(25, 5, NULL, '2025-01-15 15:35:00', 'Mulund, Pune', 896.00, 0.00, 44.80, 44.80, 896.00, 'Preparing'),
(26, 12, 1, '2025-01-18 10:42:00', 'Kothrud, Pune', 1015.00, 0.00, 0.00, 50.75, 1065.75, 'Delivered'),
(27, 4, 2, '2025-01-21 15:49:00', 'Wakad, Thane', 469.00, 40.00, 0.00, 23.45, 532.45, 'Delivered'),
(28, 11, 3, '2025-01-24 10:56:00', 'Baner, Navi Mumbai', 880.00, 0.00, 0.00, 44.00, 924.00, 'Delivered'),
(29, 3, 4, '2025-01-27 15:03:00', 'Hinjewadi, Mumbai', 468.00, 40.00, 0.00, 23.40, 531.40, 'Delivered'),
(30, 10, 5, '2025-01-30 10:10:00', 'Viman Nagar, Mumbai', 330.00, 40.00, 16.50, 16.50, 370.00, 'Delivered'),
(31, 2, 6, '2025-02-02 15:17:00', 'Airoli, Mumbai', 917.00, 0.00, 0.00, 45.85, 962.85, 'Delivered'),
(32, 9, 7, '2025-02-05 10:24:00', 'Vashi, Pune', 320.00, 40.00, 0.00, 16.00, 376.00, 'Delivered'),
(33, 1, NULL, '2025-02-08 15:31:00', 'Thane West, Pune', 425.00, 40.00, 0.00, 21.25, 486.25, 'Placed'),
(34, 8, 9, '2025-02-11 10:38:00', 'Kalyan, Thane', 940.00, 0.00, 0.00, 47.00, 987.00, 'Delivered'),
(35, 15, NULL, '2025-02-14 15:45:00', 'Andheri West, Navi Mumbai', 260.00, 40.00, 13.00, 13.00, 300.00, 'Cancelled'),
(36, 7, NULL, '2025-02-17 10:52:00', 'Bandra West, Mumbai', 360.00, 40.00, 0.00, 18.00, 418.00, 'Cancelled'),
(37, 14, NULL, '2025-02-20 15:59:00', 'Dadar, Mumbai', 1140.00, 0.00, 0.00, 57.00, 1197.00, 'Cancelled'),
(38, 6, 13, '2025-02-23 10:06:00', 'Powai, Mumbai', 490.00, 40.00, 0.00, 24.50, 554.50, 'Delivered'),
(39, 13, 14, '2025-02-26 15:13:00', 'Borivali, Pune', 670.00, 0.00, 0.00, 33.50, 703.50, 'Delivered'),
(40, 5, 15, '2025-03-01 10:20:00', 'Chembur, Pune', 677.00, 0.00, 33.85, 33.85, 677.00, 'Delivered'),
(41, 12, NULL, '2025-03-04 15:27:00', 'Goregaon, Thane', 810.00, 0.00, 0.00, 40.50, 850.50, 'Cancelled'),
(42, 4, 17, '2025-03-07 10:34:00', 'Mulund, Navi Mumbai', 559.00, 0.00, 0.00, 27.95, 586.95, 'Delivered'),
(43, 11, 18, '2025-03-10 15:41:00', 'Kothrud, Mumbai', 520.00, 0.00, 0.00, 26.00, 546.00, 'Delivered'),
(44, 3, 19, '2025-03-13 10:48:00', 'Wakad, Mumbai', 398.00, 40.00, 0.00, 19.90, 457.90, 'Delivered'),
(45, 10, 20, '2025-03-16 15:55:00', 'Baner, Mumbai', 400.00, 40.00, 20.00, 20.00, 440.00, 'Delivered'),
(46, 2, 21, '2025-03-19 10:02:00', 'Hinjewadi, Pune', 1018.00, 0.00, 0.00, 50.90, 1068.90, 'Delivered'),
(47, 9, NULL, '2025-03-22 15:09:00', 'Viman Nagar, Pune', 890.00, 0.00, 0.00, 44.50, 934.50, 'Cancelled'),
(48, 1, 23, '2025-03-25 10:16:00', 'Airoli, Thane', 290.00, 40.00, 0.00, 14.50, 344.50, 'Delivered'),
(49, 8, NULL, '2025-03-28 15:23:00', 'Vashi, Navi Mumbai', 920.00, 0.00, 0.00, 46.00, 966.00, 'Cancelled'),
(50, 15, 25, '2025-03-31 10:30:00', 'Thane West, Mumbai', 250.00, 40.00, 12.50, 12.50, 290.00, 'Delivered'),
(1, 7, NULL, '2025-04-03 15:37:00', 'Andheri West, Mumbai', 280.00, 40.00, 0.00, 14.00, 334.00, 'Confirmed'),
(2, 14, 2, '2025-04-06 10:44:00', 'Bandra West, Mumbai', 1200.00, 0.00, 0.00, 60.00, 1260.00, 'Delivered'),
(3, 6, NULL, '2025-04-09 15:51:00', 'Dadar, Mumbai', 280.00, 40.00, 0.00, 14.00, 334.00, 'Cancelled'),
(4, 13, 4, '2025-04-12 10:58:00', 'Powai, Pune', 560.00, 0.00, 0.00, 28.00, 588.00, 'Delivered'),
(5, 5, 5, '2025-04-15 15:05:00', 'Borivali, Pune', 299.00, 40.00, 14.95, 14.95, 339.00, 'Delivered'),
(6, 12, 6, '2025-04-18 10:12:00', 'Chembur, Thane', 200.00, 40.00, 0.00, 10.00, 250.00, 'Delivered'),
(7, 4, 7, '2025-04-21 15:19:00', 'Goregaon, Navi Mumbai', 315.00, 40.00, 0.00, 15.75, 370.75, 'Delivered'),
(8, 11, 8, '2025-04-24 10:26:00', 'Mulund, Mumbai', 420.00, 40.00, 0.00, 21.00, 481.00, 'Delivered'),
(9, 3, 9, '2025-04-27 15:33:00', 'Kothrud, Mumbai', 717.00, 0.00, 0.00, 35.85, 752.85, 'Delivered'),
(10, 10, 10, '2025-04-30 10:40:00', 'Wakad, Mumbai', 340.00, 40.00, 17.00, 17.00, 380.00, 'Delivered'),
(11, 2, 11, '2025-05-03 15:47:00', 'Baner, Pune', 778.00, 0.00, 0.00, 38.90, 816.90, 'Out for Delivery'),
(12, 9, NULL, '2025-05-06 10:54:00', 'Hinjewadi, Pune', 570.00, 0.00, 0.00, 28.50, 598.50, 'Confirmed'),
(13, 1, 13, '2025-05-09 15:01:00', 'Viman Nagar, Thane', 185.00, 40.00, 0.00, 9.25, 234.25, 'Delivered'),
(14, 8, 14, '2025-05-12 10:08:00', 'Airoli, Navi Mumbai', 640.00, 0.00, 0.00, 32.00, 672.00, 'Out for Delivery'),
(15, 15, 15, '2025-05-15 15:15:00', 'Vashi, Mumbai', 450.00, 40.00, 22.50, 22.50, 490.00, 'Delivered'),
(16, 7, 16, '2025-05-18 10:22:00', 'Thane West, Mumbai', 240.00, 40.00, 0.00, 12.00, 292.00, 'Delivered'),
(17, 14, 17, '2025-05-21 15:29:00', 'Kalyan, Mumbai', 810.00, 0.00, 0.00, 40.50, 850.50, 'Delivered'),
(18, 6, 18, '2025-05-24 10:36:00', 'Andheri West, Pune', 400.00, 40.00, 0.00, 20.00, 460.00, 'Delivered'),
(19, 13, NULL, '2025-05-27 15:43:00', 'Bandra West, Pune', 600.00, 0.00, 0.00, 30.00, 630.00, 'Cancelled'),
(20, 5, 20, '2025-05-30 10:50:00', 'Dadar, Thane', 508.00, 0.00, 25.40, 25.40, 508.00, 'Delivered'),
(21, 12, 21, '2025-06-02 15:57:00', 'Powai, Navi Mumbai', 760.00, 0.00, 0.00, 38.00, 798.00, 'Delivered'),
(22, 4, 22, '2025-06-05 10:04:00', 'Borivali, Mumbai', 1596.00, 0.00, 0.00, 79.80, 1675.80, 'Delivered'),
(23, 11, NULL, '2025-06-08 15:11:00', 'Chembur, Mumbai', 400.00, 40.00, 0.00, 20.00, 460.00, 'Placed'),
(24, 3, 24, '2025-06-11 10:18:00', 'Goregaon, Mumbai', 329.00, 40.00, 0.00, 16.45, 385.45, 'Delivered'),
(25, 10, 25, '2025-06-14 15:25:00', 'Mulund, Pune', 340.00, 40.00, 17.00, 17.00, 380.00, 'Delivered'),
(26, 2, 1, '2025-06-17 10:32:00', 'Kothrud, Pune', 1107.00, 0.00, 0.00, 55.35, 1162.35, 'Delivered'),
(27, 9, 2, '2025-06-20 15:39:00', 'Wakad, Thane', 798.00, 0.00, 0.00, 39.90, 837.90, 'Delivered'),
(28, 1, 3, '2025-06-23 10:46:00', 'Baner, Navi Mumbai', 470.00, 40.00, 0.00, 23.50, 533.50, 'Delivered'),
(29, 8, 4, '2025-06-26 15:53:00', 'Hinjewadi, Mumbai', 630.00, 0.00, 0.00, 31.50, 661.50, 'Delivered'),
(30, 15, 5, '2025-06-29 10:00:00', 'Viman Nagar, Mumbai', 250.00, 40.00, 12.50, 12.50, 290.00, 'Delivered'),
(31, 7, 6, '2025-07-02 15:07:00', 'Airoli, Mumbai', 400.00, 40.00, 0.00, 20.00, 460.00, 'Delivered'),
(32, 14, 7, '2025-07-05 10:14:00', 'Vashi, Pune', 1220.00, 0.00, 0.00, 61.00, 1281.00, 'Delivered'),
(33, 6, 8, '2025-07-08 15:21:00', 'Thane West, Pune', 610.00, 0.00, 0.00, 30.50, 640.50, 'Delivered'),
(34, 13, 9, '2025-07-11 10:28:00', 'Kalyan, Thane', 570.00, 0.00, 0.00, 28.50, 598.50, 'Delivered'),
(35, 5, 10, '2025-07-14 15:35:00', 'Andheri West, Navi Mumbai', 797.00, 0.00, 39.85, 39.85, 797.00, 'Delivered'),
(36, 12, 11, '2025-07-17 10:42:00', 'Bandra West, Mumbai', 1250.00, 0.00, 0.00, 62.50, 1312.50, 'Delivered'),
(37, 4, NULL, '2025-07-20 15:49:00', 'Dadar, Mumbai', 1096.00, 0.00, 0.00, 54.80, 1150.80, 'Cancelled'),
(38, 11, 13, '2025-07-23 10:56:00', 'Powai, Mumbai', 400.00, 40.00, 0.00, 20.00, 460.00, 'Delivered'),
(39, 3, 14, '2025-07-26 15:03:00', 'Borivali, Pune', 299.00, 40.00, 0.00, 14.95, 353.95, 'Delivered'),
(40, 10, 15, '2025-07-29 10:10:00', 'Chembur, Pune', 790.00, 0.00, 39.50, 39.50, 790.00, 'Delivered'),
(41, 2, 16, '2025-08-01 15:17:00', 'Goregaon, Thane', 758.00, 0.00, 0.00, 37.90, 795.90, 'Delivered'),
(42, 9, 17, '2025-08-04 10:24:00', 'Mulund, Navi Mumbai', 680.00, 0.00, 0.00, 34.00, 714.00, 'Delivered'),
(43, 1, NULL, '2025-08-07 15:31:00', 'Kothrud, Mumbai', 805.00, 0.00, 0.00, 40.25, 845.25, 'Preparing'),
(44, 8, 19, '2025-08-10 10:38:00', 'Wakad, Mumbai', 740.00, 0.00, 0.00, 37.00, 777.00, 'Delivered'),
(45, 15, 20, '2025-08-13 15:45:00', 'Baner, Mumbai', 450.00, 40.00, 22.50, 22.50, 490.00, 'Delivered'),
(46, 7, 21, '2025-08-16 10:52:00', 'Hinjewadi, Pune', 210.00, 40.00, 0.00, 10.50, 260.50, 'Delivered'),
(47, 14, 22, '2025-08-19 15:59:00', 'Viman Nagar, Pune', 1150.00, 0.00, 0.00, 57.50, 1207.50, 'Delivered'),
(48, 6, 23, '2025-08-22 10:06:00', 'Airoli, Thane', 350.00, 40.00, 0.00, 17.50, 407.50, 'Out for Delivery'),
(49, 13, 24, '2025-08-25 15:13:00', 'Vashi, Navi Mumbai', 420.00, 40.00, 0.00, 21.00, 481.00, 'Delivered'),
(50, 5, 25, '2025-08-28 10:20:00', 'Thane West, Mumbai', 339.00, 40.00, 16.95, 16.95, 379.00, 'Delivered'),
(1, 12, NULL, '2025-08-31 15:27:00', 'Andheri West, Mumbai', 130.00, 40.00, 0.00, 6.50, 176.50, 'Confirmed'),
(2, 4, NULL, '2025-09-03 10:34:00', 'Bandra West, Mumbai', 95.00, 40.00, 0.00, 4.75, 139.75, 'Preparing'),
(3, 11, 3, '2025-09-06 15:41:00', 'Dadar, Mumbai', 210.00, 40.00, 0.00, 10.50, 260.50, 'Delivered'),
(4, 3, 4, '2025-09-09 10:48:00', 'Powai, Pune', 119.00, 40.00, 0.00, 5.95, 164.95, 'Delivered'),
(5, 10, 5, '2025-09-12 15:55:00', 'Borivali, Pune', 220.00, 40.00, 11.00, 11.00, 260.00, 'Delivered'),
(6, 2, NULL, '2025-09-15 10:02:00', 'Chembur, Thane', 598.00, 0.00, 0.00, 29.90, 627.90, 'Cancelled'),
(7, 9, 7, '2025-09-18 15:09:00', 'Goregaon, Navi Mumbai', 440.00, 40.00, 0.00, 22.00, 502.00, 'Delivered'),
(8, 1, 8, '2025-09-21 10:16:00', 'Mulund, Mumbai', 70.00, 40.00, 0.00, 3.50, 113.50, 'Delivered'),
(9, 8, 9, '2025-09-24 15:23:00', 'Kothrud, Mumbai', 310.00, 40.00, 0.00, 15.50, 365.50, 'Delivered'),
(10, 15, 10, '2025-09-27 10:30:00', 'Wakad, Mumbai', 340.00, 40.00, 17.00, 17.00, 380.00, 'Delivered'),
(11, 7, 11, '2025-09-30 15:37:00', 'Baner, Pune', 120.00, 40.00, 0.00, 6.00, 166.00, 'Delivered'),
(12, 14, 12, '2025-10-03 10:44:00', 'Hinjewadi, Pune', 340.00, 40.00, 0.00, 17.00, 397.00, 'Delivered'),
(13, 6, 13, '2025-10-06 15:51:00', 'Viman Nagar, Thane', 360.00, 40.00, 0.00, 18.00, 418.00, 'Out for Delivery'),
(14, 13, 14, '2025-10-09 10:58:00', 'Airoli, Navi Mumbai', 540.00, 0.00, 0.00, 27.00, 567.00, 'Out for Delivery'),
(15, 5, 15, '2025-10-12 15:05:00', 'Vashi, Mumbai', 70.00, 40.00, 3.50, 3.50, 110.00, 'Delivered'),
(16, 12, 16, '2025-10-15 10:12:00', 'Thane West, Mumbai', 470.00, 40.00, 0.00, 23.50, 533.50, 'Delivered'),
(17, 4, NULL, '2025-10-18 15:19:00', 'Kalyan, Mumbai', 279.00, 40.00, 0.00, 13.95, 332.95, 'Cancelled'),
(18, 11, 18, '2025-10-21 10:26:00', 'Andheri West, Pune', 60.00, 40.00, 0.00, 3.00, 103.00, 'Delivered'),
(19, 3, NULL, '2025-10-24 15:33:00', 'Bandra West, Pune', 170.00, 40.00, 0.00, 8.50, 218.50, 'Cancelled'),
(20, 10, 20, '2025-10-27 10:40:00', 'Dadar, Thane', 180.00, 40.00, 9.00, 9.00, 220.00, 'Delivered'),
(21, 2, 21, '2025-10-30 15:47:00', 'Powai, Navi Mumbai', 160.00, 40.00, 0.00, 8.00, 208.00, 'Delivered'),
(22, 9, 22, '2025-11-02 10:54:00', 'Borivali, Mumbai', 200.00, 40.00, 0.00, 10.00, 250.00, 'Delivered'),
(23, 1, 23, '2025-11-05 15:01:00', 'Chembur, Mumbai', 520.00, 0.00, 0.00, 26.00, 546.00, 'Delivered'),
(24, 8, NULL, '2025-11-08 10:08:00', 'Goregaon, Mumbai', 460.00, 40.00, 0.00, 23.00, 523.00, 'Cancelled'),
(25, 15, 25, '2025-11-11 15:15:00', 'Mulund, Pune', 340.00, 40.00, 17.00, 17.00, 380.00, 'Delivered'),
(26, 7, 1, '2025-11-14 10:22:00', 'Kothrud, Pune', 180.00, 40.00, 0.00, 9.00, 229.00, 'Delivered'),
(27, 14, 2, '2025-11-17 15:29:00', 'Wakad, Thane', 430.00, 40.00, 0.00, 21.50, 491.50, 'Delivered'),
(28, 6, 3, '2025-11-20 10:36:00', 'Baner, Navi Mumbai', 250.00, 40.00, 0.00, 12.50, 302.50, 'Out for Delivery'),
(29, 13, 4, '2025-11-23 15:43:00', 'Hinjewadi, Mumbai', 300.00, 40.00, 0.00, 15.00, 355.00, 'Delivered'),
(30, 5, 5, '2025-11-26 10:50:00', 'Viman Nagar, Mumbai', 70.00, 40.00, 3.50, 3.50, 110.00, 'Delivered'),
(31, 12, 6, '2025-11-29 15:57:00', 'Airoli, Mumbai', 130.00, 40.00, 0.00, 6.50, 176.50, 'Delivered'),
(32, 4, 7, '2025-12-02 10:04:00', 'Vashi, Pune', 698.00, 0.00, 0.00, 34.90, 732.90, 'Delivered'),
(33, 11, 8, '2025-12-05 15:11:00', 'Thane West, Pune', 60.00, 40.00, 0.00, 3.00, 103.00, 'Delivered'),
(34, 3, 9, '2025-12-08 10:18:00', 'Kalyan, Thane', 170.00, 40.00, 0.00, 8.50, 218.50, 'Delivered'),
(35, 10, 10, '2025-12-11 15:25:00', 'Andheri West, Navi Mumbai', 240.00, 40.00, 12.00, 12.00, 280.00, 'Delivered'),
(36, 2, 11, '2025-12-14 10:32:00', 'Bandra West, Mumbai', 399.00, 40.00, 0.00, 19.95, 458.95, 'Delivered'),
(37, 9, 12, '2025-12-17 15:39:00', 'Dadar, Mumbai', 250.00, 40.00, 0.00, 12.50, 302.50, 'Delivered'),
(38, 1, 13, '2025-12-20 10:46:00', 'Powai, Mumbai', 45.00, 40.00, 0.00, 2.25, 87.25, 'Delivered'),
(39, 8, 14, '2025-12-23 15:53:00', 'Borivali, Pune', 740.00, 0.00, 0.00, 37.00, 777.00, 'Delivered'),
(40, 15, NULL, '2025-12-26 10:00:00', 'Chembur, Pune', 170.00, 40.00, 8.50, 8.50, 210.00, 'Confirmed'),
(41, 7, 16, '2025-12-29 15:07:00', 'Goregaon, Thane', 240.00, 40.00, 0.00, 12.00, 292.00, 'Delivered'),
(42, 14, 17, '2026-01-01 10:14:00', 'Mulund, Navi Mumbai', 860.00, 0.00, 0.00, 43.00, 903.00, 'Delivered'),
(43, 6, 18, '2026-01-04 15:21:00', 'Kothrud, Mumbai', 360.00, 40.00, 0.00, 18.00, 418.00, 'Delivered'),
(44, 13, 19, '2025-01-07 10:28:00', 'Wakad, Mumbai', 420.00, 40.00, 0.00, 21.00, 481.00, 'Delivered'),
(45, 5, 20, '2025-01-10 15:35:00', 'Baner, Mumbai', 438.00, 40.00, 21.90, 21.90, 478.00, 'Delivered'),
(46, 12, 21, '2025-01-13 10:42:00', 'Hinjewadi, Pune', 620.00, 0.00, 0.00, 31.00, 651.00, 'Delivered'),
(47, 4, 22, '2025-01-16 15:49:00', 'Viman Nagar, Pune', 898.00, 0.00, 0.00, 44.90, 942.90, 'Delivered'),
(48, 11, 23, '2025-01-19 10:56:00', 'Airoli, Thane', 560.00, 0.00, 0.00, 28.00, 588.00, 'Delivered'),
(49, 3, 24, '2025-01-22 15:03:00', 'Vashi, Navi Mumbai', 80.00, 40.00, 0.00, 4.00, 124.00, 'Delivered'),
(50, 10, 25, '2025-01-25 10:10:00', 'Thane West, Mumbai', 440.00, 40.00, 22.00, 22.00, 480.00, 'Delivered'),
(1, 2, 1, '2025-01-28 15:17:00', 'Andheri West, Mumbai', 160.00, 40.00, 0.00, 8.00, 208.00, 'Delivered'),
(2, 9, 2, '2025-01-31 10:24:00', 'Bandra West, Mumbai', 780.00, 0.00, 0.00, 39.00, 819.00, 'Delivered'),
(3, 1, 3, '2025-02-03 15:31:00', 'Dadar, Mumbai', 320.00, 40.00, 0.00, 16.00, 376.00, 'Delivered'),
(4, 8, 4, '2025-02-06 10:38:00', 'Powai, Pune', 310.00, 40.00, 0.00, 15.50, 365.50, 'Out for Delivery'),
(5, 15, 5, '2025-02-09 15:45:00', 'Borivali, Pune', 170.00, 40.00, 8.50, 8.50, 210.00, 'Delivered'),
(6, 7, 6, '2025-02-12 10:52:00', 'Chembur, Thane', 80.00, 40.00, 0.00, 4.00, 124.00, 'Delivered'),
(7, 14, 7, '2025-02-15 15:59:00', 'Goregaon, Navi Mumbai', 430.00, 40.00, 0.00, 21.50, 491.50, 'Delivered'),
(8, 6, 8, '2025-02-18 10:06:00', 'Mulund, Mumbai', 250.00, 40.00, 0.00, 12.50, 302.50, 'Delivered'),
(9, 13, 9, '2025-02-21 15:13:00', 'Kothrud, Mumbai', 400.00, 40.00, 0.00, 20.00, 460.00, 'Delivered'),
(10, 5, 10, '2025-02-24 10:20:00', 'Wakad, Mumbai', 239.00, 40.00, 11.95, 11.95, 279.00, 'Delivered'),
(11, 12, NULL, '2025-02-27 15:27:00', 'Baner, Pune', 70.00, 40.00, 0.00, 3.50, 113.50, 'Cancelled'),
(12, 4, 12, '2025-03-02 10:34:00', 'Hinjewadi, Pune', 349.00, 40.00, 0.00, 17.45, 406.45, 'Delivered'),
(13, 11, 13, '2025-03-05 15:41:00', 'Viman Nagar, Thane', 320.00, 40.00, 0.00, 16.00, 376.00, 'Delivered'),
(14, 3, 14, '2025-03-08 10:48:00', 'Airoli, Navi Mumbai', 249.00, 40.00, 0.00, 12.45, 301.45, 'Delivered'),
(15, 10, 15, '2025-03-11 15:55:00', 'Vashi, Mumbai', 250.00, 40.00, 12.50, 12.50, 290.00, 'Delivered'),
(16, 2, 16, '2025-03-14 10:02:00', 'Thane West, Mumbai', 299.00, 40.00, 0.00, 14.95, 353.95, 'Delivered'),
(17, 9, 17, '2025-03-17 15:09:00', 'Kalyan, Mumbai', 220.00, 40.00, 0.00, 11.00, 271.00, 'Delivered'),
(18, 1, NULL, '2025-03-20 10:16:00', 'Andheri West, Pune', 440.00, 40.00, 0.00, 22.00, 502.00, 'Confirmed'),
(19, 8, NULL, '2025-03-23 15:23:00', 'Bandra West, Pune', 370.00, 40.00, 0.00, 18.50, 428.50, 'Confirmed'),
(20, 15, 20, '2025-03-26 10:30:00', 'Dadar, Thane', 170.00, 40.00, 8.50, 8.50, 210.00, 'Delivered'),
(21, 7, 21, '2025-03-29 15:37:00', 'Powai, Navi Mumbai', 60.00, 40.00, 0.00, 3.00, 103.00, 'Delivered'),
(22, 14, 22, '2025-04-01 10:44:00', 'Borivali, Mumbai', 380.00, 40.00, 0.00, 19.00, 439.00, 'Delivered'),
(23, 6, NULL, '2025-04-04 15:51:00', 'Chembur, Mumbai', 280.00, 40.00, 0.00, 14.00, 334.00, 'Preparing'),
(24, 13, 24, '2025-04-07 10:58:00', 'Goregaon, Mumbai', 180.00, 40.00, 0.00, 9.00, 229.00, 'Delivered'),
(25, 5, NULL, '2025-04-10 15:05:00', 'Mulund, Pune', 70.00, 40.00, 3.50, 3.50, 110.00, 'Confirmed'),
(26, 12, 1, '2025-04-13 10:12:00', 'Kothrud, Pune', 620.00, 0.00, 0.00, 31.00, 651.00, 'Delivered'),
(27, 4, 2, '2025-04-16 15:19:00', 'Wakad, Thane', 279.00, 40.00, 0.00, 13.95, 332.95, 'Delivered'),
(28, 11, 3, '2025-04-19 10:26:00', 'Baner, Navi Mumbai', 230.00, 40.00, 0.00, 11.50, 281.50, 'Delivered'),
(29, 3, 4, '2025-04-22 15:33:00', 'Hinjewadi, Mumbai', 238.00, 40.00, 0.00, 11.90, 289.90, 'Delivered'),
(30, 10, 5, '2025-04-25 10:40:00', 'Viman Nagar, Mumbai', 60.00, 40.00, 3.00, 3.00, 100.00, 'Delivered'),
(31, 2, 6, '2025-04-28 15:47:00', 'Airoli, Mumbai', 120.00, 40.00, 0.00, 6.00, 166.00, 'Delivered'),
(32, 9, NULL, '2025-05-01 10:54:00', 'Vashi, Pune', 100.00, 40.00, 0.00, 5.00, 145.00, 'Confirmed'),
(33, 1, 8, '2025-05-04 15:01:00', 'Thane West, Pune', 45.00, 40.00, 0.00, 2.25, 87.25, 'Delivered'),
(34, 8, 9, '2025-05-07 10:08:00', 'Kalyan, Thane', 620.00, 0.00, 0.00, 31.00, 651.00, 'Delivered'),
(35, 15, NULL, '2025-05-10 15:15:00', 'Andheri West, Navi Mumbai', 140.00, 40.00, 7.00, 7.00, 180.00, 'Cancelled'),
(36, 7, 11, '2025-05-13 10:22:00', 'Bandra West, Mumbai', 180.00, 40.00, 0.00, 9.00, 229.00, 'Delivered'),
(37, 14, 12, '2025-05-16 15:29:00', 'Dadar, Mumbai', 760.00, 0.00, 0.00, 38.00, 798.00, 'Delivered'),
(38, 6, 13, '2025-05-19 10:36:00', 'Powai, Mumbai', 440.00, 40.00, 0.00, 22.00, 502.00, 'Delivered'),
(39, 13, 14, '2025-05-22 15:43:00', 'Borivali, Pune', 540.00, 0.00, 0.00, 27.00, 567.00, 'Delivered'),
(40, 5, 15, '2025-05-25 10:50:00', 'Chembur, Pune', 70.00, 40.00, 3.50, 3.50, 110.00, 'Delivered'),
(41, 12, 16, '2025-05-28 15:57:00', 'Goregaon, Thane', 740.00, 0.00, 0.00, 37.00, 777.00, 'Delivered'),
(42, 4, 17, '2025-05-31 10:04:00', 'Mulund, Navi Mumbai', 269.00, 40.00, 0.00, 13.45, 322.45, 'Delivered'),
(43, 11, NULL, '2025-06-03 15:11:00', 'Kothrud, Mumbai', 560.00, 0.00, 0.00, 28.00, 588.00, 'Preparing'),
(44, 3, 19, '2025-06-06 10:18:00', 'Wakad, Mumbai', 219.00, 40.00, 0.00, 10.95, 269.95, 'Delivered'),
(45, 10, 20, '2025-06-09 15:25:00', 'Baner, Mumbai', 580.00, 0.00, 29.00, 29.00, 580.00, 'Delivered'),
(46, 2, 21, '2025-06-12 10:32:00', 'Hinjewadi, Pune', 309.00, 40.00, 0.00, 15.45, 364.45, 'Delivered'),
(47, 9, 22, '2025-06-15 15:39:00', 'Viman Nagar, Pune', 180.00, 40.00, 0.00, 9.00, 229.00, 'Delivered'),
(48, 1, 23, '2025-06-18 10:46:00', 'Airoli, Thane', 220.00, 40.00, 0.00, 11.00, 271.00, 'Delivered'),
(49, 8, 24, '2025-06-21 15:53:00', 'Vashi, Navi Mumbai', 230.00, 40.00, 0.00, 11.50, 281.50, 'Delivered'),
(50, 15, 25, '2025-06-24 10:00:00', 'Thane West, Mumbai', 110.00, 40.00, 5.50, 5.50, 150.00, 'Delivered');

-- 8. ORDER ITEMS: 500 RECORDS
INSERT INTO order_items (order_id, item_id, quantity, unit_price, subtotal) VALUES
(1, 48, 2, 60.00, 120.00),
(1, 49, 1, 80.00, 80.00),
(2, 96, 1, 60.00, 60.00),
(2, 94, 1, 340.00, 340.00),
(3, 36, 2, 220.00, 440.00),
(3, 40, 1, 150.00, 150.00),
(4, 87, 1, 210.00, 210.00),
(4, 85, 1, 190.00, 190.00),
(5, 35, 1, 70.00, 70.00),
(5, 33, 2, 239.00, 478.00),
(6, 78, 1, 370.00, 370.00),
(6, 79, 1, 470.00, 470.00),
(7, 28, 1, 110.00, 110.00),
(7, 23, 2, 449.00, 898.00),
(8, 75, 1, 210.00, 210.00),
(8, 72, 1, 280.00, 280.00),
(9, 15, 1, 179.00, 179.00),
(9, 18, 1, 119.00, 119.00),
(10, 66, 1, 180.00, 180.00),
(10, 70, 1, 60.00, 60.00),
(11, 9, 1, 399.00, 399.00),
(11, 10, 1, 449.00, 449.00),
(12, 59, 1, 250.00, 250.00),
(12, 60, 2, 220.00, 440.00),
(13, 1, 1, 320.00, 320.00),
(13, 7, 2, 90.00, 180.00),
(14, 50, 1, 310.00, 310.00),
(14, 56, 1, 230.00, 230.00),
(15, 98, 2, 150.00, 300.00),
(15, 100, 2, 140.00, 280.00),
(16, 45, 1, 120.00, 120.00),
(16, 49, 2, 80.00, 160.00),
(17, 96, 1, 60.00, 60.00),
(17, 93, 2, 430.00, 860.00),
(18, 41, 1, 140.00, 140.00),
(18, 40, 2, 150.00, 300.00),
(19, 87, 2, 210.00, 420.00),
(19, 85, 1, 190.00, 190.00),
(20, 29, 2, 229.00, 458.00),
(20, 35, 1, 70.00, 70.00),
(21, 80, 1, 290.00, 290.00),
(21, 82, 1, 70.00, 70.00),
(22, 27, 2, 95.00, 190.00),
(22, 28, 1, 110.00, 110.00),
(23, 73, 1, 230.00, 230.00),
(23, 71, 1, 240.00, 240.00),
(24, 17, 1, 249.00, 249.00),
(24, 15, 2, 179.00, 358.00),
(25, 69, 1, 90.00, 90.00),
(25, 66, 1, 180.00, 180.00),
(26, 13, 1, 120.00, 120.00),
(26, 11, 1, 329.00, 329.00),
(27, 62, 1, 100.00, 100.00),
(27, 58, 2, 320.00, 640.00),
(28, 5, 1, 260.00, 260.00),
(28, 7, 1, 90.00, 90.00),
(29, 52, 2, 320.00, 640.00),
(29, 56, 2, 230.00, 460.00),
(30, 97, 1, 110.00, 110.00),
(30, 98, 1, 150.00, 150.00),
(31, 43, 2, 150.00, 300.00),
(31, 45, 2, 120.00, 240.00),
(32, 94, 2, 340.00, 680.00),
(32, 95, 2, 380.00, 760.00),
(33, 37, 2, 250.00, 500.00),
(33, 42, 2, 130.00, 260.00),
(34, 88, 1, 180.00, 180.00),
(34, 85, 2, 190.00, 380.00),
(35, 35, 2, 70.00, 140.00),
(35, 32, 2, 259.00, 518.00),
(36, 84, 1, 130.00, 130.00),
(36, 79, 2, 470.00, 940.00),
(37, 22, 2, 349.00, 698.00),
(37, 25, 2, 329.00, 658.00),
(38, 72, 2, 280.00, 560.00),
(38, 77, 1, 140.00, 140.00),
(39, 17, 1, 249.00, 249.00),
(39, 16, 1, 219.00, 219.00),
(40, 67, 1, 220.00, 220.00),
(40, 66, 1, 180.00, 180.00),
(41, 14, 1, 160.00, 160.00),
(41, 10, 1, 449.00, 449.00),
(42, 62, 1, 100.00, 100.00),
(42, 61, 1, 299.00, 299.00),
(43, 3, 1, 380.00, 380.00),
(43, 2, 2, 220.00, 440.00),
(44, 50, 1, 310.00, 310.00),
(44, 56, 1, 230.00, 230.00),
(45, 99, 1, 170.00, 170.00),
(45, 98, 1, 150.00, 150.00),
(46, 46, 1, 110.00, 110.00),
(46, 47, 1, 160.00, 160.00),
(47, 94, 1, 340.00, 340.00),
(47, 91, 2, 280.00, 560.00),
(48, 41, 2, 140.00, 280.00),
(48, 42, 2, 130.00, 260.00),
(49, 86, 1, 270.00, 270.00),
(49, 87, 2, 210.00, 420.00),
(50, 31, 1, 219.00, 219.00),
(50, 33, 2, 239.00, 478.00),
(51, 83, 1, 75.00, 75.00),
(51, 80, 1, 290.00, 290.00),
(52, 24, 1, 279.00, 279.00),
(52, 25, 1, 329.00, 329.00),
(53, 72, 1, 280.00, 280.00),
(53, 74, 1, 160.00, 160.00),
(54, 20, 1, 80.00, 80.00),
(54, 16, 1, 219.00, 219.00),
(55, 68, 1, 240.00, 240.00),
(55, 64, 1, 250.00, 250.00),
(56, 14, 1, 160.00, 160.00),
(56, 12, 1, 309.00, 309.00),
(57, 60, 1, 220.00, 220.00),
(57, 63, 1, 90.00, 90.00),
(58, 7, 1, 90.00, 90.00),
(58, 6, 1, 70.00, 70.00),
(59, 54, 1, 410.00, 410.00),
(59, 55, 1, 90.00, 90.00),
(60, 98, 1, 150.00, 150.00),
(60, 99, 2, 170.00, 340.00),
(61, 44, 1, 180.00, 180.00),
(61, 43, 2, 150.00, 300.00),
(62, 95, 1, 380.00, 380.00),
(62, 91, 2, 280.00, 560.00),
(63, 40, 1, 150.00, 150.00),
(63, 37, 1, 250.00, 250.00),
(64, 88, 1, 180.00, 180.00),
(64, 86, 1, 270.00, 270.00),
(65, 35, 2, 70.00, 140.00),
(65, 29, 1, 229.00, 229.00),
(66, 84, 1, 130.00, 130.00),
(66, 83, 1, 75.00, 75.00),
(67, 23, 1, 449.00, 449.00),
(67, 22, 2, 349.00, 698.00),
(68, 76, 2, 60.00, 120.00),
(68, 75, 1, 210.00, 210.00),
(69, 21, 1, 170.00, 170.00),
(69, 18, 1, 119.00, 119.00),
(70, 68, 2, 240.00, 480.00),
(70, 67, 1, 220.00, 220.00),
(71, 9, 2, 399.00, 798.00),
(71, 13, 1, 120.00, 120.00),
(72, 63, 2, 90.00, 180.00),
(72, 58, 1, 320.00, 320.00),
(73, 7, 1, 90.00, 90.00),
(73, 5, 1, 260.00, 260.00),
(74, 53, 1, 330.00, 330.00),
(74, 50, 1, 310.00, 310.00),
(75, 99, 2, 170.00, 340.00),
(75, 98, 1, 150.00, 150.00),
(76, 44, 1, 180.00, 180.00),
(76, 49, 1, 80.00, 80.00),
(77, 92, 1, 360.00, 360.00),
(77, 91, 1, 280.00, 280.00),
(78, 39, 1, 180.00, 180.00),
(78, 42, 2, 130.00, 260.00),
(79, 88, 2, 180.00, 360.00),
(79, 89, 1, 200.00, 200.00),
(80, 35, 1, 70.00, 70.00),
(80, 33, 1, 239.00, 239.00),
(81, 80, 2, 290.00, 580.00),
(81, 84, 2, 130.00, 260.00),
(82, 28, 1, 110.00, 110.00),
(82, 25, 2, 329.00, 658.00),
(83, 77, 2, 140.00, 280.00),
(83, 75, 1, 210.00, 210.00),
(84, 17, 1, 249.00, 249.00),
(84, 18, 1, 119.00, 119.00),
(85, 69, 2, 90.00, 180.00),
(85, 70, 2, 60.00, 120.00),
(86, 14, 2, 160.00, 320.00),
(86, 11, 2, 329.00, 658.00),
(87, 61, 2, 299.00, 598.00),
(87, 57, 1, 390.00, 390.00),
(88, 6, 1, 70.00, 70.00),
(88, 1, 1, 320.00, 320.00),
(89, 56, 1, 230.00, 230.00),
(89, 53, 1, 330.00, 330.00),
(90, 99, 1, 170.00, 170.00),
(90, 97, 1, 110.00, 110.00),
(91, 46, 2, 110.00, 220.00),
(91, 45, 2, 120.00, 240.00),
(92, 93, 1, 430.00, 430.00),
(92, 91, 2, 280.00, 560.00),
(93, 36, 1, 220.00, 220.00),
(93, 38, 1, 280.00, 280.00),
(94, 90, 2, 150.00, 300.00),
(94, 85, 2, 190.00, 380.00),
(95, 30, 1, 269.00, 269.00),
(95, 29, 1, 229.00, 229.00),
(96, 81, 1, 310.00, 310.00),
(96, 83, 2, 75.00, 150.00),
(97, 25, 1, 329.00, 329.00),
(97, 27, 1, 95.00, 95.00),
(98, 75, 2, 210.00, 420.00),
(98, 77, 1, 140.00, 140.00),
(99, 21, 2, 170.00, 340.00),
(99, 16, 1, 219.00, 219.00),
(100, 64, 1, 250.00, 250.00),
(100, 66, 2, 180.00, 360.00),
(101, 11, 2, 329.00, 658.00),
(101, 14, 1, 160.00, 160.00),
(102, 61, 2, 299.00, 598.00),
(102, 62, 1, 100.00, 100.00),
(103, 6, 2, 70.00, 140.00),
(103, 3, 1, 380.00, 380.00),
(104, 50, 2, 310.00, 620.00),
(104, 54, 1, 410.00, 410.00),
(105, 100, 1, 140.00, 140.00),
(105, 99, 1, 170.00, 170.00),
(106, 45, 2, 120.00, 240.00),
(106, 43, 2, 150.00, 300.00),
(107, 91, 2, 280.00, 560.00),
(107, 94, 1, 340.00, 340.00),
(108, 42, 1, 130.00, 130.00),
(108, 39, 1, 180.00, 180.00),
(109, 90, 2, 150.00, 300.00),
(109, 89, 1, 200.00, 200.00),
(110, 35, 2, 70.00, 140.00),
(110, 33, 1, 239.00, 239.00),
(111, 84, 1, 130.00, 130.00),
(111, 83, 1, 75.00, 75.00),
(112, 23, 1, 449.00, 449.00),
(112, 22, 1, 349.00, 349.00),
(113, 77, 1, 140.00, 140.00),
(113, 74, 1, 160.00, 160.00),
(114, 17, 1, 249.00, 249.00),
(114, 15, 1, 179.00, 179.00),
(115, 67, 1, 220.00, 220.00),
(115, 65, 1, 290.00, 290.00),
(116, 10, 1, 449.00, 449.00),
(116, 12, 1, 309.00, 309.00),
(117, 57, 2, 390.00, 780.00),
(117, 61, 1, 299.00, 299.00),
(118, 6, 1, 70.00, 70.00),
(118, 4, 2, 45.00, 90.00),
(119, 55, 1, 90.00, 90.00),
(119, 53, 1, 330.00, 330.00),
(120, 97, 1, 110.00, 110.00),
(120, 100, 1, 140.00, 140.00),
(121, 44, 1, 180.00, 180.00),
(121, 45, 1, 120.00, 120.00),
(122, 95, 1, 380.00, 380.00),
(122, 96, 2, 60.00, 120.00),
(123, 40, 1, 150.00, 150.00),
(123, 38, 1, 280.00, 280.00),
(124, 87, 1, 210.00, 210.00),
(124, 90, 2, 150.00, 300.00),
(125, 31, 2, 219.00, 438.00),
(125, 29, 2, 229.00, 458.00),
(126, 83, 1, 75.00, 75.00),
(126, 79, 2, 470.00, 940.00),
(127, 24, 1, 279.00, 279.00),
(127, 27, 2, 95.00, 190.00),
(128, 75, 2, 210.00, 420.00),
(128, 73, 2, 230.00, 460.00),
(129, 17, 1, 249.00, 249.00),
(129, 16, 1, 219.00, 219.00),
(130, 69, 1, 90.00, 90.00),
(130, 68, 1, 240.00, 240.00),
(131, 8, 1, 299.00, 299.00),
(131, 12, 2, 309.00, 618.00),
(132, 62, 1, 100.00, 100.00),
(132, 60, 1, 220.00, 220.00),
(133, 3, 1, 380.00, 380.00),
(133, 4, 1, 45.00, 45.00),
(134, 50, 2, 310.00, 620.00),
(134, 52, 1, 320.00, 320.00),
(135, 97, 1, 110.00, 110.00),
(135, 98, 1, 150.00, 150.00),
(136, 48, 1, 60.00, 60.00),
(136, 43, 2, 150.00, 300.00),
(137, 93, 2, 430.00, 860.00),
(137, 91, 1, 280.00, 280.00),
(138, 42, 1, 130.00, 130.00),
(138, 39, 2, 180.00, 360.00),
(139, 86, 1, 270.00, 270.00),
(139, 89, 2, 200.00, 400.00),
(140, 31, 2, 219.00, 438.00),
(140, 33, 1, 239.00, 239.00),
(141, 82, 1, 70.00, 70.00),
(141, 78, 2, 370.00, 740.00),
(142, 28, 1, 110.00, 110.00),
(142, 23, 1, 449.00, 449.00),
(143, 71, 1, 240.00, 240.00),
(143, 72, 1, 280.00, 280.00),
(144, 16, 1, 219.00, 219.00),
(144, 15, 1, 179.00, 179.00),
(145, 67, 1, 220.00, 220.00),
(145, 66, 1, 180.00, 180.00),
(146, 10, 2, 449.00, 898.00),
(146, 13, 1, 120.00, 120.00),
(147, 58, 2, 320.00, 640.00),
(147, 59, 1, 250.00, 250.00),
(148, 6, 1, 70.00, 70.00),
(148, 2, 1, 220.00, 220.00),
(149, 55, 2, 90.00, 180.00),
(149, 51, 2, 370.00, 740.00),
(150, 97, 1, 110.00, 110.00),
(150, 100, 1, 140.00, 140.00),
(151, 48, 2, 60.00, 120.00),
(151, 47, 1, 160.00, 160.00),
(152, 94, 1, 340.00, 340.00),
(152, 93, 2, 430.00, 860.00),
(153, 40, 1, 150.00, 150.00),
(153, 42, 1, 130.00, 130.00),
(154, 85, 2, 190.00, 380.00),
(154, 88, 1, 180.00, 180.00),
(155, 29, 1, 229.00, 229.00),
(155, 35, 1, 70.00, 70.00),
(156, 84, 1, 130.00, 130.00),
(156, 82, 1, 70.00, 70.00),
(157, 28, 2, 110.00, 220.00),
(157, 27, 1, 95.00, 95.00),
(158, 77, 1, 140.00, 140.00),
(158, 72, 1, 280.00, 280.00),
(159, 17, 2, 249.00, 498.00),
(159, 16, 1, 219.00, 219.00),
(160, 70, 2, 60.00, 120.00),
(160, 67, 1, 220.00, 220.00),
(161, 11, 1, 329.00, 329.00),
(161, 10, 1, 449.00, 449.00),
(162, 58, 1, 320.00, 320.00),
(162, 59, 1, 250.00, 250.00),
(163, 6, 2, 70.00, 140.00),
(163, 4, 1, 45.00, 45.00),
(164, 53, 1, 330.00, 330.00),
(164, 50, 1, 310.00, 310.00),
(165, 100, 2, 140.00, 280.00),
(165, 99, 1, 170.00, 170.00),
(166, 49, 1, 80.00, 80.00),
(166, 47, 1, 160.00, 160.00),
(167, 95, 1, 380.00, 380.00),
(167, 93, 1, 430.00, 430.00),
(168, 39, 1, 180.00, 180.00),
(168, 36, 1, 220.00, 220.00),
(169, 87, 2, 210.00, 420.00),
(169, 88, 1, 180.00, 180.00),
(170, 29, 1, 229.00, 229.00),
(170, 34, 1, 279.00, 279.00),
(171, 79, 1, 470.00, 470.00),
(171, 80, 1, 290.00, 290.00),
(172, 22, 2, 349.00, 698.00),
(172, 23, 2, 449.00, 898.00),
(173, 74, 1, 160.00, 160.00),
(173, 71, 1, 240.00, 240.00),
(174, 20, 1, 80.00, 80.00),
(174, 17, 1, 249.00, 249.00),
(175, 70, 2, 60.00, 120.00),
(175, 67, 1, 220.00, 220.00),
(176, 12, 1, 309.00, 309.00),
(176, 9, 2, 399.00, 798.00),
(177, 61, 2, 299.00, 598.00),
(177, 62, 2, 100.00, 200.00),
(178, 3, 1, 380.00, 380.00),
(178, 4, 2, 45.00, 90.00),
(179, 52, 1, 320.00, 320.00),
(179, 50, 1, 310.00, 310.00),
(180, 100, 1, 140.00, 140.00),
(180, 97, 1, 110.00, 110.00),
(181, 45, 2, 120.00, 240.00),
(181, 47, 1, 160.00, 160.00),
(182, 93, 2, 430.00, 860.00),
(182, 92, 1, 360.00, 360.00),
(183, 39, 2, 180.00, 360.00),
(183, 37, 1, 250.00, 250.00),
(184, 87, 1, 210.00, 210.00),
(184, 88, 2, 180.00, 360.00),
(185, 32, 2, 259.00, 518.00),
(185, 34, 1, 279.00, 279.00),
(186, 79, 2, 470.00, 940.00),
(186, 81, 1, 310.00, 310.00),
(187, 26, 2, 269.00, 538.00),
(187, 24, 2, 279.00, 558.00),
(188, 74, 1, 160.00, 160.00),
(188, 71, 1, 240.00, 240.00),
(189, 20, 1, 80.00, 80.00),
(189, 16, 1, 219.00, 219.00),
(190, 65, 1, 290.00, 290.00),
(190, 64, 2, 250.00, 500.00),
(191, 10, 1, 449.00, 449.00),
(191, 12, 1, 309.00, 309.00),
(192, 63, 2, 90.00, 180.00),
(192, 59, 2, 250.00, 500.00),
(193, 4, 1, 45.00, 45.00),
(193, 3, 2, 380.00, 760.00),
(194, 53, 1, 330.00, 330.00),
(194, 54, 1, 410.00, 410.00),
(195, 99, 2, 170.00, 340.00),
(195, 97, 1, 110.00, 110.00),
(196, 43, 1, 150.00, 150.00),
(196, 48, 1, 60.00, 60.00),
(197, 92, 2, 360.00, 720.00),
(197, 93, 1, 430.00, 430.00),
(198, 42, 1, 130.00, 130.00),
(198, 36, 1, 220.00, 220.00),
(199, 86, 1, 270.00, 270.00),
(199, 90, 1, 150.00, 150.00),
(200, 35, 1, 70.00, 70.00),
(200, 30, 1, 269.00, 269.00),
(201, 84, 1, 130.00, 130.00),
(202, 27, 1, 95.00, 95.00),
(203, 75, 1, 210.00, 210.00),
(204, 18, 1, 119.00, 119.00),
(205, 67, 1, 220.00, 220.00),
(206, 8, 2, 299.00, 598.00),
(207, 60, 2, 220.00, 440.00),
(208, 6, 1, 70.00, 70.00),
(209, 50, 1, 310.00, 310.00),
(210, 99, 2, 170.00, 340.00),
(211, 45, 1, 120.00, 120.00),
(212, 94, 1, 340.00, 340.00),
(213, 39, 2, 180.00, 360.00),
(214, 86, 2, 270.00, 540.00),
(215, 35, 1, 70.00, 70.00),
(216, 79, 1, 470.00, 470.00),
(217, 24, 1, 279.00, 279.00),
(218, 76, 1, 60.00, 60.00),
(219, 21, 1, 170.00, 170.00),
(220, 66, 1, 180.00, 180.00),
(221, 14, 1, 160.00, 160.00),
(222, 62, 2, 100.00, 200.00),
(223, 5, 2, 260.00, 520.00),
(224, 56, 2, 230.00, 460.00),
(225, 99, 2, 170.00, 340.00),
(226, 44, 1, 180.00, 180.00),
(227, 93, 1, 430.00, 430.00),
(228, 37, 1, 250.00, 250.00),
(229, 90, 2, 150.00, 300.00),
(230, 35, 1, 70.00, 70.00),
(231, 84, 1, 130.00, 130.00),
(232, 22, 2, 349.00, 698.00),
(233, 76, 1, 60.00, 60.00),
(234, 21, 1, 170.00, 170.00),
(235, 68, 1, 240.00, 240.00),
(236, 9, 1, 399.00, 399.00),
(237, 59, 1, 250.00, 250.00),
(238, 4, 1, 45.00, 45.00),
(239, 51, 2, 370.00, 740.00),
(240, 99, 1, 170.00, 170.00),
(241, 45, 2, 120.00, 240.00),
(242, 93, 2, 430.00, 860.00),
(243, 39, 2, 180.00, 360.00),
(244, 87, 2, 210.00, 420.00),
(245, 31, 2, 219.00, 438.00),
(246, 81, 2, 310.00, 620.00),
(247, 23, 2, 449.00, 898.00),
(248, 72, 2, 280.00, 560.00),
(249, 20, 1, 80.00, 80.00),
(250, 67, 2, 220.00, 440.00),
(251, 14, 1, 160.00, 160.00),
(252, 57, 2, 390.00, 780.00),
(253, 1, 1, 320.00, 320.00),
(254, 50, 1, 310.00, 310.00),
(255, 99, 1, 170.00, 170.00),
(256, 49, 1, 80.00, 80.00),
(257, 93, 1, 430.00, 430.00),
(258, 37, 1, 250.00, 250.00),
(259, 89, 2, 200.00, 400.00),
(260, 33, 1, 239.00, 239.00),
(261, 82, 1, 70.00, 70.00),
(262, 22, 1, 349.00, 349.00),
(263, 74, 2, 160.00, 320.00),
(264, 17, 1, 249.00, 249.00),
(265, 64, 1, 250.00, 250.00),
(266, 8, 1, 299.00, 299.00),
(267, 60, 1, 220.00, 220.00),
(268, 2, 2, 220.00, 440.00),
(269, 51, 1, 370.00, 370.00),
(270, 99, 1, 170.00, 170.00),
(271, 48, 1, 60.00, 60.00),
(272, 95, 1, 380.00, 380.00),
(273, 41, 2, 140.00, 280.00),
(274, 88, 1, 180.00, 180.00),
(275, 35, 1, 70.00, 70.00),
(276, 81, 2, 310.00, 620.00),
(277, 24, 1, 279.00, 279.00),
(278, 73, 1, 230.00, 230.00),
(279, 18, 2, 119.00, 238.00),
(280, 70, 1, 60.00, 60.00),
(281, 13, 1, 120.00, 120.00),
(282, 62, 1, 100.00, 100.00),
(283, 4, 1, 45.00, 45.00),
(284, 50, 2, 310.00, 620.00),
(285, 100, 1, 140.00, 140.00),
(286, 44, 1, 180.00, 180.00),
(287, 95, 2, 380.00, 760.00),
(288, 36, 2, 220.00, 440.00),
(289, 86, 2, 270.00, 540.00),
(290, 35, 1, 70.00, 70.00),
(291, 78, 2, 370.00, 740.00),
(292, 26, 1, 269.00, 269.00),
(293, 72, 2, 280.00, 560.00),
(294, 16, 1, 219.00, 219.00),
(295, 65, 2, 290.00, 580.00),
(296, 12, 1, 309.00, 309.00),
(297, 63, 2, 90.00, 180.00),
(298, 2, 1, 220.00, 220.00),
(299, 56, 1, 230.00, 230.00),
(300, 97, 1, 110.00, 110.00);

-- 9. PAYMENTS: 300 RECORDS
INSERT INTO payments (order_id, payment_date, payment_method, amount, payment_status, transaction_reference) VALUES
(1, '2025-01-08 15:10:00', 'UPI', 250.00, 'Successful', 'FR202501080001'),
(2, '2025-01-11 10:17:00', 'Credit Card', 460.00, 'Refunded', 'FR202501110002'),
(3, '2025-01-14 15:24:00', 'Debit Card', 619.50, 'Successful', 'FR202501140003'),
(4, '2025-01-17 10:31:00', 'Cash', 460.00, 'Successful', 'FR202501170004'),
(5, '2025-01-20 15:38:00', 'Wallet', 548.00, 'Successful', 'FR202501200005'),
(6, '2025-01-23 10:45:00', 'Net Banking', 882.00, 'Refunded', 'FR202501230006'),
(7, '2025-01-26 15:52:00', 'UPI', 1058.40, 'Successful', 'FR202501260007'),
(8, '2025-01-29 10:59:00', 'Credit Card', 554.50, 'Successful', 'FR202501290008'),
(9, '2025-02-01 15:06:00', 'Debit Card', 352.90, 'Successful', 'FR202502010009'),
(10, '2025-02-04 10:13:00', 'Cash', 280.00, 'Successful', 'FR202502040010'),
(11, '2025-02-07 15:20:00', 'Wallet', 890.40, 'Successful', 'FR202502070011'),
(12, '2025-02-10 10:27:00', 'Net Banking', 724.50, 'Successful', 'FR202502100012'),
(13, '2025-02-13 15:34:00', 'UPI', 525.00, 'Successful', 'FR202502130013'),
(14, '2025-02-16 10:41:00', 'Credit Card', 567.00, 'Successful', 'FR202502160014'),
(15, '2025-02-19 15:48:00', 'Debit Card', 580.00, 'Successful', 'FR202502190015'),
(16, '2025-02-22 10:55:00', 'Cash', 334.00, 'Successful', 'FR202502220016'),
(17, '2025-02-25 16:02:00', 'Wallet', 966.00, 'Successful', 'FR202502250017'),
(18, '2025-02-28 10:09:00', 'Net Banking', 502.00, 'Successful', 'FR202502280018'),
(19, '2025-03-03 15:16:00', 'UPI', 640.50, 'Successful', 'FR202503030019'),
(20, '2025-03-06 10:23:00', 'Credit Card', 528.00, 'Successful', 'FR202503060020'),
(21, '2025-03-09 15:30:00', 'Debit Card', 418.00, 'Failed', 'FR202503090021'),
(22, '2025-03-12 10:37:00', 'Cash', 355.00, 'Successful', 'FR202503120022'),
(23, '2025-03-15 15:44:00', 'Wallet', 533.50, 'Successful', 'FR202503150023'),
(24, '2025-03-18 10:51:00', 'Net Banking', 637.35, 'Refunded', 'FR202503180024'),
(25, '2025-03-21 15:58:00', 'UPI', 310.00, 'Successful', 'FR202503210025'),
(26, '2025-03-24 10:05:00', 'Credit Card', 511.45, 'Successful', 'FR202503240026'),
(27, '2025-03-27 15:12:00', 'Debit Card', 777.00, 'Failed', 'FR202503270027'),
(28, '2025-03-30 10:19:00', 'Cash', 407.50, 'Successful', 'FR202503300028'),
(29, '2025-04-02 15:26:00', 'Wallet', 1155.00, 'Successful', 'FR202504020029'),
(30, '2025-04-05 10:33:00', 'Net Banking', 300.00, 'Successful', 'FR202504050030'),
(31, '2025-04-08 15:40:00', 'UPI', 567.00, 'Successful', 'FR202504080031'),
(32, '2025-04-11 10:47:00', 'Credit Card', 1512.00, 'Successful', 'FR202504110032'),
(33, '2025-04-14 15:54:00', 'Debit Card', 798.00, 'Successful', 'FR202504140033'),
(34, '2025-04-17 11:01:00', 'Cash', 588.00, 'Successful', 'FR202504170034'),
(35, '2025-04-20 15:08:00', 'Wallet', 658.00, 'Failed', 'FR202504200035'),
(36, '2025-04-23 10:15:00', 'Net Banking', 1123.50, 'Successful', 'FR202504230036'),
(37, '2025-04-26 15:22:00', 'UPI', 1423.80, 'Failed', 'FR202504260037'),
(38, '2025-04-29 10:29:00', 'Credit Card', 735.00, 'Successful', 'FR202504290038'),
(39, '2025-05-02 15:36:00', 'Debit Card', 531.40, 'Successful', 'FR202505020039'),
(40, '2025-05-05 10:43:00', 'Cash', 440.00, 'Successful', 'FR202505050040'),
(41, '2025-05-08 15:50:00', 'Wallet', 639.45, 'Failed', 'FR202505080041'),
(42, '2025-05-11 10:57:00', 'Net Banking', 458.95, 'Refunded', 'FR202505110042'),
(43, '2025-05-14 15:04:00', 'UPI', 861.00, 'Successful', 'FR202505140043'),
(44, '2025-05-17 10:11:00', 'Credit Card', 567.00, 'Successful', 'FR202505170044'),
(45, '2025-05-20 15:18:00', 'Debit Card', 360.00, 'Successful', 'FR202505200045'),
(46, '2025-05-23 10:25:00', 'Cash', 323.50, 'Successful', 'FR202505230046'),
(47, '2025-05-26 15:32:00', 'Wallet', 945.00, 'Successful', 'FR202505260047'),
(48, '2025-05-29 10:39:00', 'Net Banking', 567.00, 'Successful', 'FR202505290048'),
(49, '2025-06-01 15:46:00', 'UPI', 724.50, 'Successful', 'FR202506010049'),
(50, '2025-06-04 10:53:00', 'Credit Card', 697.00, 'Successful', 'FR202506040050'),
(51, '2025-06-07 16:00:00', 'Debit Card', 423.25, 'Successful', 'FR202506070051'),
(52, '2025-06-10 10:07:00', 'Cash', 638.40, 'Successful', 'FR202506100052'),
(53, '2025-06-13 15:14:00', 'Wallet', 502.00, 'Successful', 'FR202506130053'),
(54, '2025-06-16 10:21:00', 'Net Banking', 353.95, 'Refunded', 'FR202506160054'),
(55, '2025-06-19 15:28:00', 'UPI', 530.00, 'Successful', 'FR202506190055'),
(56, '2025-06-22 10:35:00', 'Credit Card', 532.45, 'Successful', 'FR202506220056'),
(57, '2025-06-25 15:42:00', 'Debit Card', 365.50, 'Successful', 'FR202506250057'),
(58, '2025-06-28 10:49:00', 'Cash', 208.00, 'Successful', 'FR202506280058'),
(59, '2025-07-01 15:56:00', 'Wallet', 525.00, 'Successful', 'FR202507010059'),
(60, '2025-07-04 10:03:00', 'Net Banking', 530.00, 'Successful', 'FR202507040060'),
(61, '2025-07-07 15:10:00', 'UPI', 544.00, 'Failed', 'FR202507070061'),
(62, '2025-07-10 10:17:00', 'Credit Card', 987.00, 'Refunded', 'FR202507100062'),
(63, '2025-07-13 15:24:00', 'Debit Card', 460.00, 'Successful', 'FR202507130063'),
(64, '2025-07-16 10:31:00', 'Cash', 512.50, 'Refunded', 'FR202507160064'),
(65, '2025-07-19 15:38:00', 'Wallet', 409.00, 'Successful', 'FR202507190065'),
(66, '2025-07-22 10:45:00', 'Net Banking', 255.25, 'Successful', 'FR202507220066'),
(67, '2025-07-25 15:52:00', 'UPI', 1204.35, 'Failed', 'FR202507250067'),
(68, '2025-07-28 10:59:00', 'Credit Card', 386.50, 'Successful', 'FR202507280068'),
(69, '2025-07-31 15:06:00', 'Debit Card', 343.45, 'Successful', 'FR202507310069'),
(70, '2025-08-03 10:13:00', 'Cash', 700.00, 'Successful', 'FR202508030070'),
(71, '2025-08-06 15:20:00', 'Wallet', 963.90, 'Successful', 'FR202508060071'),
(72, '2025-08-09 10:27:00', 'Net Banking', 525.00, 'Successful', 'FR202508090072'),
(73, '2025-08-12 15:34:00', 'UPI', 407.50, 'Successful', 'FR202508120073'),
(74, '2025-08-15 10:41:00', 'Credit Card', 672.00, 'Pending', 'FR202508150074'),
(75, '2025-08-18 15:48:00', 'Debit Card', 530.00, 'Successful', 'FR202508180075'),
(76, '2025-08-21 10:55:00', 'Cash', 313.00, 'Successful', 'FR202508210076'),
(77, '2025-08-24 16:02:00', 'Wallet', 672.00, 'Successful', 'FR202508240077'),
(78, '2025-08-27 10:09:00', 'Net Banking', 502.00, 'Successful', 'FR202508270078'),
(79, '2025-08-30 15:16:00', 'UPI', 588.00, 'Successful', 'FR202508300079'),
(80, '2025-09-02 10:23:00', 'Credit Card', 349.00, 'Successful', 'FR202509020080'),
(81, '2025-09-05 15:30:00', 'Debit Card', 882.00, 'Successful', 'FR202509050081'),
(82, '2025-09-08 10:37:00', 'Cash', 806.40, 'Successful', 'FR202509080082'),
(83, '2025-09-11 15:44:00', 'Wallet', 554.50, 'Successful', 'FR202509110083'),
(84, '2025-09-14 10:51:00', 'Net Banking', 426.40, 'Successful', 'FR202509140084'),
(85, '2025-09-17 15:58:00', 'UPI', 340.00, 'Successful', 'FR202509170085'),
(86, '2025-09-20 10:05:00', 'Credit Card', 1026.90, 'Successful', 'FR202509200086'),
(87, '2025-09-23 15:12:00', 'Debit Card', 1037.40, 'Successful', 'FR202509230087'),
(88, '2025-09-26 10:19:00', 'Cash', 449.50, 'Successful', 'FR202509260088'),
(89, '2025-09-29 15:26:00', 'Wallet', 588.00, 'Successful', 'FR202509290089'),
(90, '2025-10-02 10:33:00', 'Net Banking', 320.00, 'Successful', 'FR202510020090'),
(91, '2025-10-05 15:40:00', 'UPI', 523.00, 'Successful', 'FR202510050091'),
(92, '2025-10-08 10:47:00', 'Credit Card', 1039.50, 'Successful', 'FR202510080092'),
(93, '2025-10-11 15:54:00', 'Debit Card', 525.00, 'Successful', 'FR202510110093'),
(94, '2025-10-14 11:01:00', 'Cash', 714.00, 'Successful', 'FR202510140094'),
(95, '2025-10-17 15:08:00', 'Wallet', 538.00, 'Successful', 'FR202510170095'),
(96, '2025-10-20 10:15:00', 'Net Banking', 523.00, 'Successful', 'FR202510200096'),
(97, '2025-10-23 15:22:00', 'UPI', 485.20, 'Successful', 'FR202510230097'),
(98, '2025-10-26 10:29:00', 'Credit Card', 588.00, 'Refunded', 'FR202510260098'),
(99, '2025-10-29 15:36:00', 'Debit Card', 586.95, 'Successful', 'FR202510290099'),
(100, '2025-11-01 10:43:00', 'Cash', 610.00, 'Successful', 'FR202511010100'),
(101, '2025-11-04 15:50:00', 'Wallet', 858.90, 'Successful', 'FR202511040101'),
(102, '2025-11-07 10:57:00', 'Net Banking', 732.90, 'Successful', 'FR202511070102'),
(103, '2025-11-10 15:04:00', 'UPI', 546.00, 'Successful', 'FR202511100103'),
(104, '2025-11-13 10:11:00', 'Credit Card', 1081.50, 'Successful', 'FR202511130104'),
(105, '2025-11-16 15:18:00', 'Debit Card', 350.00, 'Successful', 'FR202511160105'),
(106, '2025-11-19 10:25:00', 'Cash', 567.00, 'Successful', 'FR202511190106'),
(107, '2025-11-22 15:32:00', 'Wallet', 945.00, 'Successful', 'FR202511220107'),
(108, '2025-11-25 10:39:00', 'Net Banking', 365.50, 'Successful', 'FR202511250108'),
(109, '2025-11-28 15:46:00', 'UPI', 525.00, 'Successful', 'FR202511280109'),
(110, '2025-12-01 10:53:00', 'Credit Card', 419.00, 'Successful', 'FR202512010110'),
(111, '2025-12-04 16:00:00', 'Debit Card', 255.25, 'Pending', 'FR202512040111'),
(112, '2025-12-07 10:07:00', 'Cash', 837.90, 'Successful', 'FR202512070112'),
(113, '2025-12-10 15:14:00', 'Wallet', 355.00, 'Successful', 'FR202512100113'),
(114, '2025-12-13 10:21:00', 'Net Banking', 489.40, 'Successful', 'FR202512130114'),
(115, '2025-12-16 15:28:00', 'UPI', 510.00, 'Successful', 'FR202512160115'),
(116, '2025-12-19 10:35:00', 'Credit Card', 795.90, 'Successful', 'FR202512190116'),
(117, '2025-12-22 15:42:00', 'Debit Card', 1132.95, 'Successful', 'FR202512220117'),
(118, '2025-12-25 10:49:00', 'Cash', 208.00, 'Successful', 'FR202512250118'),
(119, '2025-12-28 15:56:00', 'Wallet', 481.00, 'Successful', 'FR202512280119'),
(120, '2025-12-31 10:03:00', 'Net Banking', 290.00, 'Successful', 'FR202512310120'),
(121, '2026-01-03 15:10:00', 'UPI', 355.00, 'Successful', 'FR202601030121'),
(122, '2025-01-06 10:17:00', 'Credit Card', 525.00, 'Successful', 'FR202501060122'),
(123, '2025-01-09 15:24:00', 'Debit Card', 491.50, 'Successful', 'FR202501090123'),
(124, '2025-01-12 10:31:00', 'Cash', 535.50, 'Successful', 'FR202501120124'),
(125, '2025-01-15 15:38:00', 'Wallet', 896.00, 'Successful', 'FR202501150125'),
(126, '2025-01-18 10:45:00', 'Net Banking', 1065.75, 'Successful', 'FR202501180126'),
(127, '2025-01-21 15:52:00', 'UPI', 532.45, 'Successful', 'FR202501210127'),
(128, '2025-01-24 10:59:00', 'Credit Card', 924.00, 'Successful', 'FR202501240128'),
(129, '2025-01-27 15:06:00', 'Debit Card', 531.40, 'Successful', 'FR202501270129'),
(130, '2025-01-30 10:13:00', 'Cash', 370.00, 'Successful', 'FR202501300130'),
(131, '2025-02-02 15:20:00', 'Wallet', 962.85, 'Successful', 'FR202502020131'),
(132, '2025-02-05 10:27:00', 'Net Banking', 376.00, 'Successful', 'FR202502050132'),
(133, '2025-02-08 15:34:00', 'UPI', 486.25, 'Successful', 'FR202502080133'),
(134, '2025-02-11 10:41:00', 'Credit Card', 987.00, 'Successful', 'FR202502110134'),
(135, '2025-02-14 15:48:00', 'Debit Card', 300.00, 'Failed', 'FR202502140135'),
(136, '2025-02-17 10:55:00', 'Cash', 418.00, 'Refunded', 'FR202502170136'),
(137, '2025-02-20 16:02:00', 'Wallet', 1197.00, 'Failed', 'FR202502200137'),
(138, '2025-02-23 10:09:00', 'Net Banking', 554.50, 'Successful', 'FR202502230138'),
(139, '2025-02-26 15:16:00', 'UPI', 703.50, 'Successful', 'FR202502260139'),
(140, '2025-03-01 10:23:00', 'Credit Card', 677.00, 'Successful', 'FR202503010140'),
(141, '2025-03-04 15:30:00', 'Debit Card', 850.50, 'Failed', 'FR202503040141'),
(142, '2025-03-07 10:37:00', 'Cash', 586.95, 'Successful', 'FR202503070142'),
(143, '2025-03-10 15:44:00', 'Wallet', 546.00, 'Successful', 'FR202503100143'),
(144, '2025-03-13 10:51:00', 'Net Banking', 457.90, 'Successful', 'FR202503130144'),
(145, '2025-03-16 15:58:00', 'UPI', 440.00, 'Successful', 'FR202503160145'),
(146, '2025-03-19 10:05:00', 'Credit Card', 1068.90, 'Successful', 'FR202503190146'),
(147, '2025-03-22 15:12:00', 'Debit Card', 934.50, 'Failed', 'FR202503220147'),
(148, '2025-03-25 10:19:00', 'Cash', 344.50, 'Pending', 'FR202503250148'),
(149, '2025-03-28 15:26:00', 'Wallet', 966.00, 'Failed', 'FR202503280149'),
(150, '2025-03-31 10:33:00', 'Net Banking', 290.00, 'Successful', 'FR202503310150'),
(151, '2025-04-03 15:40:00', 'UPI', 334.00, 'Successful', 'FR202504030151'),
(152, '2025-04-06 10:47:00', 'Credit Card', 1260.00, 'Successful', 'FR202504060152'),
(153, '2025-04-09 15:54:00', 'Debit Card', 334.00, 'Failed', 'FR202504090153'),
(154, '2025-04-12 11:01:00', 'Cash', 588.00, 'Successful', 'FR202504120154'),
(155, '2025-04-15 15:08:00', 'Wallet', 339.00, 'Successful', 'FR202504150155'),
(156, '2025-04-18 10:15:00', 'Net Banking', 250.00, 'Successful', 'FR202504180156'),
(157, '2025-04-21 15:22:00', 'UPI', 370.75, 'Successful', 'FR202504210157'),
(158, '2025-04-24 10:29:00', 'Credit Card', 481.00, 'Successful', 'FR202504240158'),
(159, '2025-04-27 15:36:00', 'Debit Card', 752.85, 'Successful', 'FR202504270159'),
(160, '2025-04-30 10:43:00', 'Cash', 380.00, 'Successful', 'FR202504300160'),
(161, '2025-05-03 15:50:00', 'Wallet', 816.90, 'Successful', 'FR202505030161'),
(162, '2025-05-06 10:57:00', 'Net Banking', 598.50, 'Successful', 'FR202505060162'),
(163, '2025-05-09 15:04:00', 'UPI', 234.25, 'Successful', 'FR202505090163'),
(164, '2025-05-12 10:11:00', 'Credit Card', 672.00, 'Successful', 'FR202505120164'),
(165, '2025-05-15 15:18:00', 'Debit Card', 490.00, 'Successful', 'FR202505150165'),
(166, '2025-05-18 10:25:00', 'Cash', 292.00, 'Successful', 'FR202505180166'),
(167, '2025-05-21 15:32:00', 'Wallet', 850.50, 'Successful', 'FR202505210167'),
(168, '2025-05-24 10:39:00', 'Net Banking', 460.00, 'Successful', 'FR202505240168'),
(169, '2025-05-27 15:46:00', 'UPI', 630.00, 'Failed', 'FR202505270169'),
(170, '2025-05-30 10:53:00', 'Credit Card', 508.00, 'Successful', 'FR202505300170'),
(171, '2025-06-02 16:00:00', 'Debit Card', 798.00, 'Successful', 'FR202506020171'),
(172, '2025-06-05 10:07:00', 'Cash', 1675.80, 'Successful', 'FR202506050172'),
(173, '2025-06-08 15:14:00', 'Wallet', 460.00, 'Successful', 'FR202506080173'),
(174, '2025-06-11 10:21:00', 'Net Banking', 385.45, 'Successful', 'FR202506110174'),
(175, '2025-06-14 15:28:00', 'UPI', 380.00, 'Successful', 'FR202506140175'),
(176, '2025-06-17 10:35:00', 'Credit Card', 1162.35, 'Successful', 'FR202506170176'),
(177, '2025-06-20 15:42:00', 'Debit Card', 837.90, 'Successful', 'FR202506200177'),
(178, '2025-06-23 10:49:00', 'Cash', 533.50, 'Successful', 'FR202506230178'),
(179, '2025-06-26 15:56:00', 'Wallet', 661.50, 'Successful', 'FR202506260179'),
(180, '2025-06-29 10:03:00', 'Net Banking', 290.00, 'Successful', 'FR202506290180'),
(181, '2025-07-02 15:10:00', 'UPI', 460.00, 'Successful', 'FR202507020181'),
(182, '2025-07-05 10:17:00', 'Credit Card', 1281.00, 'Successful', 'FR202507050182'),
(183, '2025-07-08 15:24:00', 'Debit Card', 640.50, 'Successful', 'FR202507080183'),
(184, '2025-07-11 10:31:00', 'Cash', 598.50, 'Successful', 'FR202507110184'),
(185, '2025-07-14 15:38:00', 'Wallet', 797.00, 'Pending', 'FR202507140185'),
(186, '2025-07-17 10:45:00', 'Net Banking', 1312.50, 'Successful', 'FR202507170186'),
(187, '2025-07-20 15:52:00', 'UPI', 1150.80, 'Failed', 'FR202507200187'),
(188, '2025-07-23 10:59:00', 'Credit Card', 460.00, 'Successful', 'FR202507230188'),
(189, '2025-07-26 15:06:00', 'Debit Card', 353.95, 'Successful', 'FR202507260189'),
(190, '2025-07-29 10:13:00', 'Cash', 790.00, 'Successful', 'FR202507290190'),
(191, '2025-08-01 15:20:00', 'Wallet', 795.90, 'Successful', 'FR202508010191'),
(192, '2025-08-04 10:27:00', 'Net Banking', 714.00, 'Successful', 'FR202508040192'),
(193, '2025-08-07 15:34:00', 'UPI', 845.25, 'Successful', 'FR202508070193'),
(194, '2025-08-10 10:41:00', 'Credit Card', 777.00, 'Successful', 'FR202508100194'),
(195, '2025-08-13 15:48:00', 'Debit Card', 490.00, 'Successful', 'FR202508130195'),
(196, '2025-08-16 10:55:00', 'Cash', 260.50, 'Successful', 'FR202508160196'),
(197, '2025-08-19 16:02:00', 'Wallet', 1207.50, 'Successful', 'FR202508190197'),
(198, '2025-08-22 10:09:00', 'Net Banking', 407.50, 'Successful', 'FR202508220198'),
(199, '2025-08-25 15:16:00', 'UPI', 481.00, 'Successful', 'FR202508250199'),
(200, '2025-08-28 10:23:00', 'Credit Card', 379.00, 'Successful', 'FR202508280200'),
(201, '2025-08-31 15:30:00', 'Debit Card', 176.50, 'Successful', 'FR202508310201'),
(202, '2025-09-03 10:37:00', 'Cash', 139.75, 'Successful', 'FR202509030202'),
(203, '2025-09-06 15:44:00', 'Wallet', 260.50, 'Successful', 'FR202509060203'),
(204, '2025-09-09 10:51:00', 'Net Banking', 164.95, 'Successful', 'FR202509090204'),
(205, '2025-09-12 15:58:00', 'UPI', 260.00, 'Successful', 'FR202509120205'),
(206, '2025-09-15 10:05:00', 'Credit Card', 627.90, 'Refunded', 'FR202509150206'),
(207, '2025-09-18 15:12:00', 'Debit Card', 502.00, 'Successful', 'FR202509180207'),
(208, '2025-09-21 10:19:00', 'Cash', 113.50, 'Successful', 'FR202509210208'),
(209, '2025-09-24 15:26:00', 'Wallet', 365.50, 'Successful', 'FR202509240209'),
(210, '2025-09-27 10:33:00', 'Net Banking', 380.00, 'Successful', 'FR202509270210'),
(211, '2025-09-30 15:40:00', 'UPI', 166.00, 'Successful', 'FR202509300211'),
(212, '2025-10-03 10:47:00', 'Credit Card', 397.00, 'Successful', 'FR202510030212'),
(213, '2025-10-06 15:54:00', 'Debit Card', 418.00, 'Successful', 'FR202510060213'),
(214, '2025-10-09 11:01:00', 'Cash', 567.00, 'Successful', 'FR202510090214'),
(215, '2025-10-12 15:08:00', 'Wallet', 110.00, 'Successful', 'FR202510120215'),
(216, '2025-10-15 10:15:00', 'Net Banking', 533.50, 'Successful', 'FR202510150216'),
(217, '2025-10-18 15:22:00', 'UPI', 332.95, 'Failed', 'FR202510180217'),
(218, '2025-10-21 10:29:00', 'Credit Card', 103.00, 'Successful', 'FR202510210218'),
(219, '2025-10-24 15:36:00', 'Debit Card', 218.50, 'Failed', 'FR202510240219'),
(220, '2025-10-27 10:43:00', 'Cash', 220.00, 'Successful', 'FR202510270220'),
(221, '2025-10-30 15:50:00', 'Wallet', 208.00, 'Successful', 'FR202510300221'),
(222, '2025-11-02 10:57:00', 'Net Banking', 250.00, 'Pending', 'FR202511020222'),
(223, '2025-11-05 15:04:00', 'UPI', 546.00, 'Successful', 'FR202511050223'),
(224, '2025-11-08 10:11:00', 'Credit Card', 523.00, 'Refunded', 'FR202511080224'),
(225, '2025-11-11 15:18:00', 'Debit Card', 380.00, 'Successful', 'FR202511110225'),
(226, '2025-11-14 10:25:00', 'Cash', 229.00, 'Successful', 'FR202511140226'),
(227, '2025-11-17 15:32:00', 'Wallet', 491.50, 'Successful', 'FR202511170227'),
(228, '2025-11-20 10:39:00', 'Net Banking', 302.50, 'Successful', 'FR202511200228'),
(229, '2025-11-23 15:46:00', 'UPI', 355.00, 'Successful', 'FR202511230229'),
(230, '2025-11-26 10:53:00', 'Credit Card', 110.00, 'Successful', 'FR202511260230'),
(231, '2025-11-29 16:00:00', 'Debit Card', 176.50, 'Successful', 'FR202511290231'),
(232, '2025-12-02 10:07:00', 'Cash', 732.90, 'Successful', 'FR202512020232'),
(233, '2025-12-05 15:14:00', 'Wallet', 103.00, 'Successful', 'FR202512050233'),
(234, '2025-12-08 10:21:00', 'Net Banking', 218.50, 'Successful', 'FR202512080234'),
(235, '2025-12-11 15:28:00', 'UPI', 280.00, 'Successful', 'FR202512110235'),
(236, '2025-12-14 10:35:00', 'Credit Card', 458.95, 'Successful', 'FR202512140236'),
(237, '2025-12-17 15:42:00', 'Debit Card', 302.50, 'Successful', 'FR202512170237'),
(238, '2025-12-20 10:49:00', 'Cash', 87.25, 'Successful', 'FR202512200238'),
(239, '2025-12-23 15:56:00', 'Wallet', 777.00, 'Successful', 'FR202512230239'),
(240, '2025-12-26 10:03:00', 'Net Banking', 210.00, 'Successful', 'FR202512260240'),
(241, '2025-12-29 15:10:00', 'UPI', 292.00, 'Successful', 'FR202512290241'),
(242, '2026-01-01 10:17:00', 'Credit Card', 903.00, 'Successful', 'FR202601010242'),
(243, '2026-01-04 15:24:00', 'Debit Card', 418.00, 'Successful', 'FR202601040243'),
(244, '2025-01-07 10:31:00', 'Cash', 481.00, 'Successful', 'FR202501070244'),
(245, '2025-01-10 15:38:00', 'Wallet', 478.00, 'Successful', 'FR202501100245'),
(246, '2025-01-13 10:45:00', 'Net Banking', 651.00, 'Successful', 'FR202501130246'),
(247, '2025-01-16 15:52:00', 'UPI', 942.90, 'Successful', 'FR202501160247'),
(248, '2025-01-19 10:59:00', 'Credit Card', 588.00, 'Successful', 'FR202501190248'),
(249, '2025-01-22 15:06:00', 'Debit Card', 124.00, 'Successful', 'FR202501220249'),
(250, '2025-01-25 10:13:00', 'Cash', 480.00, 'Successful', 'FR202501250250'),
(251, '2025-01-28 15:20:00', 'Wallet', 208.00, 'Successful', 'FR202501280251'),
(252, '2025-01-31 10:27:00', 'Net Banking', 819.00, 'Successful', 'FR202501310252'),
(253, '2025-02-03 15:34:00', 'UPI', 376.00, 'Successful', 'FR202502030253'),
(254, '2025-02-06 10:41:00', 'Credit Card', 365.50, 'Successful', 'FR202502060254'),
(255, '2025-02-09 15:48:00', 'Debit Card', 210.00, 'Successful', 'FR202502090255'),
(256, '2025-02-12 10:55:00', 'Cash', 124.00, 'Successful', 'FR202502120256'),
(257, '2025-02-15 16:02:00', 'Wallet', 491.50, 'Successful', 'FR202502150257'),
(258, '2025-02-18 10:09:00', 'Net Banking', 302.50, 'Successful', 'FR202502180258'),
(259, '2025-02-21 15:16:00', 'UPI', 460.00, 'Pending', 'FR202502210259'),
(260, '2025-02-24 10:23:00', 'Credit Card', 279.00, 'Successful', 'FR202502240260'),
(261, '2025-02-27 15:30:00', 'Debit Card', 113.50, 'Failed', 'FR202502270261'),
(262, '2025-03-02 10:37:00', 'Cash', 406.45, 'Successful', 'FR202503020262'),
(263, '2025-03-05 15:44:00', 'Wallet', 376.00, 'Successful', 'FR202503050263'),
(264, '2025-03-08 10:51:00', 'Net Banking', 301.45, 'Successful', 'FR202503080264'),
(265, '2025-03-11 15:58:00', 'UPI', 290.00, 'Successful', 'FR202503110265'),
(266, '2025-03-14 10:05:00', 'Credit Card', 353.95, 'Successful', 'FR202503140266'),
(267, '2025-03-17 15:12:00', 'Debit Card', 271.00, 'Successful', 'FR202503170267'),
(268, '2025-03-20 10:19:00', 'Cash', 502.00, 'Successful', 'FR202503200268'),
(269, '2025-03-23 15:26:00', 'Wallet', 428.50, 'Successful', 'FR202503230269'),
(270, '2025-03-26 10:33:00', 'Net Banking', 210.00, 'Successful', 'FR202503260270'),
(271, '2025-03-29 15:40:00', 'UPI', 103.00, 'Successful', 'FR202503290271'),
(272, '2025-04-01 10:47:00', 'Credit Card', 439.00, 'Successful', 'FR202504010272'),
(273, '2025-04-04 15:54:00', 'Debit Card', 334.00, 'Successful', 'FR202504040273'),
(274, '2025-04-07 11:01:00', 'Cash', 229.00, 'Successful', 'FR202504070274'),
(275, '2025-04-10 15:08:00', 'Wallet', 110.00, 'Successful', 'FR202504100275'),
(276, '2025-04-13 10:15:00', 'Net Banking', 651.00, 'Successful', 'FR202504130276'),
(277, '2025-04-16 15:22:00', 'UPI', 332.95, 'Successful', 'FR202504160277'),
(278, '2025-04-19 10:29:00', 'Credit Card', 281.50, 'Successful', 'FR202504190278'),
(279, '2025-04-22 15:36:00', 'Debit Card', 289.90, 'Successful', 'FR202504220279'),
(280, '2025-04-25 10:43:00', 'Cash', 100.00, 'Successful', 'FR202504250280'),
(281, '2025-04-28 15:50:00', 'Wallet', 166.00, 'Successful', 'FR202504280281'),
(282, '2025-05-01 10:57:00', 'Net Banking', 145.00, 'Successful', 'FR202505010282'),
(283, '2025-05-04 15:04:00', 'UPI', 87.25, 'Successful', 'FR202505040283'),
(284, '2025-05-07 10:11:00', 'Credit Card', 651.00, 'Successful', 'FR202505070284'),
(285, '2025-05-10 15:18:00', 'Debit Card', 180.00, 'Failed', 'FR202505100285'),
(286, '2025-05-13 10:25:00', 'Cash', 229.00, 'Successful', 'FR202505130286'),
(287, '2025-05-16 15:32:00', 'Wallet', 798.00, 'Successful', 'FR202505160287'),
(288, '2025-05-19 10:39:00', 'Net Banking', 502.00, 'Successful', 'FR202505190288'),
(289, '2025-05-22 15:46:00', 'UPI', 567.00, 'Successful', 'FR202505220289'),
(290, '2025-05-25 10:53:00', 'Credit Card', 110.00, 'Successful', 'FR202505250290'),
(291, '2025-05-28 16:00:00', 'Debit Card', 777.00, 'Successful', 'FR202505280291'),
(292, '2025-05-31 10:07:00', 'Cash', 322.45, 'Successful', 'FR202505310292'),
(293, '2025-06-03 15:14:00', 'Wallet', 588.00, 'Successful', 'FR202506030293'),
(294, '2025-06-06 10:21:00', 'Net Banking', 269.95, 'Successful', 'FR202506060294'),
(295, '2025-06-09 15:28:00', 'UPI', 580.00, 'Successful', 'FR202506090295'),
(296, '2025-06-12 10:35:00', 'Credit Card', 364.45, 'Pending', 'FR202506120296'),
(297, '2025-06-15 15:42:00', 'Debit Card', 229.00, 'Successful', 'FR202506150297'),
(298, '2025-06-18 10:49:00', 'Cash', 271.00, 'Successful', 'FR202506180298'),
(299, '2025-06-21 15:56:00', 'Wallet', 281.50, 'Successful', 'FR202506210299'),
(300, '2025-06-24 10:03:00', 'Net Banking', 150.00, 'Successful', 'FR202506240300');

-- 10. DELIVERIES: 250 RECORDS
INSERT INTO deliveries (order_id, delivery_partner_id, assigned_time, pickup_time, delivery_time, delivery_status) VALUES
(1, 1, '2025-01-08 15:12:00', '2025-01-08 15:28:00', '2025-01-08 15:49:00', 'Delivered'),
(3, 3, '2025-01-14 15:26:00', '2025-01-14 15:44:00', '2025-01-14 16:07:00', 'Delivered'),
(4, 4, '2025-01-17 10:33:00', '2025-01-17 10:52:00', '2025-01-17 11:16:00', 'Delivered'),
(5, 5, '2025-01-20 15:40:00', '2025-01-20 16:00:00', '2025-01-20 16:25:00', 'Delivered'),
(7, 7, '2025-01-26 15:54:00', '2025-01-26 16:16:00', '2025-01-26 16:43:00', 'Delivered'),
(8, 8, '2025-01-29 11:01:00', '2025-01-29 11:24:00', '2025-01-29 11:52:00', 'Delivered'),
(9, 9, '2025-02-01 15:08:00', '2025-02-01 15:32:00', '2025-02-01 16:01:00', 'Delivered'),
(10, 10, '2025-02-04 10:15:00', '2025-02-04 10:30:00', '2025-02-04 11:00:00', 'Delivered'),
(11, 11, '2025-02-07 15:22:00', '2025-02-07 15:38:00', '2025-02-07 16:09:00', 'Delivered'),
(12, 12, '2025-02-10 10:29:00', '2025-02-10 10:46:00', NULL, 'Assigned'),
(13, 13, '2025-02-13 15:36:00', '2025-02-13 15:54:00', '2025-02-13 16:27:00', 'Delivered'),
(14, 14, '2025-02-16 10:43:00', '2025-02-16 11:02:00', '2025-02-16 11:36:00', 'Delivered'),
(15, 15, '2025-02-19 15:50:00', '2025-02-19 16:10:00', '2025-02-19 16:45:00', 'Delivered'),
(16, 16, '2025-02-22 10:57:00', '2025-02-22 11:18:00', NULL, 'Assigned'),
(17, 17, '2025-02-25 16:04:00', '2025-02-25 16:26:00', NULL, 'Assigned'),
(18, 18, '2025-02-28 10:11:00', '2025-02-28 10:34:00', '2025-02-28 11:12:00', 'Delivered'),
(19, 19, '2025-03-03 15:18:00', '2025-03-03 15:42:00', '2025-03-03 16:21:00', 'Delivered'),
(20, 20, '2025-03-06 10:25:00', '2025-03-06 10:40:00', '2025-03-06 11:20:00', 'Delivered'),
(22, 22, '2025-03-12 10:39:00', '2025-03-12 10:56:00', '2025-03-12 11:38:00', 'Delivered'),
(23, 23, '2025-03-15 15:46:00', '2025-03-15 16:04:00', '2025-03-15 16:47:00', 'Delivered'),
(25, 25, '2025-03-21 16:00:00', '2025-03-21 16:20:00', '2025-03-21 16:40:00', 'Delivered'),
(26, 1, '2025-03-24 10:07:00', '2025-03-24 10:28:00', '2025-03-24 10:49:00', 'Delivered'),
(28, 3, '2025-03-30 10:21:00', '2025-03-30 10:44:00', '2025-03-30 11:07:00', 'Delivered'),
(29, 4, '2025-04-02 15:28:00', '2025-04-02 15:52:00', '2025-04-02 16:16:00', 'Delivered'),
(30, 5, '2025-04-05 10:35:00', '2025-04-05 10:50:00', '2025-04-05 11:15:00', 'Delivered'),
(31, 6, '2025-04-08 15:42:00', '2025-04-08 15:58:00', NULL, 'Assigned'),
(32, 7, '2025-04-11 10:49:00', '2025-04-11 11:06:00', '2025-04-11 11:33:00', 'Delivered'),
(33, 8, '2025-04-14 15:56:00', '2025-04-14 16:14:00', '2025-04-14 16:42:00', 'Delivered'),
(34, 9, '2025-04-17 11:03:00', '2025-04-17 11:22:00', '2025-04-17 11:51:00', 'Delivered'),
(36, 11, '2025-04-23 10:17:00', '2025-04-23 10:38:00', '2025-04-23 11:09:00', 'Delivered'),
(38, 13, '2025-04-29 10:31:00', '2025-04-29 10:54:00', '2025-04-29 11:27:00', 'Delivered'),
(39, 14, '2025-05-02 15:38:00', '2025-05-02 16:02:00', '2025-05-02 16:36:00', 'Delivered'),
(40, 15, '2025-05-05 10:45:00', '2025-05-05 11:00:00', '2025-05-05 11:35:00', 'Delivered'),
(43, 18, '2025-05-14 15:06:00', '2025-05-14 15:24:00', NULL, 'Assigned'),
(44, 19, '2025-05-17 10:13:00', '2025-05-17 10:32:00', '2025-05-17 11:11:00', 'Delivered'),
(45, 20, '2025-05-20 15:20:00', '2025-05-20 15:40:00', NULL, 'Picked Up'),
(46, 21, '2025-05-23 10:27:00', '2025-05-23 10:48:00', '2025-05-23 11:29:00', 'Delivered'),
(47, 22, '2025-05-26 15:34:00', '2025-05-26 15:56:00', NULL, 'Picked Up'),
(48, 23, '2025-05-29 10:41:00', '2025-05-29 11:04:00', '2025-05-29 11:47:00', 'Delivered'),
(49, 24, '2025-06-01 15:48:00', '2025-06-01 16:12:00', '2025-06-01 16:56:00', 'Delivered'),
(50, 25, '2025-06-04 10:55:00', '2025-06-04 11:10:00', '2025-06-04 11:30:00', 'Delivered'),
(51, 1, '2025-06-07 16:02:00', '2025-06-07 16:18:00', '2025-06-07 16:39:00', 'Delivered'),
(52, 2, '2025-06-10 10:09:00', '2025-06-10 10:26:00', NULL, 'Picked Up'),
(53, 3, '2025-06-13 15:16:00', '2025-06-13 15:34:00', '2025-06-13 15:57:00', 'Delivered'),
(55, 5, '2025-06-19 15:30:00', '2025-06-19 15:50:00', '2025-06-19 16:15:00', 'Delivered'),
(56, 6, '2025-06-22 10:37:00', '2025-06-22 10:58:00', '2025-06-22 11:24:00', 'Delivered'),
(57, 7, '2025-06-25 15:44:00', '2025-06-25 16:06:00', '2025-06-25 16:33:00', 'Delivered'),
(58, 8, '2025-06-28 10:51:00', '2025-06-28 11:14:00', '2025-06-28 11:42:00', 'Delivered'),
(59, 9, '2025-07-01 15:58:00', '2025-07-01 16:22:00', NULL, 'Assigned'),
(60, 10, '2025-07-04 10:05:00', '2025-07-04 10:20:00', '2025-07-04 10:50:00', 'Delivered'),
(63, 13, '2025-07-13 15:26:00', '2025-07-13 15:44:00', '2025-07-13 16:17:00', 'Delivered'),
(65, 15, '2025-07-19 15:40:00', '2025-07-19 16:00:00', '2025-07-19 16:35:00', 'Delivered'),
(66, 16, '2025-07-22 10:47:00', '2025-07-22 11:08:00', '2025-07-22 11:44:00', 'Delivered'),
(68, 18, '2025-07-28 11:01:00', '2025-07-28 11:24:00', '2025-07-28 12:02:00', 'Delivered'),
(69, 19, '2025-07-31 15:08:00', '2025-07-31 15:32:00', '2025-07-31 16:11:00', 'Delivered'),
(70, 20, '2025-08-03 10:15:00', '2025-08-03 10:30:00', '2025-08-03 11:10:00', 'Delivered'),
(71, 21, '2025-08-06 15:22:00', '2025-08-06 15:38:00', '2025-08-06 16:19:00', 'Delivered'),
(72, 22, '2025-08-09 10:29:00', '2025-08-09 10:46:00', '2025-08-09 11:28:00', 'Delivered'),
(73, 23, '2025-08-12 15:36:00', '2025-08-12 15:54:00', NULL, 'Picked Up'),
(74, 24, '2025-08-15 10:43:00', '2025-08-15 11:02:00', NULL, 'Picked Up'),
(75, 25, '2025-08-18 15:50:00', '2025-08-18 16:10:00', '2025-08-18 16:30:00', 'Delivered'),
(76, 1, '2025-08-21 10:57:00', '2025-08-21 11:18:00', '2025-08-21 11:39:00', 'Delivered'),
(77, 2, '2025-08-24 16:04:00', '2025-08-24 16:26:00', '2025-08-24 16:48:00', 'Delivered'),
(78, 3, '2025-08-27 10:11:00', '2025-08-27 10:34:00', '2025-08-27 10:57:00', 'Delivered'),
(79, 4, '2025-08-30 15:18:00', '2025-08-30 15:42:00', NULL, 'Assigned'),
(80, 5, '2025-09-02 10:25:00', '2025-09-02 10:40:00', '2025-09-02 11:05:00', 'Delivered'),
(81, 6, '2025-09-05 15:32:00', '2025-09-05 15:48:00', NULL, 'Picked Up'),
(82, 7, '2025-09-08 10:39:00', '2025-09-08 10:56:00', '2025-09-08 11:23:00', 'Delivered'),
(83, 8, '2025-09-11 15:46:00', '2025-09-11 16:04:00', '2025-09-11 16:32:00', 'Delivered'),
(84, 9, '2025-09-14 10:53:00', '2025-09-14 11:12:00', '2025-09-14 11:41:00', 'Delivered'),
(85, 10, '2025-09-17 16:00:00', '2025-09-17 16:20:00', '2025-09-17 16:50:00', 'Delivered'),
(86, 11, '2025-09-20 10:07:00', '2025-09-20 10:28:00', '2025-09-20 10:59:00', 'Delivered'),
(87, 12, '2025-09-23 15:14:00', '2025-09-23 15:36:00', '2025-09-23 16:08:00', 'Delivered'),
(88, 13, '2025-09-26 10:21:00', '2025-09-26 10:44:00', NULL, 'Assigned'),
(89, 14, '2025-09-29 15:28:00', '2025-09-29 15:52:00', NULL, 'Assigned'),
(90, 15, '2025-10-02 10:35:00', '2025-10-02 10:50:00', '2025-10-02 11:25:00', 'Delivered'),
(91, 16, '2025-10-05 15:42:00', '2025-10-05 15:58:00', '2025-10-05 16:34:00', 'Delivered'),
(92, 17, '2025-10-08 10:49:00', '2025-10-08 11:06:00', NULL, 'Picked Up'),
(93, 18, '2025-10-11 15:56:00', '2025-10-11 16:14:00', '2025-10-11 16:52:00', 'Delivered'),
(94, 19, '2025-10-14 11:03:00', '2025-10-14 11:22:00', '2025-10-14 12:01:00', 'Delivered'),
(95, 20, '2025-10-17 15:10:00', '2025-10-17 15:30:00', '2025-10-17 16:10:00', 'Delivered'),
(96, 21, '2025-10-20 10:17:00', '2025-10-20 10:38:00', '2025-10-20 11:19:00', 'Delivered'),
(97, 22, '2025-10-23 15:24:00', '2025-10-23 15:46:00', '2025-10-23 16:28:00', 'Delivered'),
(99, 24, '2025-10-29 15:38:00', '2025-10-29 16:02:00', '2025-10-29 16:46:00', 'Delivered'),
(100, 25, '2025-11-01 10:45:00', '2025-11-01 11:00:00', '2025-11-01 11:20:00', 'Delivered'),
(101, 1, '2025-11-04 15:52:00', '2025-11-04 16:08:00', '2025-11-04 16:29:00', 'Delivered'),
(102, 2, '2025-11-07 10:59:00', '2025-11-07 11:16:00', '2025-11-07 11:38:00', 'Delivered'),
(103, 3, '2025-11-10 15:06:00', '2025-11-10 15:24:00', '2025-11-10 15:47:00', 'Delivered'),
(104, 4, '2025-11-13 10:13:00', '2025-11-13 10:32:00', '2025-11-13 10:56:00', 'Delivered'),
(105, 5, '2025-11-16 15:20:00', '2025-11-16 15:40:00', '2025-11-16 16:05:00', 'Delivered'),
(106, 6, '2025-11-19 10:27:00', '2025-11-19 10:48:00', '2025-11-19 11:14:00', 'Delivered'),
(107, 7, '2025-11-22 15:34:00', '2025-11-22 15:56:00', '2025-11-22 16:23:00', 'Delivered'),
(108, 8, '2025-11-25 10:41:00', '2025-11-25 11:04:00', '2025-11-25 11:32:00', 'Delivered'),
(109, 9, '2025-11-28 15:48:00', '2025-11-28 16:12:00', '2025-11-28 16:41:00', 'Delivered'),
(110, 10, '2025-12-01 10:55:00', '2025-12-01 11:10:00', '2025-12-01 11:40:00', 'Delivered'),
(111, 11, '2025-12-04 16:02:00', '2025-12-04 16:18:00', '2025-12-04 16:49:00', 'Delivered'),
(112, 12, '2025-12-07 10:09:00', '2025-12-07 10:26:00', '2025-12-07 10:58:00', 'Delivered'),
(113, 13, '2025-12-10 15:16:00', '2025-12-10 15:34:00', '2025-12-10 16:07:00', 'Delivered'),
(114, 14, '2025-12-13 10:23:00', '2025-12-13 10:42:00', '2025-12-13 11:16:00', 'Delivered'),
(115, 15, '2025-12-16 15:30:00', '2025-12-16 15:50:00', '2025-12-16 16:25:00', 'Delivered'),
(116, 16, '2025-12-19 10:37:00', '2025-12-19 10:58:00', NULL, 'Assigned'),
(117, 17, '2025-12-22 15:44:00', '2025-12-22 16:06:00', '2025-12-22 16:43:00', 'Delivered'),
(118, 18, '2025-12-25 10:51:00', '2025-12-25 11:14:00', '2025-12-25 11:52:00', 'Delivered'),
(119, 19, '2025-12-28 15:58:00', '2025-12-28 16:22:00', '2025-12-28 17:01:00', 'Delivered'),
(120, 20, '2025-12-31 10:05:00', '2025-12-31 10:20:00', NULL, 'Picked Up'),
(121, 21, '2026-01-03 15:12:00', '2026-01-03 15:28:00', '2026-01-03 16:09:00', 'Delivered'),
(122, 22, '2025-01-06 10:19:00', '2025-01-06 10:36:00', '2025-01-06 11:18:00', 'Delivered'),
(123, 23, '2025-01-09 15:26:00', '2025-01-09 15:44:00', '2025-01-09 16:27:00', 'Delivered'),
(124, 24, '2025-01-12 10:33:00', '2025-01-12 10:52:00', '2025-01-12 11:36:00', 'Delivered'),
(125, 25, '2025-01-15 15:40:00', '2025-01-15 16:00:00', NULL, 'Assigned'),
(126, 1, '2025-01-18 10:47:00', '2025-01-18 11:08:00', '2025-01-18 11:29:00', 'Delivered'),
(127, 2, '2025-01-21 15:54:00', '2025-01-21 16:16:00', '2025-01-21 16:38:00', 'Delivered'),
(128, 3, '2025-01-24 11:01:00', '2025-01-24 11:24:00', '2025-01-24 11:47:00', 'Delivered'),
(129, 4, '2025-01-27 15:08:00', '2025-01-27 15:32:00', '2025-01-27 15:56:00', 'Delivered'),
(130, 5, '2025-01-30 10:15:00', '2025-01-30 10:30:00', '2025-01-30 10:55:00', 'Delivered'),
(131, 6, '2025-02-02 15:22:00', '2025-02-02 15:38:00', '2025-02-02 16:04:00', 'Delivered'),
(132, 7, '2025-02-05 10:29:00', '2025-02-05 10:46:00', '2025-02-05 11:13:00', 'Delivered'),
(133, 8, '2025-02-08 15:36:00', '2025-02-08 15:54:00', NULL, 'Assigned'),
(134, 9, '2025-02-11 10:43:00', '2025-02-11 11:02:00', '2025-02-11 11:31:00', 'Delivered'),
(138, 13, '2025-02-23 10:11:00', '2025-02-23 10:34:00', '2025-02-23 11:07:00', 'Delivered'),
(139, 14, '2025-02-26 15:18:00', '2025-02-26 15:42:00', '2025-02-26 16:16:00', 'Delivered'),
(140, 15, '2025-03-01 10:25:00', '2025-03-01 10:40:00', '2025-03-01 11:15:00', 'Delivered'),
(142, 17, '2025-03-07 10:39:00', '2025-03-07 10:56:00', '2025-03-07 11:33:00', 'Delivered'),
(143, 18, '2025-03-10 15:46:00', '2025-03-10 16:04:00', '2025-03-10 16:42:00', 'Delivered'),
(144, 19, '2025-03-13 10:53:00', '2025-03-13 11:12:00', '2025-03-13 11:51:00', 'Delivered'),
(145, 20, '2025-03-16 16:00:00', '2025-03-16 16:20:00', '2025-03-16 17:00:00', 'Delivered'),
(146, 21, '2025-03-19 10:07:00', '2025-03-19 10:28:00', '2025-03-19 11:09:00', 'Delivered'),
(148, 23, '2025-03-25 10:21:00', '2025-03-25 10:44:00', '2025-03-25 11:27:00', 'Delivered'),
(150, 25, '2025-03-31 10:35:00', '2025-03-31 10:50:00', '2025-03-31 11:10:00', 'Delivered'),
(151, 1, '2025-04-03 15:42:00', '2025-04-03 15:58:00', NULL, 'Assigned'),
(152, 2, '2025-04-06 10:49:00', '2025-04-06 11:06:00', '2025-04-06 11:28:00', 'Delivered'),
(154, 4, '2025-04-12 11:03:00', '2025-04-12 11:22:00', '2025-04-12 11:46:00', 'Delivered'),
(155, 5, '2025-04-15 15:10:00', '2025-04-15 15:30:00', '2025-04-15 15:55:00', 'Delivered'),
(156, 6, '2025-04-18 10:17:00', '2025-04-18 10:38:00', '2025-04-18 11:04:00', 'Delivered'),
(157, 7, '2025-04-21 15:24:00', '2025-04-21 15:46:00', '2025-04-21 16:13:00', 'Delivered'),
(158, 8, '2025-04-24 10:31:00', '2025-04-24 10:54:00', '2025-04-24 11:22:00', 'Delivered'),
(159, 9, '2025-04-27 15:38:00', '2025-04-27 16:02:00', '2025-04-27 16:31:00', 'Delivered'),
(160, 10, '2025-04-30 10:45:00', '2025-04-30 11:00:00', '2025-04-30 11:30:00', 'Delivered'),
(161, 11, '2025-05-03 15:52:00', '2025-05-03 16:08:00', NULL, 'Picked Up'),
(162, 12, '2025-05-06 10:59:00', '2025-05-06 11:16:00', NULL, 'Assigned'),
(163, 13, '2025-05-09 15:06:00', '2025-05-09 15:24:00', '2025-05-09 15:57:00', 'Delivered'),
(164, 14, '2025-05-12 10:13:00', '2025-05-12 10:32:00', NULL, 'Picked Up'),
(165, 15, '2025-05-15 15:20:00', '2025-05-15 15:40:00', '2025-05-15 16:15:00', 'Delivered'),
(166, 16, '2025-05-18 10:27:00', '2025-05-18 10:48:00', '2025-05-18 11:24:00', 'Delivered'),
(167, 17, '2025-05-21 15:34:00', '2025-05-21 15:56:00', '2025-05-21 16:33:00', 'Delivered'),
(168, 18, '2025-05-24 10:41:00', '2025-05-24 11:04:00', '2025-05-24 11:42:00', 'Delivered'),
(170, 20, '2025-05-30 10:55:00', '2025-05-30 11:10:00', '2025-05-30 11:50:00', 'Delivered'),
(171, 21, '2025-06-02 16:02:00', '2025-06-02 16:18:00', '2025-06-02 16:59:00', 'Delivered'),
(172, 22, '2025-06-05 10:09:00', '2025-06-05 10:26:00', '2025-06-05 11:08:00', 'Delivered'),
(173, 23, '2025-06-08 15:16:00', '2025-06-08 15:34:00', NULL, 'Assigned'),
(174, 24, '2025-06-11 10:23:00', '2025-06-11 10:42:00', '2025-06-11 11:26:00', 'Delivered'),
(175, 25, '2025-06-14 15:30:00', '2025-06-14 15:50:00', '2025-06-14 16:10:00', 'Delivered'),
(176, 1, '2025-06-17 10:37:00', '2025-06-17 10:58:00', '2025-06-17 11:19:00', 'Delivered'),
(177, 2, '2025-06-20 15:44:00', '2025-06-20 16:06:00', '2025-06-20 16:28:00', 'Delivered'),
(178, 3, '2025-06-23 10:51:00', '2025-06-23 11:14:00', '2025-06-23 11:37:00', 'Delivered'),
(179, 4, '2025-06-26 15:58:00', '2025-06-26 16:22:00', '2025-06-26 16:46:00', 'Delivered'),
(180, 5, '2025-06-29 10:05:00', '2025-06-29 10:20:00', '2025-06-29 10:45:00', 'Delivered'),
(181, 6, '2025-07-02 15:12:00', '2025-07-02 15:28:00', '2025-07-02 15:54:00', 'Delivered'),
(182, 7, '2025-07-05 10:19:00', '2025-07-05 10:36:00', '2025-07-05 11:03:00', 'Delivered'),
(183, 8, '2025-07-08 15:26:00', '2025-07-08 15:44:00', '2025-07-08 16:12:00', 'Delivered'),
(184, 9, '2025-07-11 10:33:00', '2025-07-11 10:52:00', '2025-07-11 11:21:00', 'Delivered'),
(185, 10, '2025-07-14 15:40:00', '2025-07-14 16:00:00', '2025-07-14 16:30:00', 'Delivered'),
(186, 11, '2025-07-17 10:47:00', '2025-07-17 11:08:00', '2025-07-17 11:39:00', 'Delivered'),
(188, 13, '2025-07-23 11:01:00', '2025-07-23 11:24:00', '2025-07-23 11:57:00', 'Delivered'),
(189, 14, '2025-07-26 15:08:00', '2025-07-26 15:32:00', '2025-07-26 16:06:00', 'Delivered'),
(190, 15, '2025-07-29 10:15:00', '2025-07-29 10:30:00', '2025-07-29 11:05:00', 'Delivered'),
(191, 16, '2025-08-01 15:22:00', '2025-08-01 15:38:00', '2025-08-01 16:14:00', 'Delivered'),
(192, 17, '2025-08-04 10:29:00', '2025-08-04 10:46:00', '2025-08-04 11:23:00', 'Delivered'),
(193, 18, '2025-08-07 15:36:00', '2025-08-07 15:54:00', NULL, 'Assigned'),
(194, 19, '2025-08-10 10:43:00', '2025-08-10 11:02:00', '2025-08-10 11:41:00', 'Delivered'),
(195, 20, '2025-08-13 15:50:00', '2025-08-13 16:10:00', '2025-08-13 16:50:00', 'Delivered'),
(196, 21, '2025-08-16 10:57:00', '2025-08-16 11:18:00', '2025-08-16 11:59:00', 'Delivered'),
(197, 22, '2025-08-19 16:04:00', '2025-08-19 16:26:00', '2025-08-19 17:08:00', 'Delivered'),
(198, 23, '2025-08-22 10:11:00', '2025-08-22 10:34:00', NULL, 'Picked Up'),
(199, 24, '2025-08-25 15:18:00', '2025-08-25 15:42:00', '2025-08-25 16:26:00', 'Delivered'),
(200, 25, '2025-08-28 10:25:00', '2025-08-28 10:40:00', '2025-08-28 11:00:00', 'Delivered'),
(201, 1, '2025-08-31 15:32:00', '2025-08-31 15:48:00', NULL, 'Assigned'),
(202, 2, '2025-09-03 10:39:00', '2025-09-03 10:56:00', NULL, 'Assigned'),
(203, 3, '2025-09-06 15:46:00', '2025-09-06 16:04:00', '2025-09-06 16:27:00', 'Delivered'),
(204, 4, '2025-09-09 10:53:00', '2025-09-09 11:12:00', '2025-09-09 11:36:00', 'Delivered'),
(205, 5, '2025-09-12 16:00:00', '2025-09-12 16:20:00', '2025-09-12 16:45:00', 'Delivered'),
(207, 7, '2025-09-18 15:14:00', '2025-09-18 15:36:00', '2025-09-18 16:03:00', 'Delivered'),
(208, 8, '2025-09-21 10:21:00', '2025-09-21 10:44:00', '2025-09-21 11:12:00', 'Delivered'),
(209, 9, '2025-09-24 15:28:00', '2025-09-24 15:52:00', '2025-09-24 16:21:00', 'Delivered'),
(210, 10, '2025-09-27 10:35:00', '2025-09-27 10:50:00', '2025-09-27 11:20:00', 'Delivered'),
(211, 11, '2025-09-30 15:42:00', '2025-09-30 15:58:00', '2025-09-30 16:29:00', 'Delivered'),
(212, 12, '2025-10-03 10:49:00', '2025-10-03 11:06:00', '2025-10-03 11:38:00', 'Delivered'),
(213, 13, '2025-10-06 15:56:00', '2025-10-06 16:14:00', NULL, 'Picked Up'),
(214, 14, '2025-10-09 11:03:00', '2025-10-09 11:22:00', NULL, 'Picked Up'),
(215, 15, '2025-10-12 15:10:00', '2025-10-12 15:30:00', '2025-10-12 16:05:00', 'Delivered'),
(216, 16, '2025-10-15 10:17:00', '2025-10-15 10:38:00', '2025-10-15 11:14:00', 'Delivered'),
(218, 18, '2025-10-21 10:31:00', '2025-10-21 10:54:00', '2025-10-21 11:32:00', 'Delivered'),
(220, 20, '2025-10-27 10:45:00', '2025-10-27 11:00:00', '2025-10-27 11:40:00', 'Delivered'),
(221, 21, '2025-10-30 15:52:00', '2025-10-30 16:08:00', '2025-10-30 16:49:00', 'Delivered'),
(222, 22, '2025-11-02 10:59:00', '2025-11-02 11:16:00', '2025-11-02 11:58:00', 'Delivered'),
(223, 23, '2025-11-05 15:06:00', '2025-11-05 15:24:00', '2025-11-05 16:07:00', 'Delivered'),
(225, 25, '2025-11-11 15:20:00', '2025-11-11 15:40:00', '2025-11-11 16:00:00', 'Delivered'),
(226, 1, '2025-11-14 10:27:00', '2025-11-14 10:48:00', '2025-11-14 11:09:00', 'Delivered'),
(227, 2, '2025-11-17 15:34:00', '2025-11-17 15:56:00', '2025-11-17 16:18:00', 'Delivered'),
(228, 3, '2025-11-20 10:41:00', '2025-11-20 11:04:00', NULL, 'Picked Up'),
(229, 4, '2025-11-23 15:48:00', '2025-11-23 16:12:00', '2025-11-23 16:36:00', 'Delivered'),
(230, 5, '2025-11-26 10:55:00', '2025-11-26 11:10:00', '2025-11-26 11:35:00', 'Delivered'),
(231, 6, '2025-11-29 16:02:00', '2025-11-29 16:18:00', '2025-11-29 16:44:00', 'Delivered'),
(232, 7, '2025-12-02 10:09:00', '2025-12-02 10:26:00', '2025-12-02 10:53:00', 'Delivered'),
(233, 8, '2025-12-05 15:16:00', '2025-12-05 15:34:00', '2025-12-05 16:02:00', 'Delivered'),
(234, 9, '2025-12-08 10:23:00', '2025-12-08 10:42:00', '2025-12-08 11:11:00', 'Delivered'),
(235, 10, '2025-12-11 15:30:00', '2025-12-11 15:50:00', '2025-12-11 16:20:00', 'Delivered'),
(236, 11, '2025-12-14 10:37:00', '2025-12-14 10:58:00', '2025-12-14 11:29:00', 'Delivered'),
(237, 12, '2025-12-17 15:44:00', '2025-12-17 16:06:00', '2025-12-17 16:38:00', 'Delivered'),
(238, 13, '2025-12-20 10:51:00', '2025-12-20 11:14:00', '2025-12-20 11:47:00', 'Delivered'),
(239, 14, '2025-12-23 15:58:00', '2025-12-23 16:22:00', '2025-12-23 16:56:00', 'Delivered'),
(240, 15, '2025-12-26 10:05:00', '2025-12-26 10:20:00', NULL, 'Assigned'),
(241, 16, '2025-12-29 15:12:00', '2025-12-29 15:28:00', '2025-12-29 16:04:00', 'Delivered'),
(242, 17, '2026-01-01 10:19:00', '2026-01-01 10:36:00', '2026-01-01 11:13:00', 'Delivered'),
(243, 18, '2026-01-04 15:26:00', '2026-01-04 15:44:00', '2026-01-04 16:22:00', 'Delivered'),
(244, 19, '2025-01-07 10:33:00', '2025-01-07 10:52:00', '2025-01-07 11:31:00', 'Delivered'),
(245, 20, '2025-01-10 15:40:00', '2025-01-10 16:00:00', '2025-01-10 16:40:00', 'Delivered'),
(246, 21, '2025-01-13 10:47:00', '2025-01-13 11:08:00', '2025-01-13 11:49:00', 'Delivered'),
(247, 22, '2025-01-16 15:54:00', '2025-01-16 16:16:00', '2025-01-16 16:58:00', 'Delivered'),
(248, 23, '2025-01-19 11:01:00', '2025-01-19 11:24:00', '2025-01-19 12:07:00', 'Delivered'),
(249, 24, '2025-01-22 15:08:00', '2025-01-22 15:32:00', '2025-01-22 16:16:00', 'Delivered'),
(250, 25, '2025-01-25 10:15:00', '2025-01-25 10:30:00', '2025-01-25 10:50:00', 'Delivered'),
(251, 1, '2025-01-28 15:22:00', '2025-01-28 15:38:00', '2025-01-28 15:59:00', 'Delivered'),
(252, 2, '2025-01-31 10:29:00', '2025-01-31 10:46:00', '2025-01-31 11:08:00', 'Delivered'),
(253, 3, '2025-02-03 15:36:00', '2025-02-03 15:54:00', '2025-02-03 16:17:00', 'Delivered'),
(254, 4, '2025-02-06 10:43:00', '2025-02-06 11:02:00', NULL, 'Picked Up'),
(255, 5, '2025-02-09 15:50:00', '2025-02-09 16:10:00', '2025-02-09 16:35:00', 'Delivered'),
(256, 6, '2025-02-12 10:57:00', '2025-02-12 11:18:00', '2025-02-12 11:44:00', 'Delivered'),
(257, 7, '2025-02-15 16:04:00', '2025-02-15 16:26:00', '2025-02-15 16:53:00', 'Delivered'),
(258, 8, '2025-02-18 10:11:00', '2025-02-18 10:34:00', '2025-02-18 11:02:00', 'Delivered'),
(259, 9, '2025-02-21 15:18:00', '2025-02-21 15:42:00', '2025-02-21 16:11:00', 'Delivered'),
(260, 10, '2025-02-24 10:25:00', '2025-02-24 10:40:00', '2025-02-24 11:10:00', 'Delivered'),
(262, 12, '2025-03-02 10:39:00', '2025-03-02 10:56:00', '2025-03-02 11:28:00', 'Delivered'),
(263, 13, '2025-03-05 15:46:00', '2025-03-05 16:04:00', '2025-03-05 16:37:00', 'Delivered'),
(264, 14, '2025-03-08 10:53:00', '2025-03-08 11:12:00', '2025-03-08 11:46:00', 'Delivered'),
(265, 15, '2025-03-11 16:00:00', '2025-03-11 16:20:00', '2025-03-11 16:55:00', 'Delivered'),
(266, 16, '2025-03-14 10:07:00', '2025-03-14 10:28:00', '2025-03-14 11:04:00', 'Delivered'),
(267, 17, '2025-03-17 15:14:00', '2025-03-17 15:36:00', '2025-03-17 16:13:00', 'Delivered'),
(268, 18, '2025-03-20 10:21:00', '2025-03-20 10:44:00', NULL, 'Assigned'),
(269, 19, '2025-03-23 15:28:00', '2025-03-23 15:52:00', NULL, 'Assigned'),
(270, 20, '2025-03-26 10:35:00', '2025-03-26 10:50:00', '2025-03-26 11:30:00', 'Delivered'),
(271, 21, '2025-03-29 15:42:00', '2025-03-29 15:58:00', '2025-03-29 16:39:00', 'Delivered'),
(272, 22, '2025-04-01 10:49:00', '2025-04-01 11:06:00', '2025-04-01 11:48:00', 'Delivered'),
(273, 23, '2025-04-04 15:56:00', '2025-04-04 16:14:00', NULL, 'Assigned'),
(274, 24, '2025-04-07 11:03:00', '2025-04-07 11:22:00', '2025-04-07 12:06:00', 'Delivered'),
(275, 25, '2025-04-10 15:10:00', '2025-04-10 15:30:00', NULL, 'Assigned'),
(276, 1, '2025-04-13 10:17:00', '2025-04-13 10:38:00', '2025-04-13 10:59:00', 'Delivered'),
(277, 2, '2025-04-16 15:24:00', '2025-04-16 15:46:00', '2025-04-16 16:08:00', 'Delivered'),
(278, 3, '2025-04-19 10:31:00', '2025-04-19 10:54:00', '2025-04-19 11:17:00', 'Delivered'),
(279, 4, '2025-04-22 15:38:00', '2025-04-22 16:02:00', '2025-04-22 16:26:00', 'Delivered');

-- 11. ORDER COUPONS: 60 RECORDS
INSERT INTO order_coupons (order_id, coupon_id, discount_amount) VALUES
(5, 1, 27.40),
(10, 2, 12.00),
(15, 3, 29.00),
(20, 4, 26.40),
(25, 5, 13.50),
(30, 6, 13.00),
(35, 7, 32.90),
(40, 8, 20.00),
(45, 9, 16.00),
(50, 10, 34.85),
(55, 11, 24.50),
(60, 12, 24.50),
(65, 13, 18.45),
(70, 14, 35.00),
(75, 15, 24.50),
(80, 16, 15.45),
(85, 17, 15.00),
(90, 18, 14.00),
(95, 19, 24.90),
(100, 20, 30.50),
(105, 1, 15.50),
(110, 2, 18.95),
(115, 3, 25.50),
(120, 4, 12.50),
(125, 5, 44.80),
(130, 6, 16.50),
(135, 7, 13.00),
(140, 8, 33.85),
(145, 9, 20.00),
(150, 10, 12.50),
(155, 11, 14.95),
(160, 12, 17.00),
(165, 13, 22.50),
(170, 14, 25.40),
(175, 15, 17.00),
(180, 16, 12.50),
(185, 17, 39.85),
(190, 18, 39.50),
(195, 19, 22.50),
(200, 20, 16.95),
(205, 1, 11.00),
(210, 2, 17.00),
(215, 3, 3.50),
(220, 4, 9.00),
(225, 5, 17.00),
(230, 6, 3.50),
(235, 7, 12.00),
(240, 8, 8.50),
(245, 9, 21.90),
(250, 10, 22.00),
(255, 11, 8.50),
(260, 12, 11.95),
(265, 13, 12.50),
(270, 14, 8.50),
(275, 15, 3.50),
(280, 16, 3.00),
(285, 17, 7.00),
(290, 18, 3.50),
(295, 19, 29.00),
(300, 20, 5.50);

-- 12. REVIEWS: 150 RECORDS
INSERT INTO reviews (order_id, customer_id, restaurant_id, rating, review_text, review_date) VALUES
(1, 1, 7, 5, 'Excellent food and quick delivery.', '2025-01-08 18:07:00'),
(3, 3, 6, 4, 'Food was fresh and tasty.', '2025-01-14 18:21:00'),
(4, 4, 13, 5, 'Good packaging and great taste.', '2025-01-17 13:28:00'),
(5, 5, 5, 4, 'Delivery was on time.', '2025-01-20 18:35:00'),
(7, 7, 4, 3, 'Really enjoyed the meal.', '2025-01-26 18:49:00'),
(8, 8, 11, 5, 'Will order again.', '2025-01-29 13:56:00'),
(9, 9, 3, 4, 'Quality was good for the price.', '2025-02-01 18:03:00'),
(10, 10, 10, 5, 'The food was delicious.', '2025-02-04 13:10:00'),
(11, 11, 2, 4, 'Very satisfying experience.', '2025-02-07 18:17:00'),
(13, 13, 1, 3, 'Restaurant service was impressive.', '2025-02-13 18:31:00'),
(14, 14, 8, 5, 'Excellent food and quick delivery.', '2025-02-16 13:38:00'),
(15, 15, 15, 4, 'Food was fresh and tasty.', '2025-02-19 18:45:00'),
(18, 18, 6, 5, 'Good packaging and great taste.', '2025-02-28 13:06:00'),
(19, 19, 13, 4, 'Delivery was on time.', '2025-03-03 18:13:00'),
(20, 20, 5, 3, 'Really enjoyed the meal.', '2025-03-06 13:20:00'),
(22, 22, 4, 5, 'Will order again.', '2025-03-12 13:34:00'),
(23, 23, 11, 4, 'Quality was good for the price.', '2025-03-15 18:41:00'),
(25, 25, 10, 5, 'The food was delicious.', '2025-03-21 18:55:00'),
(26, 26, 2, 4, 'Very satisfying experience.', '2025-03-24 13:02:00'),
(28, 28, 1, 3, 'Restaurant service was impressive.', '2025-03-30 13:16:00'),
(29, 29, 8, 5, 'Excellent food and quick delivery.', '2025-04-02 18:23:00'),
(30, 30, 15, 4, 'Food was fresh and tasty.', '2025-04-05 13:30:00'),
(32, 32, 14, 5, 'Good packaging and great taste.', '2025-04-11 13:44:00'),
(33, 33, 6, 4, 'Delivery was on time.', '2025-04-14 18:51:00'),
(34, 34, 13, 3, 'Really enjoyed the meal.', '2025-04-17 13:58:00'),
(36, 36, 12, 5, 'Will order again.', '2025-04-23 13:12:00'),
(38, 38, 11, 4, 'Quality was good for the price.', '2025-04-29 13:26:00'),
(39, 39, 3, 5, 'The food was delicious.', '2025-05-02 18:33:00'),
(40, 40, 10, 4, 'Very satisfying experience.', '2025-05-05 13:40:00'),
(44, 44, 8, 3, 'Restaurant service was impressive.', '2025-05-17 13:08:00'),
(46, 46, 7, 5, 'Excellent food and quick delivery.', '2025-05-23 13:22:00'),
(48, 48, 6, 4, 'Food was fresh and tasty.', '2025-05-29 13:36:00'),
(49, 49, 13, 5, 'Good packaging and great taste.', '2025-06-01 18:43:00'),
(50, 50, 5, 4, 'Delivery was on time.', '2025-06-04 13:50:00'),
(51, 1, 12, 3, 'Really enjoyed the meal.', '2025-06-07 18:57:00'),
(53, 3, 11, 5, 'Will order again.', '2025-06-13 18:11:00'),
(55, 5, 10, 4, 'Quality was good for the price.', '2025-06-19 18:25:00'),
(56, 6, 2, 5, 'The food was delicious.', '2025-06-22 13:32:00'),
(57, 7, 9, 4, 'Very satisfying experience.', '2025-06-25 18:39:00'),
(58, 8, 1, 3, 'Restaurant service was impressive.', '2025-06-28 13:46:00'),
(60, 10, 15, 5, 'Excellent food and quick delivery.', '2025-07-04 13:00:00'),
(63, 13, 6, 4, 'Food was fresh and tasty.', '2025-07-13 18:21:00'),
(65, 15, 5, 5, 'Good packaging and great taste.', '2025-07-19 18:35:00'),
(66, 16, 12, 4, 'Delivery was on time.', '2025-07-22 13:42:00'),
(68, 18, 11, 3, 'Really enjoyed the meal.', '2025-07-28 13:56:00'),
(69, 19, 3, 5, 'Will order again.', '2025-07-31 18:03:00'),
(70, 20, 10, 4, 'Quality was good for the price.', '2025-08-03 13:10:00'),
(71, 21, 2, 5, 'The food was delicious.', '2025-08-06 18:17:00'),
(72, 22, 9, 4, 'Very satisfying experience.', '2025-08-09 13:24:00'),
(75, 25, 15, 3, 'Restaurant service was impressive.', '2025-08-18 18:45:00'),
(76, 26, 7, 5, 'Excellent food and quick delivery.', '2025-08-21 13:52:00'),
(77, 27, 14, 4, 'Food was fresh and tasty.', '2025-08-24 18:59:00'),
(78, 28, 6, 5, 'Good packaging and great taste.', '2025-08-27 13:06:00'),
(80, 30, 5, 4, 'Delivery was on time.', '2025-09-02 13:20:00'),
(82, 32, 4, 3, 'Really enjoyed the meal.', '2025-09-08 13:34:00'),
(83, 33, 11, 5, 'Will order again.', '2025-09-11 18:41:00'),
(84, 34, 3, 4, 'Quality was good for the price.', '2025-09-14 13:48:00'),
(85, 35, 10, 5, 'The food was delicious.', '2025-09-17 18:55:00'),
(86, 36, 2, 4, 'Very satisfying experience.', '2025-09-20 13:02:00'),
(87, 37, 9, 3, 'Restaurant service was impressive.', '2025-09-23 18:09:00'),
(90, 40, 15, 5, 'Excellent food and quick delivery.', '2025-10-02 13:30:00'),
(91, 41, 7, 4, 'Food was fresh and tasty.', '2025-10-05 18:37:00'),
(93, 43, 6, 5, 'Good packaging and great taste.', '2025-10-11 18:51:00'),
(94, 44, 13, 4, 'Delivery was on time.', '2025-10-14 13:58:00'),
(95, 45, 5, 3, 'Really enjoyed the meal.', '2025-10-17 18:05:00'),
(96, 46, 12, 5, 'Will order again.', '2025-10-20 13:12:00'),
(97, 47, 4, 4, 'Quality was good for the price.', '2025-10-23 18:19:00'),
(99, 49, 3, 5, 'The food was delicious.', '2025-10-29 18:33:00'),
(100, 50, 10, 4, 'Very satisfying experience.', '2025-11-01 13:40:00'),
(101, 1, 2, 3, 'Restaurant service was impressive.', '2025-11-04 18:47:00'),
(102, 2, 9, 5, 'Excellent food and quick delivery.', '2025-11-07 13:54:00'),
(103, 3, 1, 4, 'Food was fresh and tasty.', '2025-11-10 18:01:00'),
(104, 4, 8, 5, 'Good packaging and great taste.', '2025-11-13 13:08:00'),
(105, 5, 15, 4, 'Delivery was on time.', '2025-11-16 18:15:00'),
(106, 6, 7, 3, 'Really enjoyed the meal.', '2025-11-19 13:22:00'),
(107, 7, 14, 5, 'Will order again.', '2025-11-22 18:29:00'),
(108, 8, 6, 4, 'Quality was good for the price.', '2025-11-25 13:36:00'),
(109, 9, 13, 5, 'The food was delicious.', '2025-11-28 18:43:00'),
(110, 10, 5, 4, 'Very satisfying experience.', '2025-12-01 13:50:00'),
(111, 11, 12, 3, 'Restaurant service was impressive.', '2025-12-04 18:57:00'),
(112, 12, 4, 5, 'Excellent food and quick delivery.', '2025-12-07 13:04:00'),
(113, 13, 11, 4, 'Food was fresh and tasty.', '2025-12-10 18:11:00'),
(114, 14, 3, 5, 'Good packaging and great taste.', '2025-12-13 13:18:00'),
(115, 15, 10, 4, 'Delivery was on time.', '2025-12-16 18:25:00'),
(117, 17, 9, 3, 'Really enjoyed the meal.', '2025-12-22 18:39:00'),
(118, 18, 1, 5, 'Will order again.', '2025-12-25 13:46:00'),
(119, 19, 8, 4, 'Quality was good for the price.', '2025-12-28 18:53:00'),
(121, 21, 7, 5, 'The food was delicious.', '2026-01-03 18:07:00'),
(122, 22, 14, 4, 'Very satisfying experience.', '2025-01-06 13:14:00'),
(123, 23, 6, 3, 'Restaurant service was impressive.', '2025-01-09 18:21:00'),
(124, 24, 13, 5, 'Excellent food and quick delivery.', '2025-01-12 13:28:00'),
(126, 26, 12, 4, 'Food was fresh and tasty.', '2025-01-18 13:42:00'),
(127, 27, 4, 5, 'Good packaging and great taste.', '2025-01-21 18:49:00'),
(128, 28, 11, 4, 'Delivery was on time.', '2025-01-24 13:56:00'),
(129, 29, 3, 3, 'Really enjoyed the meal.', '2025-01-27 18:03:00'),
(130, 30, 10, 5, 'Will order again.', '2025-01-30 13:10:00'),
(131, 31, 2, 4, 'Quality was good for the price.', '2025-02-02 18:17:00'),
(132, 32, 9, 5, 'The food was delicious.', '2025-02-05 13:24:00'),
(134, 34, 8, 4, 'Very satisfying experience.', '2025-02-11 13:38:00'),
(138, 38, 6, 3, 'Restaurant service was impressive.', '2025-02-23 13:06:00'),
(139, 39, 13, 5, 'Excellent food and quick delivery.', '2025-02-26 18:13:00'),
(140, 40, 5, 4, 'Food was fresh and tasty.', '2025-03-01 13:20:00'),
(142, 42, 4, 5, 'Good packaging and great taste.', '2025-03-07 13:34:00'),
(143, 43, 11, 4, 'Delivery was on time.', '2025-03-10 18:41:00'),
(144, 44, 3, 3, 'Really enjoyed the meal.', '2025-03-13 13:48:00'),
(145, 45, 10, 5, 'Will order again.', '2025-03-16 18:55:00'),
(146, 46, 2, 4, 'Quality was good for the price.', '2025-03-19 13:02:00'),
(148, 48, 1, 5, 'The food was delicious.', '2025-03-25 13:16:00'),
(150, 50, 15, 4, 'Very satisfying experience.', '2025-03-31 13:30:00'),
(152, 2, 14, 3, 'Restaurant service was impressive.', '2025-04-06 13:44:00'),
(154, 4, 13, 5, 'Excellent food and quick delivery.', '2025-04-12 13:58:00'),
(155, 5, 5, 4, 'Food was fresh and tasty.', '2025-04-15 18:05:00'),
(156, 6, 12, 5, 'Good packaging and great taste.', '2025-04-18 13:12:00'),
(157, 7, 4, 4, 'Delivery was on time.', '2025-04-21 18:19:00'),
(158, 8, 11, 3, 'Really enjoyed the meal.', '2025-04-24 13:26:00'),
(159, 9, 3, 5, 'Will order again.', '2025-04-27 18:33:00'),
(160, 10, 10, 4, 'Quality was good for the price.', '2025-04-30 13:40:00'),
(163, 13, 1, 5, 'The food was delicious.', '2025-05-09 18:01:00'),
(165, 15, 15, 4, 'Very satisfying experience.', '2025-05-15 18:15:00'),
(166, 16, 7, 3, 'Restaurant service was impressive.', '2025-05-18 13:22:00'),
(167, 17, 14, 5, 'Excellent food and quick delivery.', '2025-05-21 18:29:00'),
(168, 18, 6, 4, 'Food was fresh and tasty.', '2025-05-24 13:36:00'),
(170, 20, 5, 5, 'Good packaging and great taste.', '2025-05-30 13:50:00'),
(171, 21, 12, 4, 'Delivery was on time.', '2025-06-02 18:57:00'),
(172, 22, 4, 3, 'Really enjoyed the meal.', '2025-06-05 13:04:00'),
(174, 24, 3, 5, 'Will order again.', '2025-06-11 13:18:00'),
(175, 25, 10, 4, 'Quality was good for the price.', '2025-06-14 18:25:00'),
(176, 26, 2, 5, 'The food was delicious.', '2025-06-17 13:32:00'),
(177, 27, 9, 4, 'Very satisfying experience.', '2025-06-20 18:39:00'),
(178, 28, 1, 3, 'Restaurant service was impressive.', '2025-06-23 13:46:00'),
(179, 29, 8, 5, 'Excellent food and quick delivery.', '2025-06-26 18:53:00'),
(180, 30, 15, 4, 'Food was fresh and tasty.', '2025-06-29 13:00:00'),
(181, 31, 7, 5, 'Good packaging and great taste.', '2025-07-02 18:07:00'),
(182, 32, 14, 4, 'Delivery was on time.', '2025-07-05 13:14:00'),
(183, 33, 6, 3, 'Really enjoyed the meal.', '2025-07-08 18:21:00'),
(184, 34, 13, 5, 'Will order again.', '2025-07-11 13:28:00'),
(185, 35, 5, 4, 'Quality was good for the price.', '2025-07-14 18:35:00'),
(186, 36, 12, 5, 'The food was delicious.', '2025-07-17 13:42:00'),
(188, 38, 11, 4, 'Very satisfying experience.', '2025-07-23 13:56:00'),
(189, 39, 3, 3, 'Restaurant service was impressive.', '2025-07-26 18:03:00'),
(190, 40, 10, 5, 'Excellent food and quick delivery.', '2025-07-29 13:10:00'),
(191, 41, 2, 4, 'Food was fresh and tasty.', '2025-08-01 18:17:00'),
(192, 42, 9, 5, 'Good packaging and great taste.', '2025-08-04 13:24:00'),
(194, 44, 8, 4, 'Delivery was on time.', '2025-08-10 13:38:00'),
(195, 45, 15, 3, 'Really enjoyed the meal.', '2025-08-13 18:45:00'),
(196, 46, 7, 5, 'Will order again.', '2025-08-16 13:52:00'),
(197, 47, 14, 4, 'Quality was good for the price.', '2025-08-19 18:59:00'),
(199, 49, 13, 5, 'The food was delicious.', '2025-08-25 18:13:00'),
(200, 50, 5, 4, 'Very satisfying experience.', '2025-08-28 13:20:00'),
(203, 3, 11, 3, 'Restaurant service was impressive.', '2025-09-06 18:41:00');

-- VERIFICATION QUERIES
SELECT 'Customers' AS table_name, COUNT(*) AS total_records FROM customers
UNION ALL SELECT 'Restaurants', COUNT(*) FROM restaurants
UNION ALL SELECT 'Categories', COUNT(*) FROM food_categories
UNION ALL SELECT 'Menu Items', COUNT(*) FROM menu_items
UNION ALL SELECT 'Delivery Partners', COUNT(*) FROM delivery_partners
UNION ALL SELECT 'Orders', COUNT(*) FROM orders
UNION ALL SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL SELECT 'Payments', COUNT(*) FROM payments
UNION ALL SELECT 'Deliveries', COUNT(*) FROM deliveries
UNION ALL SELECT 'Coupons', COUNT(*) FROM coupons
UNION ALL SELECT 'Reviews', COUNT(*) FROM reviews;

select * FROM orders;
-- ============================================
-- PART 3:BASIC OPERATION
-- ============================================
-- SELECT – Retrieve All Customers
SELECT *
FROM customers;


-- WHERE – Customers from Mumbai
SELECT *
FROM customers
WHERE city = 'Mumbai';


-- DISTINCT – Unique Cities
SELECT DISTINCT city
FROM customers;



-- Highest-rated restaurants first:
SELECT restaurant_name, rating
FROM restaurants
ORDER BY rating DESC;

-- LIMIT – Top 5 Restaurants
SELECT restaurant_name, rating
FROM restaurants
ORDER BY rating DESC
LIMIT 5;

-- ALISES
SELECT
    c.first_name,
    c.last_name,
    c.email
FROM customers AS c;



-- ============================================
-- PART4:ALIASES
-- ============================================
-- > graeter
select * from restaurants where rating >4.5;

-- 1.< less than
SELECT item_name, price
FROM menu_items
WHERE price < 200;

-- 2: Orders between ₹500 and ₹1,500
SELECT order_id, total_amount
FROM orders
WHERE total_amount BETWEEN 500 AND 1500;


-- Q3 : Customers from selected cities
SELECT *
FROM customers
WHERE city IN ('Mumbai', 'Pune', 'Thane');

-- Q4:Food items containing "Pizza"
SELECT *
FROM menu_items
WHERE item_name LIKE '%Pizza%';

-- 5: Find orders that have not been delivered
SELECT *
FROM orders
WHERE order_status <> 'Delivered';

-- ============================================
-- PART 5: AGG FUNCTION
-- ============================================
-- 1:How many customers are registered?
select count(*) from customers;
select * from orders;



-- 2:What is the total revenue?
SELECT SUM(total_amount)
FROM orders;


-- 3:What is the average order value?
select avg(total_amount) from orders;


-- 4What is the highest order amount?

SELECT MAX(total_amount) AS highest_order_amount
FROM orders;


-- What is the lowest menu item price?

SELECT MIN(price) AS lowest_menu_item_price
FROM menu_items;


-- How many orders have been delivered?-- 

SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'Delivered';

-- How many restaurants are available in each cit
select city,count(*) from restaurants where status="active0"
group by city;


-- ============================================
-- PART 6:GROUP BY 
-- ============================================

-- find total orders per restaurant
select restaurant_id,count(*) from orders group by restaurant_id;

-- fFind revenue generated by each restaurant
SELECT 
    restaurant_id,
    SUM(total_amount) AS restaurant_revenue
FROM orders
GROUP BY restaurant_id;

-- Find number of customers in each city
select city,count(*) from customers group by city;


-- Find average order value for each
SELECT 
    restaurant_id,
    AVG(total_amount) AS average_order_value
FROM orders
GROUP BY restaurant_id;

-- find number of orders handled by each delivery partner
SELECT 
    delivery_partner_id,
    COUNT(*) AS total_orders
FROM orders
WHERE delivery_partner_id IS NOT NULL
GROUP BY delivery_partner_id
;

-- ============================================
-- PART 7:HAVING
-- ============================================

-- Finding  restaurant having more than 20 orders
select restaurant_id,count(*) from orders group by 
restaurant_id having count(*) >=20;

-- Find restaurants generating revenue greater than ₹100000
SELECT 
    restaurant_id,
    SUM(total_amount) AS restaurant_revenue
FROM orders
GROUP BY restaurant_id having sum(total_amount) >=10000;

-- Find delivery partners who completed more than 30 deliveries

SELECT 
    dp.first_name,
    dp.last_name,
    COUNT(d.delivery_id) AS completed_deliveries
FROM delivery_partners dp
JOIN deliveries d
    ON dp.delivery_partner_id = d.delivery_partner_id
WHERE d.delivery_status = 'Delivered'
GROUP BY 
    dp.delivery_partner_id,
    dp.first_name,
    dp.last_name
HAVING COUNT(d.delivery_id) > 10;



-- Find food categories generating revenue above a specified amount

SELECT 
    fc.category_name,
    SUM(oi.subtotal) AS total_revenue
FROM food_categories fc
JOIN menu_items mi
    ON fc.category_id = mi.category_id
JOIN order_items oi
    ON mi.item_id = oi.item_id
GROUP BY 
    fc.category_id,
    fc.category_name
HAVING SUM(oi.subtotal) > 10000;


-- ============================================
-- PART 8:JOINS
-- ============================================

-- Find:
-- A:Customer Name
-- B:Order ID
-- C:Restaurant Name
-- D:Order Amount


SELECT 
c.first_name,c.last_name,
    o.order_id,
    r.restaurant_name,
    o.total_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id;
    
    
    --  left jon
   
-- find all customers, including customers who have never placed an order.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
    
    
-- right join
-- Find all restaurants and their corresponding orders.
SELECT 
    r.restaurant_name,
    o.order_id,
    o.total_amount
FROM orders o
RIGHT JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id;



-- cross join
-- Generate possible combinations of:

-- Restaurants
-- Food Categories
SELECT 
    r.restaurant_name,
    fc.category_name
FROM restaurants r
CROSS JOIN food_categories fc;


-- ============================================
-- PART 9:CASE
-- ============================================
-- case using staus
SELECT 
    order_id,
    order_status,
    CASE
        WHEN order_status = 'Placed' THEN 'Order Received'
        WHEN order_status = 'Confirmed' THEN 'Order Confirmed'
        WHEN order_status = 'Preparing' THEN 'Food is Being Prepared'
        WHEN order_status = 'Out for Delivery' THEN 'On the Way'
        WHEN order_status = 'Delivered' THEN 'Order Completed'
        WHEN order_status = 'Cancelled' THEN 'Order Cancelled'
        ELSE 'Unknown Status'
    END AS status_description
FROM orders;

-- Categorize Orders by Amount

select order_id ,
case
when total_amount < 300 then 'low '
when total_amount between 300 and 700 then 'medium'
else 'high' 
end  as orders from orders;


-- Categorize Restaurants by Rating
SELECT 
    restaurant_name,
    rating,
    CASE
        WHEN rating >= 4.5 THEN 'Excellent'
        WHEN rating >= 4.0 THEN 'Good'
        WHEN rating >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS performance
FROM restaurants;


-- Categorize Customers by Status
SELECT 
    first_name,
    last_name,
    status,
    CASE
        WHEN status = 'Active' THEN 'Currently Using FoodRush'
        WHEN status = 'Inactive' THEN 'Not Currently Active'
        WHEN status = 'Blocked' THEN 'Account Restricted'
        ELSE 'Unknown'
    END AS customer_status_description
FROM customers;




-- count Orders by Category using CASe

SELECT 
    SUM(
        CASE 
            WHEN total_amount < 300 THEN 1
            ELSE 0
        END
    ) AS low_value_orders,

    SUM(
        CASE 
            WHEN total_amount BETWEEN 300 AND 700 THEN 1
            ELSE 0
        END
    ) AS medium_value_orders,

    SUM(
        CASE 
            WHEN total_amount > 700 THEN 1
            ELSE 0
        END
    ) AS high_value_orders

FROM orders;



-- PART10:


-- Q1. Find monthly revenue.
SELECT 
    MONTHNAME(order_date) AS month_name,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);


-- Q2. Find yearly revenue.
SELECT 
    YEAR(order_date) AS order_year,
    SUM(total_amount) AS yearly_revenue
FROM orders
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Q3. Find orders placed on weekends.
SELECT 
    order_id,
    order_date,
    DAYNAME(order_date) AS day_name
FROM orders
WHERE DAYOFWEEK(order_date) IN (1, 7);

-- Q4:. Find customers registered in a particular year.
SELECT 
    customer_id,
    first_name,
    last_name,
    registration_date
FROM customers
WHERE YEAR(registration_date) = 2025;

-- ============================================
-- PART 11: STRING FUNCTIONS
-- ============================================

-- Q1: Generate full customer names
select concat(first_name, '  ',last_name) as fullname
 from customers;

-- Q2: Display restaurant names in uppercase
SELECT 
    restaurant_id,
    UPPER(restaurant_name) AS restaurant_name_upper,
    city
FROM Restaurants;



--  Q3: Generate formatted customer information

select 
    customer_id,
    CONCAT(
        UPPER(first_name), ' ', 
        UPPER(TRIM(last_name)), 
        ' | ', LOWER(TRIM(email)), 
        ' | ', city
    ) AS formatted_customer_info
FROM Customers;

-- Q4: Extract portions of email addresses
SELECT 
    customer_id,
    email,
    SUBSTRING(email, 1, LOCATE('@', email) - 1) AS email_username
FROM Customers;


-- ============================================
-- PART 12: MATHEMATICAL FUNCTIONS
-- ============================================

-- Q1: Rounded order values

SELECT 
    order_id,
    total_amount,
    ROUND(total_amount, 2) AS rounded_total_amount
FROM Orders;


-- Q2: Tax calculations
SELECT 
    order_id,
    subtotal,
    ROUND(subtotal * 0.05, 2) AS calculated_tax
FROM Orders;

-- Q3: Discount calculations
SELECT 
    order_id,
    subtotal,
    ceil(subtotal * 0.10) AS discount12
FROM Orders;


-- Q4: Delivery charges
SELECT 
    order_id,
    delivery_fee,
    ABS(delivery_fee) AS corrected_delivery_fee,
    ROUND(SQRT(POWER(delivery_fee, 2)), 2) AS validated_fee
FROM Orders;


-- MOD() example
SELECT 
    delivery_partner_id,
    first_name,
    CASE 
        WHEN MOD(delivery_partner_id, 2) = 0 THEN 'Shift A'
        ELSE 'Shift B'
    END AS shift_group
FROM Delivery_Partners;


-- ============================================
-- PART 13: SUBQUERIES
-- ============================================

-- SINGLE-ROW SUBQUERY
-- Find restaurants whose rating is greater than then
--  average restaurant rating

select restaurant_id,
restaurant_name,
rating
from restaurants where rating >
(select avg(rating) from restaurants);

-- Find customers who placed orders at restaurants
--  located in a particular city

select distinct  c.customer_id,
    c.first_name,
    c.last_name
    from customers c
    where c.customer_id in(
    SELECT o.customer_id
    FROM Orders o
    JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
    WHERE r.city = 'Mumbai'
);

-- Find customers whose spending is greater than the average spending
-- of customers who have placed more than 5 orders
SELECT 
    customer_id,
    total_spending
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spending
    FROM Orders
    GROUP BY customer_id
) AS customer_totals
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM (
        SELECT 
            customer_id,
            SUM(total_amount) AS total_spending,
            COUNT(order_id) AS order_count
        FROM Orders
        GROUP BY customer_id
        HAVING COUNT(order_id) > 5
    ) AS frequent_customers
);


-- For each customer, show their total spending alongside their basic info
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    (
        SELECT SUM(o.total_amount)
        FROM Orders o
        WHERE o.customer_id = c.customer_id
    ) AS total_spending
FROM Customers c;


-- ============================================
-- PART 14: SUBQUERY OPERATORS (IN, NOT IN, EXISTS, NOT EXISTS, ANY, ALL)
-- ============================================
-- Q1: Find customers who have placed at least one order
SELECT 
    customer_id,
    first_name,
    last_name
FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM Orders
);



-- Q2: Find customers who have never placed an order
SELECT 
    customer_id,
    first_name,
    last_name
FROM Customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM Orders 
   
);


-- Q3: Find restaurants that have received reviews
SELECT 
    r.restaurant_id,
    r.restaurant_name
FROM Restaurants r
WHERE EXISTS (
    SELECT 1 
    FROM Reviews rv 
    WHERE rv.restaurant_id = r.restaurant_id
);

-- Q4: Find restaurants that have never received a review
SELECT 
    r.restaurant_id,
    r.restaurant_name
FROM Restaurants r
WHERE NOT EXISTS (
    SELECT 1 
    FROM Reviews rv 
    WHERE rv.restaurant_id = r.restaurant_id
);


-- 5a. Restaurants rated higher than AT LEAST ONE restaurant in
-- a specific city
-- (ANY = greater than the minimum in the comparison set)
SELECT 
    restaurant_id,
    restaurant_name,
    rating
FROM Restaurants
WHERE rating > ANY (
    SELECT rating 
    FROM Restaurants 
    WHERE city = 'Delhi'
);



-- 5b. Restaurants rated higher than ALL restaurants in a specific city
-- (ALL = greater than the maximum in the comparison set)
SELECT 
    restaurant_id,
    restaurant_name,
    rating
FROM Restaurants
WHERE rating > ALL (
    SELECT rating 
    FROM Restaurants 
    WHERE city = 'Delhi'
);


-- ============================================
-- PART 15: TRANSACTIONS
-- ============================================


START TRANSACTION;

-- Step 1: Create the order
INSERT INTO Orders (customer_id, restaurant_id, delivery_partner_id, order_date, 
                     delivery_address, subtotal, delivery_fee, discount, tax, 
                     total_amount, order_status)
VALUES (12, 4, NULL, NOW(), '9 Park Street, Kolkata', 600.00, 45.00, 50.00, 30.00, 
        625.00, 'Placed');

SET @order_id_sp = LAST_INSERT_ID();

-- Mark a savepoint after the order is successfully created
SAVEPOINT after_order_created;

-- Step 2: Add order items
INSERT INTO Order_Items (order_id, item_id, quantity, unit_price, subtotal)
VALUES (@order_id_sp, 301, 2, 200.00, 400.00);

ROLLBACK TO SAVEPOINT after_order_created;

-- Retry Step 2 with corrected data
INSERT INTO Order_Items (order_id, item_id, quantity, unit_price, subtotal)
VALUES (@order_id_sp, 301, 2, 200.00, 400.00);

-- Step 3: Now record payment
INSERT INTO Payments (order_id, payment_date, payment_method, amount, 
                       payment_status, transaction_reference)
VALUES (@order_id_sp, NOW(), 'Credit Card', 625.00, 'Successful', 'TXN20260906002');

-- Everything is fine now, commit the whole transaction
COMMIT;



-- ============================================
-- PART 16: VIEWS
-- ============================================


CREATE VIEW vw_customer_order_details AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    r.restaurant_name,
    o.total_amount,
    o.order_date,
    o.order_status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id;

-- Usage example:
SELECT * FROM vw_customer_order_details 
WHERE order_status = 'Delivered'
ORDER BY order_date DESC;


-- ============================================
-- VIEW 2: Restaurant Performance
-- Purpose: A ready-made dashboard-style summary of how each restaurant
-- is performing — used by management to spot top/underperforming restaurants
-- without re-writing aggregation logic each time.
-- ============================================

CREATE VIEW vw_restaurant_performance AS
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue,
    ROUND(COALESCE(AVG(o.total_amount), 0), 2) AS avg_order_value,
    r.rating AS average_rating
FROM Restaurants r
LEFT JOIN Orders o 
    ON r.restaurant_id = o.restaurant_id 
    AND o.order_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name, r.city, r.rating;

-- Usage example:
SELECT * FROM vw_restaurant_performance
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- VIEW 3: Delivery Partner Performance
-- Purpose: Summarizes each delivery partner's workload and speed —
-- used for performance reviews, incentive calculations, or identifying
-- partners who need support/retraining.
-- ============================================

CREATE VIEW vw_delivery_partner_performance AS
SELECT 
    dp.delivery_partner_id,
    CONCAT(dp.first_name, ' ', dp.last_name) AS partner_name,
    COUNT(d.delivery_id) AS total_deliveries,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.pickup_time, d.delivery_time)), 2) AS avg_delivery_time_minutes,
    ROUND(AVG(rv.rating), 2) AS average_rating
FROM Delivery_Partners dp
LEFT JOIN Deliveries d 
    ON dp.delivery_partner_id = d.delivery_partner_id 
    AND d.delivery_status = 'Delivered'
LEFT JOIN Orders o ON d.order_id = o.order_id
LEFT JOIN Reviews rv ON rv.order_id = o.order_id
GROUP BY dp.delivery_partner_id, dp.first_name, dp.last_name;

-- Usage example:
SELECT * FROM vw_delivery_partner_performance
ORDER BY total_deliveries DESC;



-- ============================================
-- PART 17: STORED PROCEDURES
-- ============================================

-- PROCEDURE 1: Place an Order

DELIMITER //

CREATE PROCEDURE sp_place_order (
    IN p_customer_id INT,
    IN p_restaurant_id INT,
    IN p_delivery_address VARCHAR(255),
    IN p_item_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2),
    OUT p_new_order_id INT
)
BEGIN
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_delivery_fee DECIMAL(10,2) DEFAULT 40.00;
    DECLARE v_tax DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);

    -- Calculate subtotal for this item
    SET v_subtotal = p_quantity * p_unit_price;
    SET v_tax = ROUND(v_subtotal * 0.05, 2);
    SET v_total = v_subtotal + v_delivery_fee + v_tax;
     START TRANSACTION;

    -- Step 1: Create the order
    INSERT INTO Orders (customer_id, restaurant_id, delivery_partner_id, order_date,
                         delivery_address, subtotal, delivery_fee, discount, tax,
                         total_amount, order_status)
    VALUES (p_customer_id, p_restaurant_id, NULL, NOW(),
            p_delivery_address, v_subtotal, v_delivery_fee, 0.00, v_tax,
            v_total, 'Placed');

    SET p_new_order_id = LAST_INSERT_ID();

    -- Step 2: Insert the order item
    INSERT INTO Order_Items (order_id, item_id, quantity, unit_price, subtotal)
    VALUES (p_new_order_id, p_item_id, p_quantity, p_unit_price, v_subtotal);

    COMMIT;
END //

DELIMITER ;



-- Usage example:
CALL sp_place_order(5, 2, '221B Baker Street, Mumbai', 101, 2, 150.00, @order_id);
SELECT @order_id AS new_order_id;


-- ============================================
-- PROCEDURE 2: Generate Customer Spending Report
-- Purpose: Given a customer ID, returns a complete spending summary —
-- used by customer support or marketing teams to quickly pull up
-- a customer's order history and lifetime value on demand.
-- ============================================

DELIMITER //

CREATE PROCEDURE sp_customer_spending_report (
    IN p_customer_id INT
)
BEGIN
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.total_amount), 0) AS total_spent,
        ROUND(COALESCE(AVG(o.total_amount), 0), 2) AS avg_order_value,
        MAX(o.order_date) AS last_order_date,
        CASE 
            WHEN COALESCE(SUM(o.total_amount), 0) > 20000 THEN 'High Value'
            WHEN COALESCE(SUM(o.total_amount), 0) BETWEEN 5000 AND 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM Customers c
    LEFT JOIN Orders o 
        ON c.customer_id = o.customer_id 
        AND o.order_status = 'Delivered'
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name;
END //

DELIMITER ;

-- Usage example:
CALL sp_customer_spending_report(5);-- ============================================
-- PROCEDURE 2: Generate Customer Spending Report
-- Purpose: Given a customer ID, returns a complete spending summary —
-- used by customer support or marketing teams to quickly pull up
-- a customer's order history and lifetime value on demand.
-- ============================================

DELIMITER //

CREATE PROCEDURE sp_customer_spending_report (
    IN p_customer_id INT
)
BEGIN
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.total_amount), 0) AS total_spent,
        ROUND(COALESCE(AVG(o.total_amount), 0), 2) AS avg_order_value,
        MAX(o.order_date) AS last_order_date,
        CASE 
            WHEN COALESCE(SUM(o.total_amount), 0) > 20000 THEN 'High Value'
            WHEN COALESCE(SUM(o.total_amount), 0) BETWEEN 5000 AND 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM Customers c
    LEFT JOIN Orders o 
        ON c.customer_id = o.customer_id 
        AND o.order_status = 'Delivered'
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name;
END //

DELIMITER ;

-- Usage example:
CALL sp_customer_spending_report(5);




-- ============================================
-- PART 18: USER-DEFINED FUNCTIONS
-- ============================================

-- ============================================
-- FUNCTION 1: Calculate Delivery Charge Based on Distance


DELIMITER //

CREATE FUNCTION fn_calculate_delivery_charge(p_distance_km DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_charge DECIMAL(10,2);

    IF p_distance_km <= 3 THEN
        SET v_charge = 20.00;
    ELSEIF p_distance_km <= 7 THEN
        SET v_charge = 20.00 + ((p_distance_km - 3) * 5.00);
    ELSE
        SET v_charge = 20.00 + (4 * 5.00) + ((p_distance_km - 7) * 8.00);
    END IF;

    RETURN ROUND(v_charge, 2);
END //

DELIMITER ;

-- - Usage examples:
SELECT fn_calculate_delivery_charge(2.5) AS charge_short_distance;
SELECT fn_calculate_delivery_charge(5.0) AS charge_medium_distance;
SELECT fn_calculate_delivery_charge(10.0) AS charge_long_distance;



-- ============================================
-- FUNCTION 2: Categorize Customer Based on Total Spending
-- Purpose: Reusable version of the Low/Medium/High classification —
-- callable directly inside any query, instead of repeating a CASE block.
-- ============================================

DELIMITER //

CREATE FUNCTION fn_customer_segment(p_total_spending DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_segment VARCHAR(20);

    IF p_total_spending > 20000 THEN
        SET v_segment = 'High Value';
    ELSEIF p_total_spending >= 5000 THEN
        SET v_segment = 'Medium Value';
    ELSE
        SET v_segment = 'Low Value';
    END IF;

    RETURN v_segment;
END //

DELIMITER ;

-- Usage examples:
SELECT fn_customer_segment(25000) AS segment;   -- 'High Value'
SELECT fn_customer_segment(8000) AS segment;    -- 'Medium Value'
SELECT fn_customer_segment(1200) AS segment;    -- 'Low Value'


-- ============================================
-- PART 19: TRIGGERS
-- ============================================


-- TRIGGER 1: Update Order Total When Order Items Change

DELIMITER //

CREATE TRIGGER trg_update_order_total_after_insert
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET subtotal = (
            SELECT SUM(subtotal) 
            FROM Order_Items 
            WHERE order_id = NEW.order_id
        ),
        total_amount = (
            SELECT SUM(subtotal) 
            FROM Order_Items 
            WHERE order_id = NEW.order_id
        ) + delivery_fee + tax - discount
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;


-- TRIGGER 2: Update Order Status When Payment is Successful

DELIMITER //

CREATE TRIGGER trg_update_order_status_after_payment
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'Successful' THEN
        UPDATE Orders
        SET order_status = 'Confirmed'
        WHERE order_id = NEW.order_id
          AND order_status = 'Placed';
    END IF;
END //

DELIMITER ;


-- TRIGGER 3 (Bonus): Review Validation

DELIMITER //

CREATE TRIGGER trg_validate_review_rating
BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5.';
    END IF;
END //

DELIMITER ;


-- ============================================
-- PART 20: EVENTS
-- ============================================

-- Before creating events, MySQL's event scheduler must be turned ON
-- (it's OFF by default). This is a one-time server setting:
SET GLOBAL event_scheduler = ON;

-- You can check its current status with:
SHOW VARIABLES LIKE 'event_scheduler';


-- ============================================
-- EVENT 1: Expire Old Coupons Daily
-- Name: ev_expire_coupons
-- Schedule: Every day, once a day
-- Purpose: Coupons have an end_date. Once that date has passed,
-- the coupon should no longer be usable. Instead of checking
-- "is today past end_date?" in every single query that validates
-- a coupon, we proactively flip its status to 'Expired' once a day —
-- so every other part of the system can just check status = 'Active'.
-- SQL operation performed: UPDATE Coupons SET status = 'Expired' ...
-- ============================================

DELIMITER //

CREATE EVENT ev_expire_coupons
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY  -- starts running from tomorrow, at midnight
DO
BEGIN
    UPDATE Coupons
    SET status = 'Inactive'
    WHERE end_date < CURDATE()
      AND status = 'Active';
END //

DELIMITER ;

-- Manually test the logic behind the event, without waiting a full day:
-- UPDATE Coupons SET status = 'Inactive' WHERE end_date < CURDATE() AND status = 'Active';
-- SELECT * FROM Coupons WHERE status = 'Inactive';


-- ============================================
-- EVENT 2: Generate Daily Sales Summary
-- Name: ev_daily_sales_summary
-- Schedule: Every day, once a day (e.g., at midnight, summarizing the day just ended)
-- Purpose: Management wants a quick daily snapshot of performance
-- (orders, revenue) without running a manual report query every morning.
-- This event pre-calculates yesterday's numbers and stores them in a
-- small summary table, so dashboards can read from it instantly
-- instead of re-aggregating the entire Orders table every time.
-- SQL operation performed: INSERT INTO Daily_Sales_Summary (...) SELECT ...
-- ============================================

-- Supporting table for the event to write into:
CREATE TABLE Daily_Sales_Summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    summary_date DATE NOT NULL UNIQUE,
    total_orders INT NOT NULL,
    total_revenue DECIMAL(12,2) NOT NULL,
    average_order_value DECIMAL(10,2) NOT NULL,
    generated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE EVENT ev_daily_sales_summary
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO Daily_Sales_Summary (summary_date, total_orders, total_revenue, average_order_value)
    SELECT 
        CURDATE() - INTERVAL 1 DAY AS summary_date,
        COUNT(order_id),

