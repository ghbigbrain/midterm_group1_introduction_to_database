-- schema.sql  |  Đề 05: Quản lý mượn trả sách thư viện  |  CSDL: library_mini

CREATE DATABASE IF NOT EXISTS library_mini
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE library_mini;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS return_records;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS readers;
DROP TABLE IF EXISTS copies;
DROP TABLE IF EXISTS categories;

-- Thể loại sách
CREATE TABLE categories (
    category_id INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_categories_name (name)
) ENGINE = InnoDB;

-- Bản sách
CREATE TABLE copies (
    copy_id     INT          NOT NULL AUTO_INCREMENT,
    title       VARCHAR(200) NOT NULL,
    author      VARCHAR(150) NOT NULL,
    barcode     VARCHAR(30)  NOT NULL,
    category_id INT          NOT NULL,
    PRIMARY KEY (copy_id),
    UNIQUE KEY uq_copies_barcode (barcode),
    CONSTRAINT fk_copies_category
        FOREIGN KEY (category_id) REFERENCES categories (category_id)
) ENGINE = InnoDB;

-- Bạn đọc
CREATE TABLE readers (
    reader_id INT          NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    dob       DATE         NULL,
    phone     VARCHAR(15)  NULL,
    PRIMARY KEY (reader_id)
) ENGINE = InnoDB;

-- Lượt đăng ký mượn
CREATE TABLE loans (
    loan_id   INT  NOT NULL AUTO_INCREMENT,
    reader_id INT  NOT NULL,
    copy_id   INT  NOT NULL,
    loan_date DATE NOT NULL,
    status    ENUM('Pending', 'Active', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending',
    due_date  DATE NOT NULL,
    PRIMARY KEY (loan_id),
    CONSTRAINT fk_loans_reader FOREIGN KEY (reader_id) REFERENCES readers (reader_id),
    CONSTRAINT fk_loans_copy   FOREIGN KEY (copy_id)   REFERENCES copies (copy_id),
    CONSTRAINT ck_loans_due_date CHECK (due_date >= loan_date)
) ENGINE = InnoDB;

-- Biên bản trả sách
CREATE TABLE return_records (
    return_id      INT           NOT NULL AUTO_INCREMENT,
    loan_id        INT           NOT NULL,
    return_date    DATE          NOT NULL,
    condition_note VARCHAR(255)  NULL,
    fine_amount    DECIMAL(12,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (return_id),
    UNIQUE KEY uq_return_records_loan (loan_id),
    CONSTRAINT fk_return_records_loan FOREIGN KEY (loan_id) REFERENCES loans (loan_id),
    CONSTRAINT ck_return_fine CHECK (fine_amount >= 0)
) ENGINE = InnoDB;

-- Thanh toán
CREATE TABLE payments (
    payment_id   INT           NOT NULL AUTO_INCREMENT,
    loan_id      INT           NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    payment_date DATE          NOT NULL,
    method       ENUM('Cash', 'BankTransfer', 'Card') NOT NULL,
    PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_loan FOREIGN KEY (loan_id) REFERENCES loans (loan_id),
    CONSTRAINT ck_payments_amount CHECK (amount > 0)
) ENGINE = InnoDB;
