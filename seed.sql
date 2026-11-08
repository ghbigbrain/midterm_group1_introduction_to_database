-- seed.sql  |  Đề 05: Quản lý mượn trả sách thư viện  |  CSDL: library_mini

USE library_mini;
SET NAMES utf8mb4;

-- 1. categories (6)
INSERT INTO categories (category_id, name) VALUES
(1, 'Văn học'),
(2, 'Khoa học - Công nghệ'),
(3, 'Lịch sử'),
(4, 'Thiếu nhi'),
(5, 'Kỹ năng sống'),
(6, 'Ngoại ngữ');

-- 2. copies (10)
INSERT INTO copies (copy_id, title, author, barcode, category_id) VALUES
(1,  'Dế Mèn phiêu lưu ký',        'Tô Hoài',                           'LIB-0001', 4),
(2,  'Dế Mèn phiêu lưu ký',        'Tô Hoài',                           'LIB-0002', 4),
(3,  'Số đỏ',                       'Vũ Trọng Phụng',                    'LIB-0003', 1),
(4,  'Truyện Kiều',                 'Nguyễn Du',                         'LIB-0004', 1),
(5,  'Clean Code',                  'Robert C. Martin',                  'LIB-0005', 2),
(6,  'Database System Concepts',    'Silberschatz, Korth, Sudarshan',    'LIB-0006', 2),
(7,  'Sapiens: Lược sử loài người', 'Yuval Noah Harari',                 'LIB-0007', 3),
(8,  'Việt Nam sử lược',            'Trần Trọng Kim',                    'LIB-0008', 3),
(9,  'Đắc nhân tâm',                'Dale Carnegie',                     'LIB-0009', 5),
(10, 'English Grammar in Use',      'Raymond Murphy',                    'LIB-0010', 6);

-- 3. readers (12)
INSERT INTO readers (reader_id, full_name, dob, phone) VALUES
(1,  'Nguyễn Văn An',   '2003-05-14', '0900000001'),
(2,  'Trần Thị Bình',   '2002-11-02', '0900000002'),
(3,  'Lê Minh Châu',    '2001-08-21', '0900000003'),
(4,  'Phạm Quốc Dũng',  '2000-01-30', '0900000004'),
(5,  'Hoàng Thị Hà',    '2004-03-09', '0900000005'),
(6,  'Nguyễn Văn An',   '1999-12-25', '0900000006'),
(7,  'Vũ Thanh Hương',  '2003-07-17', '0900000007'),
(8,  'Đặng Hoài Nam',   '1998-09-05', '0900000008'),
(9,  'Bùi Thu Trang',   '2005-02-19', '0900000009'),
(10, 'Đỗ Gia Huy',      '2002-06-28', '0900000010'),
(11, 'Ngô Khánh Linh',  '2004-10-11', '0900000011'),
(12, 'Lý Bảo Ngọc',     '2001-04-03', '0900000012');

-- 4. loans (30)  -- (loan_id, reader_id, copy_id, loan_date, status, due_date)
INSERT INTO loans (loan_id, reader_id, copy_id, loan_date, status, due_date) VALUES
-- Ngoài năm 2025 (2024)
(1,  3,  8, '2024-11-20', 'Completed', '2024-12-04'),
(2,  4,  9, '2024-12-20', 'Completed', '2025-01-03'),
(3,  6,  1, '2024-12-31', 'Cancelled', '2025-01-14'),
-- Tháng 01/2025
(4,  1,  5, '2025-01-02', 'Completed', '2025-01-16'),
(5,  2,  1, '2025-01-08', 'Completed', '2025-01-22'),
(6,  3,  3, '2025-01-15', 'Completed', '2025-01-29'),
(7,  4,  6, '2025-01-20', 'Completed', '2025-02-03'),
(8,  7,  4, '2025-01-25', 'Cancelled', '2025-02-08'),
-- Tháng 02/2025
(9,  1,  6, '2025-02-03', 'Completed', '2025-02-17'),
(10, 2,  7, '2025-02-10', 'Completed', '2025-02-24'),
(11, 5,  2, '2025-02-12', 'Completed', '2025-02-26'),
(12, 12, 4, '2025-02-18', 'Cancelled', '2025-03-04'),
-- Tháng 03/2025
(13, 2,  4, '2025-03-03', 'Completed', '2025-03-17'),
(14, 3,  7, '2025-03-10', 'Completed', '2025-03-24'),
(15, 9,  2, '2025-03-20', 'Completed', '2025-04-03'),
(16, 10, 3, '2025-03-31', 'Pending',   '2025-04-14'),
-- Quý II-IV/2025
(17, 1,  1, '2025-04-07', 'Completed', '2025-04-21'),
(18, 4,  9, '2025-05-05', 'Completed', '2025-05-19'),
(19, 1,  5, '2025-06-10', 'Completed', '2025-06-24'),
(20, 2,  6, '2025-07-14', 'Completed', '2025-07-28'),
(21, 3,  1, '2025-08-04', 'Completed', '2025-08-18'),
(22, 1,  7, '2025-09-01', 'Completed', '2025-09-15'),
(23, 5,  9, '2025-10-06', 'Cancelled', '2025-10-20'),
(24, 8,  7, '2025-11-03', 'Completed', '2025-11-17'),
(25, 7,  2, '2025-11-20', 'Completed', '2025-12-04'),
(26, 9,  1, '2025-12-31', 'Cancelled', '2026-01-14'),
-- Ngoài năm 2025 (2026)
(27, 4,  8, '2026-01-01', 'Completed', '2026-01-15'),
(28, 6,  4, '2026-10-28', 'Active',    '2026-11-11'),
(29, 10, 6, '2026-10-30', 'Active',    '2026-11-13'),
(30, 8,  8, '2026-11-05', 'Pending',   '2026-11-19');


