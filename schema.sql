-- schema.sql  |  Đề 05: Quản lý mượn trả sách thư viện  |  CSDL: library_mini

CREATE DATABASE IF NOT EXISTS library_mini
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE library_mini;
SET NAMES utf8mb4;

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

-- =====================================================================
-- TRIGGER: các quy tắc liên quan nhiều bảng (CHECK không truy vấn được bảng khác)
--   * payments: chỉ thu tiền khi lượt mượn đã có biên bản trả sách với chi phí > 0;
--               ngày thu không sớm hơn ngày lập biên bản;
--               tổng tiền đã thu của một lượt mượn không vượt chi phí đã xác nhận.
--   * return_records: chỉ lập biên bản cho lượt mượn Completed; return_date không trước
--               loan_date; chi phí không thấp hơn số tiền đã thu; không lập biên bản
--               muộn hơn ngày đã thu tiền.
-- Vi phạm bị từ chối bằng SIGNAL SQLSTATE '45000' (MySQL báo lỗi 1644 kèm thông báo).
-- Chạy trong MySQL Workbench hoặc mysql CLI (cần hiểu lệnh DELIMITER).
-- =====================================================================
DELIMITER $$

-- Biên bản trả sách: kiểm tra khi thêm mới
DROP TRIGGER IF EXISTS trg_return_records_bi$$
CREATE TRIGGER trg_return_records_bi
BEFORE INSERT ON return_records
FOR EACH ROW
BEGIN
    DECLARE v_status    VARCHAR(20);
    DECLARE v_loan_date DATE;

    SELECT status, loan_date INTO v_status, v_loan_date
    FROM loans
    WHERE loan_id = NEW.loan_id;

    -- Nếu loan_id không tồn tại thì v_status là NULL và lỗi khóa ngoại sẽ được báo sau đó
    IF v_status IS NOT NULL AND v_status <> 'Completed' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chỉ lập biên bản trả sách cho lượt mượn Completed';
    END IF;
    IF NEW.return_date < v_loan_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'return_date không được sớm hơn loan_date';
    END IF;
END$$

-- Biên bản trả sách: kiểm tra khi sửa
DROP TRIGGER IF EXISTS trg_return_records_bu$$
CREATE TRIGGER trg_return_records_bu
BEFORE UPDATE ON return_records
FOR EACH ROW
BEGIN
    DECLARE v_status    VARCHAR(20);
    DECLARE v_loan_date DATE;
    DECLARE v_paid      DECIMAL(12,2);

    SELECT status, loan_date INTO v_status, v_loan_date
    FROM loans
    WHERE loan_id = NEW.loan_id;

    IF v_status IS NOT NULL AND v_status <> 'Completed' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chỉ lập biên bản trả sách cho lượt mượn Completed';
    END IF;
    IF NEW.return_date < v_loan_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'return_date không được sớm hơn loan_date';
    END IF;

    SELECT COALESCE(SUM(amount), 0) INTO v_paid
    FROM payments
    WHERE loan_id = NEW.loan_id;

    IF v_paid > NEW.fine_amount THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chi phí không được thấp hơn số tiền đã thu của lượt mượn';
    END IF;
    IF EXISTS (SELECT 1 FROM payments
               WHERE loan_id = NEW.loan_id AND payment_date < NEW.return_date) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Biên bản không được lập muộn hơn ngày đã thu tiền';
    END IF;
END$$

-- Thanh toán: kiểm tra khi thêm mới
DROP TRIGGER IF EXISTS trg_payments_bi$$
CREATE TRIGGER trg_payments_bi
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_fine        DECIMAL(12,2);
    DECLARE v_return_date DATE;
    DECLARE v_paid        DECIMAL(12,2);

    SELECT fine_amount, return_date INTO v_fine, v_return_date
    FROM return_records
    WHERE loan_id = NEW.loan_id;

    IF v_fine IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lượt mượn chưa có biên bản trả sách nên chưa thể thu tiền';
    END IF;
    IF v_fine = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lượt mượn không phát sinh chi phí nên không thu tiền';
    END IF;
    IF NEW.payment_date < v_return_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ngày thu không được sớm hơn ngày lập biên bản';
    END IF;

    SELECT COALESCE(SUM(amount), 0) INTO v_paid
    FROM payments
    WHERE loan_id = NEW.loan_id;

    IF v_paid + NEW.amount > v_fine THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tổng tiền thu vượt chi phí đã xác nhận của lượt mượn';
    END IF;
END$$

-- Thanh toán: kiểm tra khi sửa (không tính chính dòng đang sửa vào tổng đã thu)
DROP TRIGGER IF EXISTS trg_payments_bu$$
CREATE TRIGGER trg_payments_bu
BEFORE UPDATE ON payments
FOR EACH ROW
BEGIN
    DECLARE v_fine        DECIMAL(12,2);
    DECLARE v_return_date DATE;
    DECLARE v_paid        DECIMAL(12,2);

    SELECT fine_amount, return_date INTO v_fine, v_return_date
    FROM return_records
    WHERE loan_id = NEW.loan_id;

    IF v_fine IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lượt mượn chưa có biên bản trả sách nên chưa thể thu tiền';
    END IF;
    IF v_fine = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lượt mượn không phát sinh chi phí nên không thu tiền';
    END IF;
    IF NEW.payment_date < v_return_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ngày thu không được sớm hơn ngày lập biên bản';
    END IF;

    SELECT COALESCE(SUM(amount), 0) INTO v_paid
    FROM payments
    WHERE loan_id = NEW.loan_id AND payment_id <> OLD.payment_id;

    IF v_paid + NEW.amount > v_fine THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tổng tiền thu vượt chi phí đã xác nhận của lượt mượn';
    END IF;
END$$

DELIMITER ;