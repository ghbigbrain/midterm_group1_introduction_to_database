-- queries.sql  |  Đề 05: Quản lý mượn trả sách thư viện  |  CSDL: library_mini

USE library_mini;

-- Câu 1: Liệt kê các lượt đăng ký mượn Completed trong tháng 01/2025, kèm bạn đọc, bản sách và ngày nghiệp vụ loan_date.
SELECT 
    l.loan_id,
    r.reader_id,
    r.full_name AS reader_name,
    c.copy_id,
    c.barcode,
    c.title AS copy_title,
    l.loan_date,
    l.status
FROM loans l
JOIN readers r ON r.reader_id = l.reader_id
JOIN copies c  ON c.copy_id = l.copy_id
WHERE l.status = 'Completed'
  AND l.loan_date BETWEEN '2025-01-01' AND '2025-01-31'
ORDER BY l.loan_date ASC, l.loan_id ASC;

-- Câu 2: Đếm tổng số lượt đăng ký mượn theo từng thể loại sách trong quý I/2025, tính mọi trạng thái; hiển thị cả nhóm có số lượng bằng 0.
SELECT 
    g.category_id,
    g.name AS category_name,
    COUNT(l.loan_id) AS total_loans_q1_2025
FROM categories g
LEFT JOIN copies c ON c.category_id = g.category_id
LEFT JOIN loans l  ON l.copy_id = c.copy_id
                  AND l.loan_date BETWEEN '2025-01-01' AND '2025-03-31'
GROUP BY g.category_id, g.name
ORDER BY total_loans_q1_2025 DESC, g.category_id ASC;

-- Câu 3: Liệt kê các bạn đọc có ít nhất một lượt đăng ký mượn chưa có biên bản trả sách, loại trừ Cancelled. Mỗi người chỉ xuất hiện một lần.
SELECT DISTINCT
    r.reader_id,
    r.full_name AS reader_name,
    r.dob,
    r.phone
FROM readers r
JOIN loans l               ON l.reader_id = r.reader_id
LEFT JOIN return_records rr ON rr.loan_id = l.loan_id
WHERE l.status <> 'Cancelled'
  AND rr.return_id IS NULL
ORDER BY r.reader_id ASC;

-- Câu 4: Tính phí phát sinh trung bình trên một giao dịch Completed của từng thể loại sách, xét toàn bộ thời gian; chỉ lấy nhóm đã phát sinh chi phí.
SELECT 
    g.category_id,
    g.name AS category_name,
    COUNT(l.loan_id) AS completed_loans,
    SUM(rr.fine_amount) AS total_fine_amount,
    ROUND(AVG(rr.fine_amount), 2) AS avg_fine_per_completed_loan
FROM categories g
JOIN copies c          ON c.category_id = g.category_id
JOIN loans l           ON l.copy_id = c.copy_id
JOIN return_records rr ON rr.loan_id = l.loan_id
WHERE l.status = 'Completed'
GROUP BY g.category_id, g.name
HAVING SUM(rr.fine_amount) > 0
ORDER BY avg_fine_per_completed_loan DESC, g.category_id ASC;

-- Câu 5: Liệt kê 3 bản sách có nhiều lượt đăng ký mượn Completed nhất trong năm 2025.
-- Nếu bằng nhau, ưu tiên mã copy_id tăng dần; chỉ lấy đối tượng có giao dịch.
SELECT 
    c.copy_id,
    c.barcode,
    c.title AS copy_title,
    c.author,
    COUNT(l.loan_id) AS completed_loans_2025
FROM copies c
JOIN loans l ON l.copy_id = c.copy_id
WHERE l.status = 'Completed'
  AND l.loan_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY c.copy_id, c.barcode, c.title, c.author
HAVING COUNT(l.loan_id) > 0
ORDER BY completed_loans_2025 DESC, c.copy_id ASC
LIMIT 3;

-- Câu 6: Tính tổng số tiền từng bạn đọc đã thanh toán trong năm 2025 theo payment_date; hiển thị cả người chưa trả tiền với tổng bằng 0.
SELECT 
    r.reader_id,
    r.full_name AS reader_name,
    COALESCE(SUM(p.amount), 0) AS total_paid_2025
FROM readers r
LEFT JOIN loans l    ON l.reader_id = r.reader_id
LEFT JOIN payments p ON p.loan_id = l.loan_id
                    AND p.payment_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY r.reader_id, r.full_name
ORDER BY total_paid_2025 DESC, r.reader_id ASC;

-- Câu 7: Liệt kê các bạn đọc chưa có bất kỳ bản ghi thanh toán nào trong toàn bộ dữ liệu, kể cả người chưa có giao dịch.
SELECT 
    r.reader_id,
    r.full_name AS reader_name,
    r.dob,
    r.phone
FROM readers r
WHERE NOT EXISTS (
    SELECT 1
    FROM loans l
    JOIN payments p ON p.loan_id = l.loan_id
    WHERE l.reader_id = r.reader_id
)
ORDER BY r.reader_id ASC;

-- Câu 8: Liệt kê toàn bộ bạn đọc theo tổng phí phát sinh đã xác nhận giảm dần,
-- không phụ thuộc đã thanh toán hay chưa; nếu bằng nhau, sắp theo mã tăng dần.
SELECT 
    r.reader_id,
    r.full_name AS reader_name,
    COALESCE(SUM(rr.fine_amount), 0) AS total_confirmed_fine
FROM readers r
LEFT JOIN loans l           ON l.reader_id = r.reader_id
LEFT JOIN return_records rr ON rr.loan_id = l.loan_id
GROUP BY r.reader_id, r.full_name
ORDER BY total_confirmed_fine DESC, r.reader_id ASC;


-- Câu 9: Tính tỷ lệ hủy của từng bản sách trong năm 2025: số lượt đăng ký mượn
-- Cancelled chia tổng số lượt đăng ký mượn của năm, nhân 100.
-- Làm tròn 2 chữ số thập phân; trả NULL nếu tổng bằng 0.
SELECT 
    c.copy_id,
    c.barcode,
    c.title AS copy_title,
    COUNT(l.loan_id) AS total_loans_2025,
    SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_loans_2025,
    ROUND(
        SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(l.loan_id), 0),
        2
    ) AS cancel_rate_percent
FROM copies c
LEFT JOIN loans l ON l.copy_id = c.copy_id
                 AND l.loan_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY c.copy_id, c.barcode, c.title
ORDER BY c.copy_id ASC;

-- Câu 10: Liệt kê các bạn đọc có hơn 3 lượt đăng ký mượn Completed trong năm 2025,
-- kèm số lần; sắp số lần giảm dần.
SELECT 
    r.reader_id,
    r.full_name AS reader_name,
    COUNT(l.loan_id) AS completed_loans_2025
FROM readers r
JOIN loans l ON l.reader_id = r.reader_id
WHERE l.status = 'Completed'
  AND l.loan_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY r.reader_id, r.full_name
HAVING COUNT(l.loan_id) > 3
ORDER BY completed_loans_2025 DESC, r.reader_id ASC;