-- 5. return_records (21)  
-- đúng 1 biên bản cho mỗi lượt Completed
-- (return_id, loan_id, return_date, condition_note, fine_amount)
INSERT INTO return_records (return_id, loan_id, return_date, condition_note, fine_amount) VALUES
(1,  1,  '2024-12-10', 'Trả trễ 6 ngày',                 15000),
(2,  2,  '2025-01-02', 'Bình thường',                        0),
(3,  4,  '2025-01-15', 'Bình thường',                        0),
(4,  5,  '2025-01-27', 'Trả trễ 5 ngày, rách bìa',       25000),
(5,  6,  '2025-02-03', 'Trả trễ 5 ngày, nhàu trang',     25000),
(6,  7,  '2025-02-01', 'Bình thường',                        0),
(7,  9,  '2025-02-24', 'Trả trễ 7 ngày, rách bìa',       35000),
(8,  10, '2025-02-21', 'Bình thường',                        0),
(9,  11, '2025-02-28', 'Trả trễ 2 ngày, bẩn bìa',        12000),
(10, 13, '2025-03-16', 'Bình thường',                        0),
(11, 14, '2025-03-31', 'Trả trễ 7 ngày',                 20000),
(12, 15, '2025-04-05', 'Trả trễ 2 ngày, nhàu trang',     12000),
(13, 17, '2025-04-20', 'Bình thường',                        0),
(14, 18, '2025-05-26', 'Trả trễ 7 ngày, rách bìa',       21000),
(15, 19, '2025-06-30', 'Trả trễ 6 ngày, hỏng gáy sách',  30000),
(16, 20, '2025-07-25', 'Bình thường',                        0),
(17, 21, '2025-08-15', 'Bình thường',                        0),
(18, 22, '2025-09-14', 'Bình thường',                        0),
(19, 24, '2025-11-14', 'Bình thường',                        0),
(20, 25, '2025-12-12', 'Trả trễ 8 ngày, mất trang',      40000),
(21, 27, '2026-01-14', 'Bình thường',                        0);

-- 6. payments (11)  
-- chỉ thu cho lượt đã có chi phí xác nhận (> 0)
-- (payment_id, loan_id, amount, payment_date, method)
INSERT INTO payments (payment_id, loan_id, amount, payment_date, method) VALUES
(1,  1,  15000, '2025-01-08', 'BankTransfer'),  
(2,  5,  25000, '2025-01-27', 'Cash'),          
(3,  6,  10000, '2025-02-03', 'Cash'),          
(4,  9,  20000, '2025-02-25', 'Cash'),          
(5,  11, 12000, '2025-03-02', 'Card'),          
(6,  9,  15000, '2025-03-05', 'BankTransfer'),  
(7,  14, 20000, '2025-03-31', 'Cash'),          
(8,  15, 12000, '2025-04-05', 'Card'),          
(9,  18, 11000, '2025-05-26', 'Cash'),          
(10, 19, 30000, '2025-06-30', 'Cash'),          
(11, 18, 10000, '2026-01-10', 'BankTransfer');  

