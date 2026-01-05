CREATE DATABASE library_managemnet;
USE library_managemnet;

CREATE TABLE librarian (
    librarian_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    membership_date DATE NOT NULL
);

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT,
    category_id INT,
    isbn VARCHAR(20) UNIQUE,
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE book_issues (
    issue_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT NOT NULL,
    fine_amount DECIMAL(6,2) NOT NULL,
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (issue_id) REFERENCES book_issues(issue_id)
);

INSERT INTO librarian (name, email, phone) VALUES
('Admin User', 'admin@library.com', '9876543210');

INSERT INTO members (name, email, phone, address, membership_date) VALUES
('Ammar', 'ammar@example.com', '1234567890', 'Sukkur', '2024-01-01'),
('iqra', 'iqra@example.com', '9876543211', 'Khairpur', '2024-02-15');

INSERT INTO authors (name) VALUES
('J.K. Rowling'),
('George Orwell'),
('Robert C. Martin');

INSERT INTO categories (category_name) VALUES
('Fiction'),
('Science'),
('Programming');

INSERT INTO books (title, author_id, category_id, isbn, total_copies, available_copies) VALUES
('Harry Potter', 1, 1, '9780439708180', 10, 8),
('1984', 2, 1, '9780451524935', 5, 5),
('Clean Code', 3, 3, '9780132350884', 7, 6);
INSERT INTO book_issues (book_id, member_id, issue_date, due_date) VALUES
(1, 1, '25-12-2025', '25-01-2026'),
(3, 2, '18-12-2025', '18-01-2026');

INSERT INTO fines (issue_id, fine_amount, paid) VALUES
(1, 50.00, FALSE);

SELECT * FROM books;

SELECT * FROM authors;

SELECT 
    b.book_id,
    b.title,
    a.name AS author_name,
    c.category_name,
    b.available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id;

SELECT SUM(total_copies) AS total_books FROM books;

SELECT SUM(available_copies) AS available_books FROM books;

SELECT 
    m.name,
    COUNT(bi.issue_id) AS books_issued
FROM members m
JOIN book_issues bi ON m.member_id = bi.member_id
GROUP BY m.member_id
HAVING COUNT(bi.issue_id) > 1;

SELECT 
    c.category_name,
    COUNT(b.book_id) AS total_books
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id;


SELECT m.name, b.title, bi.issue_date, bi.due_date
FROM book_issues bi
JOIN members m ON bi.member_id = m.member_id
JOIN books b ON bi.book_id = b.book_id;

SELECT * FROM fines WHERE paid = FALSE;



