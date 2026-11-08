-- views.sql  |  Đề 05: Quản lý mượn trả sách thư viện  |  CSDL: library_mini

USE library_mini;

-- Xóa các VIEW nếu đã tồn tại để có thể chạy lại file nhiều lần
DROP VIEW IF EXISTS v_debt;
DROP VIEW IF EXISTS v_group_summary;
DROP VIEW IF EXISTS v_detail;

-- 1. VIEW v_detail
CREATE VIEW v_detail AS
SELECT 
    l.loan_id,
    l.loan_date,
    l.due_date,
    rr.return_date,
    l.status,
    r.reader_id,
    r.full_name AS reader_name,
    c.copy_id,
    c.barcode,
    c.title AS copy_title,
    g.category_id,
    g.name AS category_name,
    rr.fine_amount
FROM loans l
JOIN readers r              ON r.reader_id = l.reader_id
JOIN copies c               ON c.copy_id = l.copy_id
JOIN categories g           ON g.category_id = c.category_id
LEFT JOIN return_records rr ON rr.loan_id = l.loan_id;

-- 2. VIEW v_group_summary
CREATE VIEW v_group_summary AS
SELECT 
    g.category_id,
    g.name AS category_name,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE WHEN l.status = 'Completed' THEN 1 ELSE 0 END) AS completed_loans,
    SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_loans,
    COALESCE(SUM(rr.fine_amount), 0) AS total_fine_amount
FROM categories g
LEFT JOIN copies c          ON c.category_id = g.category_id
LEFT JOIN loans l           ON l.copy_id = c.copy_id
LEFT JOIN return_records rr ON rr.loan_id = l.loan_id
GROUP BY g.category_id, g.name;

-- 3. VIEW v_debt
-- (Tổng hợp payments theo từng loan_id trước khi nối để tránh nhân bản fine_amount đối với các lượt mượn thanh toán nhiều lần như loan 9, 18).
CREATE VIEW v_debt AS
SELECT 
    r.reader_id,
    r.full_name AS reader_name,
    COALESCE(SUM(rr.fine_amount), 0) AS total_confirmed_fine,
    COALESCE(SUM(p_sum.paid_amount), 0) AS total_paid,
    COALESCE(SUM(rr.fine_amount), 0) - COALESCE(SUM(p_sum.paid_amount), 0) AS remaining_debt
FROM readers r
LEFT JOIN loans l           ON l.reader_id = r.reader_id
LEFT JOIN return_records rr ON rr.loan_id = l.loan_id
LEFT JOIN (
    SELECT loan_id, SUM(amount) AS paid_amount
    FROM payments
    GROUP BY loan_id
) p_sum ON p_sum.loan_id = l.loan_id
GROUP BY r.reader_id, r.full_name;

-- TRUY VẤN KIỂM TRA VIEW
SELECT * FROM v_detail ORDER BY loan_id;
SELECT * FROM v_group_summary ORDER BY category_id;
SELECT * FROM v_debt ORDER BY reader_id;