-- 7. TRUY VẤN KIỂM TRA DỮ LIỆU
--    Các cột "violations" / "orphan_rows" đều phải bằng 0.
--    Các INSERT ở trên đã đi qua trigger của schema.sql; các truy vấn này vẫn giữ để đối chiếu
--    lại toàn bộ dữ liệu (ví dụ khi nạp lúc trigger đang bị tắt hoặc sau khi sửa dữ liệu).

-- 7.1. Số bản ghi từng bảng so với mức tối thiểu của đề (total_rows >= min_required)
SELECT 'categories' AS table_name, COUNT(*) AS total_rows, 5  AS min_required FROM categories
UNION ALL SELECT 'copies',         COUNT(*), 6  FROM copies
UNION ALL SELECT 'readers',        COUNT(*), 10 FROM readers
UNION ALL SELECT 'loans',          COUNT(*), 12 FROM loans
UNION ALL SELECT 'return_records', COUNT(*), 10 FROM return_records
UNION ALL SELECT 'payments',       COUNT(*), 10 FROM payments;

-- 7.2. Kiểm tra khóa ngoại: không có dòng con trỏ tới dòng cha không tồn tại
SELECT 'copies.category_id -> categories' AS fk_check, COUNT(*) AS orphan_rows
FROM copies c LEFT JOIN categories g ON g.category_id = c.category_id
WHERE g.category_id IS NULL
UNION ALL
SELECT 'loans.reader_id -> readers', COUNT(*)
FROM loans l LEFT JOIN readers r ON r.reader_id = l.reader_id
WHERE r.reader_id IS NULL
UNION ALL
SELECT 'loans.copy_id -> copies', COUNT(*)
FROM loans l LEFT JOIN copies c ON c.copy_id = l.copy_id
WHERE c.copy_id IS NULL
UNION ALL
SELECT 'return_records.loan_id -> loans', COUNT(*)
FROM return_records r LEFT JOIN loans l ON l.loan_id = r.loan_id
WHERE l.loan_id IS NULL
UNION ALL
SELECT 'payments.loan_id -> loans', COUNT(*)
FROM payments p LEFT JOIN loans l ON l.loan_id = p.loan_id
WHERE l.loan_id IS NULL;

-- 7.3. Quan hệ giữa trạng thái lượt mượn và biên bản trả sách
SELECT 'Completed nhưng không có biên bản' AS check_name, COUNT(*) AS violations
FROM loans l LEFT JOIN return_records r ON r.loan_id = l.loan_id
WHERE l.status = 'Completed' AND r.return_id IS NULL
UNION ALL
SELECT 'Không phải Completed nhưng có biên bản', COUNT(*)
FROM loans l JOIN return_records r ON r.loan_id = l.loan_id
WHERE l.status <> 'Completed'
UNION ALL
SELECT 'Lượt mượn có nhiều hơn 1 biên bản', COUNT(*)
FROM (SELECT loan_id FROM return_records GROUP BY loan_id HAVING COUNT(*) > 1) x
UNION ALL
SELECT 'return_date sớm hơn loan_date', COUNT(*)
FROM return_records r JOIN loans l ON l.loan_id = r.loan_id
WHERE r.return_date < l.loan_date;

-- 7.4. Thanh toán: chỉ thu khi đã có chi phí xác nhận, tổng thu không vượt chi phí
SELECT 'Thu tiền khi chưa có biên bản trả sách' AS check_name, COUNT(*) AS violations
FROM payments p LEFT JOIN return_records r ON r.loan_id = p.loan_id
WHERE r.return_id IS NULL
UNION ALL
SELECT 'Thu tiền cho lượt có chi phí bằng 0', COUNT(*)
FROM payments p JOIN return_records r ON r.loan_id = p.loan_id
WHERE r.fine_amount = 0
UNION ALL
SELECT 'Ngày thu sớm hơn ngày lập biên bản', COUNT(*)
FROM payments p JOIN return_records r ON r.loan_id = p.loan_id
WHERE p.payment_date < r.return_date
UNION ALL
SELECT 'Tổng thu vượt chi phí đã xác nhận', COUNT(*)
FROM (
    SELECT p.loan_id
    FROM payments p JOIN return_records r ON r.loan_id = p.loan_id
    GROUP BY p.loan_id, r.fine_amount
    HAVING SUM(p.amount) > r.fine_amount
) x;

