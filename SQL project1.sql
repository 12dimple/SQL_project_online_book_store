-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--DATA IMPORTED FROM IMPORT/EXPORT DATA FEATURE 


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM Books 
WHERE published_year>1950;

-- 3) List all customers from the Canada:
SELECT* FROM customers;

SELECT name FROM Customers 
WHERE country='Canada';


-- 4) Show orders placed in November 2023:
SELECT*FROM orders;

SELECT* FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';
-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) FROM books AS total_stock_available;


-- 6) Find the details of the most expensive book:

SELECT * FROM Books;

SELECT* FROM books ORDER BY price DESC;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT*FROM customers;

SELECT*FROM orders;

SELECT c.name, o.quantity FROM customers c RIGHT JOIN orders o ON c.customer_id = o.customer_id WHERE o.quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT*FROM orders WHERE total_amount>20;


-- 9) List all genres available in the Books table:

SELECT*FROM books;

SELECT DISTINCT(genre) FROM books;

-- 10) Find the book with the lowest stock:

SELECT * FROM books ORDER BY stock ASC;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) FROM orders AS total_revenue;
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT*FROM books;
SELECT*FROM customers;
SELECT*FROM orders;

SELECT SUM(quantity), genre FROM orders o JOIN books b ON o.book_id= b.book_id GROUP BY b.genre; 
--OR
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) FROM books WHERE genre ='Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(order_id) AS order_quantity 
FROM customers c 
JOIN orders o 
ON c.customer_id= o.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id)>=2;



-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title;
--OR
SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM books b
JOIN orders o ON o.book_id = b.book_id
GROUP BY o.book_id, b.title;
-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT title, price 
FROM books 
WHERE genre='Fantasy' 
ORDER BY price DESC 
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity)
FROM books b 
JOIN orders o
ON b.book_id= o.book_id
GROUP BY b.author, o.book_id;

--OR

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;





-- 7) List the cities where customers who spent over $30 are located:

SELECT c.city 
FROM customers c 
JOIN orders o
ON 
c.customer_id= o.customer_id
GROUP BY c.city, o.total_amount
HAVING o.total_amount>30;
--OR 
SELECT DISTINCT(city), o.total_amount
FROM customers c
JOIN orders o
ON c.customer_id= o.customer_id
WHERE o.total_amount>30;
--OR 
SELECT DISTINCT(city)
FROM customers c
JOIN orders o
ON c.customer_id= o.customer_id
WHERE o.total_amount>30;  --THIS WILL RETURN ONLY UNIQUE CITIES AND NOT REPEAT THE CITIES 



-- 8) Find the customer who spent the most on orders:
SELECT c.name, o.customer_id, SUM(o.total_amount)
FROM customers c
JOIN orders o
ON c.customer_id= o.customer_id
GROUP BY c.name, o.customer_id
ORDER BY SUM(o.total_amount) DESC
LIMIT 1;
--OR
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;