-- 7.5. Kiểm tra dữ liệu đủ các tình huống đề yêu cầu (cột so_luong phải >= 1)
SELECT 'Lượt mượn tháng 01/2025' AS tinh_huong, COUNT(*) AS so_luong
FROM loans WHERE loan_date BETWEEN '2025-01-01' AND '2025-01-31'
UNION ALL
SELECT 'Lượt mượn tháng 02-03/2025 (còn lại của quý I)', COUNT(*)
FROM loans WHERE loan_date BETWEEN '2025-02-01' AND '2025-03-31'
UNION ALL
SELECT 'Lượt mượn ngoài quý I, trong năm 2025', COUNT(*)
FROM loans WHERE loan_date BETWEEN '2025-04-01' AND '2025-12-31'
UNION ALL
SELECT 'Lượt mượn trước năm 2025', COUNT(*)
FROM loans WHERE loan_date < '2025-01-01'
UNION ALL
SELECT 'Lượt mượn sau năm 2025', COUNT(*)
FROM loans WHERE loan_date > '2025-12-31'
UNION ALL
SELECT 'Trạng thái Completed', COUNT(*) FROM loans WHERE status = 'Completed'
UNION ALL
SELECT 'Trạng thái Pending', COUNT(*) FROM loans WHERE status = 'Pending'
UNION ALL
SELECT 'Trạng thái Active', COUNT(*) FROM loans WHERE status = 'Active'
UNION ALL
SELECT 'Trạng thái Cancelled', COUNT(*) FROM loans WHERE status = 'Cancelled'
UNION ALL
SELECT 'Bạn đọc có hơn 3 lượt Completed trong năm 2025', COUNT(*)
FROM (
    SELECT reader_id FROM loans
    WHERE status = 'Completed' AND loan_date BETWEEN '2025-01-01' AND '2025-12-31'
    GROUP BY reader_id HAVING COUNT(*) > 3
) x
UNION ALL
SELECT 'Bạn đọc có lịch sử mượn nhưng chưa thanh toán', COUNT(*)
FROM readers rd
WHERE EXISTS (SELECT 1 FROM loans l WHERE l.reader_id = rd.reader_id)
  AND NOT EXISTS (SELECT 1 FROM loans l JOIN payments p ON p.loan_id = l.loan_id
                  WHERE l.reader_id = rd.reader_id)
UNION ALL
SELECT 'Lượt mượn được trả tiền nhiều lần', COUNT(*)
FROM (SELECT loan_id FROM payments GROUP BY loan_id HAVING COUNT(*) > 1) x
UNION ALL
SELECT 'Lượt mượn còn nợ', COUNT(*)
FROM (
    SELECT r.loan_id
    FROM return_records r LEFT JOIN payments p ON p.loan_id = r.loan_id
    GROUP BY r.loan_id, r.fine_amount
    HAVING r.fine_amount > COALESCE(SUM(p.amount), 0)
) x
UNION ALL
SELECT 'Thể loại chưa có giao dịch trong quý I/2025', COUNT(*)
FROM categories g
WHERE NOT EXISTS (SELECT 1 FROM copies c JOIN loans l ON l.copy_id = c.copy_id
                  WHERE c.category_id = g.category_id
                    AND l.loan_date BETWEEN '2025-01-01' AND '2025-03-31')
UNION ALL
SELECT 'Bản sách chưa có giao dịch trong năm 2025', COUNT(*)
FROM copies c
WHERE NOT EXISTS (SELECT 1 FROM loans l
                  WHERE l.copy_id = c.copy_id
                    AND l.loan_date BETWEEN '2025-01-01' AND '2025-12-31');

-- 8. MINH HỌA INSERT / UPDATE VI PHẠM RÀNG BUỘC (để trong chú thích để file vẫn chạy được)
--    (a)-(h): bị ràng buộc của bảng chặn (UNIQUE, FOREIGN KEY, CHECK, ENUM).
--    (i)-(o): bị TRIGGER trong schema.sql chặn (SQLSTATE '45000', MySQL báo lỗi 1644 kèm thông báo).

-- (a) Trùng barcode -> vi phạm UNIQUE (lỗi 1062 Duplicate entry)
-- INSERT INTO copies (copy_id, title, author, barcode, category_id)
-- VALUES (11, 'Sách trùng mã', 'Không rõ', 'LIB-0001', 1);

-- (b) Thể loại không tồn tại -> vi phạm FOREIGN KEY (lỗi 1452)
-- INSERT INTO copies (copy_id, title, author, barcode, category_id)
-- VALUES (11, 'Sách thể loại ma', 'Không rõ', 'LIB-0011', 99);

-- (c) due_date trước loan_date -> vi phạm CHECK (lỗi 3819)
-- INSERT INTO loans (loan_id, reader_id, copy_id, loan_date, status, due_date)
-- VALUES (31, 1, 1, '2025-05-10', 'Active', '2025-05-01');

-- (d) Trạng thái không hợp lệ -> vi phạm ENUM (Data truncated, khi bật strict mode)
-- INSERT INTO loans (loan_id, reader_id, copy_id, loan_date, status, due_date)
-- VALUES (31, 1, 1, '2025-05-10', 'Lost', '2025-05-24');

-- (e) Lượt mượn đã có biên bản (loan 4) -> vi phạm UNIQUE loan_id (lỗi 1062)
-- INSERT INTO return_records (return_id, loan_id, return_date, condition_note, fine_amount)
-- VALUES (22, 4, '2025-01-16', 'Bình thường', 0);

-- (f) Chi phí âm -> vi phạm CHECK fine_amount >= 0 (lỗi 3819).
--     Trigger chỉ cho lập biên bản với lượt Completed chưa có biên bản, mà mọi lượt Completed
--     trong dữ liệu mẫu đều đã có biên bản, nên tạo thêm loan 31 trước (xóa loan 31 sau khi thử).
-- INSERT INTO loans (loan_id, reader_id, copy_id, loan_date, status, due_date)
-- VALUES (31, 1, 1, '2025-05-10', 'Completed', '2025-05-24');
-- INSERT INTO return_records (return_id, loan_id, return_date, condition_note, fine_amount)
-- VALUES (22, 31, '2025-05-20', 'Thử nghiệm', -5000);
-- DELETE FROM loans WHERE loan_id = 31;

-- (g) Số tiền thanh toán không dương -> vi phạm CHECK amount > 0 (lỗi 3819)
-- INSERT INTO payments (payment_id, loan_id, amount, payment_date, method)
-- VALUES (12, 6, 0, '2025-02-10', 'Cash');

-- (h) Phương thức thanh toán không hợp lệ -> vi phạm ENUM
-- INSERT INTO payments (payment_id, loan_id, amount, payment_date, method)
-- VALUES (12, 6, 5000, '2025-02-10', 'Momo');

-- (i) Thu vượt chi phí: loan 9 đã thu đủ 35.000 -> trigger trg_payments_bi từ chối:
--     'Tổng tiền thu vượt chi phí đã xác nhận của lượt mượn'
-- INSERT INTO payments (payment_id, loan_id, amount, payment_date, method)
-- VALUES (12, 9, 1000, '2025-03-10', 'Cash');

-- (j) Thu tiền cho lượt chưa có biên bản (loan 28 đang Active) -> trigger trg_payments_bi từ chối:
--     'Lượt mượn chưa có biên bản trả sách nên chưa thể thu tiền'
-- INSERT INTO payments (payment_id, loan_id, amount, payment_date, method)
-- VALUES (12, 28, 5000, '2026-11-06', 'Cash');

-- (k) Thu tiền cho lượt có chi phí bằng 0 (loan 4) -> trigger trg_payments_bi từ chối:
--     'Lượt mượn không phát sinh chi phí nên không thu tiền'
-- INSERT INTO payments (payment_id, loan_id, amount, payment_date, method)
-- VALUES (12, 4, 1000, '2025-02-01', 'Cash');

-- (l) Ngày thu sớm hơn ngày lập biên bản (loan 6 lập biên bản ngày 2025-02-03) -> trigger từ chối:
--     'Ngày thu không được sớm hơn ngày lập biên bản'
-- INSERT INTO payments (payment_id, loan_id, amount, payment_date, method)
-- VALUES (12, 6, 5000, '2025-02-01', 'Cash');

-- (m) Lập biên bản cho lượt chưa Completed (loan 28 đang Active) -> trigger trg_return_records_bi từ chối:
--     'Chỉ lập biên bản trả sách cho lượt mượn Completed'
-- INSERT INTO return_records (return_id, loan_id, return_date, condition_note, fine_amount)
-- VALUES (22, 28, '2026-11-01', 'Thử nghiệm', 5000);

-- (n) return_date sớm hơn loan_date (biên bản 2 thuộc loan 2, mượn ngày 2024-12-20) -> trigger
--     trg_return_records_bu từ chối: 'return_date không được sớm hơn loan_date'
-- UPDATE return_records SET return_date = '2024-12-01' WHERE return_id = 2;

-- (o) Giảm chi phí xuống thấp hơn số đã thu (biên bản 7 thuộc loan 9, đã thu 35.000) -> trigger
--     trg_return_records_bu từ chối: 'Chi phí không được thấp hơn số tiền đã thu của lượt mượn'
-- UPDATE return_records SET fine_amount = 10000 WHERE return_id = 7;
