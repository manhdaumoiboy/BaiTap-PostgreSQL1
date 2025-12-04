/* HỌ TÊN: [Tên của bạn]
   BÀI TẬP: Quản lý Lương Nhân Viên (Employee Salary Management)
*/

-- =============================================
-- PHẦN 1: KHỞI TẠO DỮ LIỆU
-- =============================================

-- 1. Tạo bảng employees
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary NUMERIC(15, 0), -- Dùng Numeric cho số tiền lớn
    bonus NUMERIC(15, 0),
    join_year INT
);

-- 2. Chèn dữ liệu mẫu (Bao gồm cả dòng bị trùng là ID 4)
INSERT INTO employees (full_name, department, position, salary, bonus, join_year) VALUES
('Nguyễn Văn Huy', 'IT', 'Developer', 18000000, 1000000, 2021),
('Trần Thị Mai', 'HR', 'Recruiter', 12000000, NULL, 2020),
('Lê Quốc Trung', 'IT', 'Tester', 15000000, 800000, 2023),
('Nguyễn Văn Huy', 'IT', 'Developer', 18000000, 1000000, 2021), -- Dòng trùng lặp
('Phạm Ngọc Hân', 'Finance', 'Accountant', 14000000, NULL, 2019),
('Bùi Thị Lan', 'HR', 'HR Manager', 20000000, 3000000, 2018),
('Đặng Hữu Tài', 'IT', 'Developer', 17000000, NULL, 2022);

-- =============================================
-- PHẦN 2: GIẢI BÀI TẬP
-- =============================================

-- Yêu cầu 1: Chuẩn hóa dữ liệu (Xóa bản ghi trùng lặp)
-- Giữ lại người có ID nhỏ nhất, xóa các ID lớn hơn bị trùng thông tin
DELETE FROM employees
WHERE id NOT IN (
    SELECT MIN(id)
    FROM employees
    GROUP BY full_name, department, position
);

-- Yêu cầu 2a: Tăng 10% lương cho phòng IT có lương dưới 18 triệu
UPDATE employees
SET salary = salary * 1.1
WHERE department = 'IT' AND salary < 18000000;

-- Yêu cầu 2b: Cập nhật bonus = 500,000 cho nhân viên chưa có thưởng (NULL)
UPDATE employees
SET bonus = 500000
WHERE bonus IS NULL;

-- Yêu cầu 3: Truy vấn phức hợp (Phòng IT/HR, vào sau 2020, thu nhập > 15tr)
-- Sắp xếp giảm dần theo thu nhập và lấy 3 người đầu tiên
SELECT *, (salary + bonus) AS total_income
FROM employees
WHERE department IN ('IT', 'HR')
  AND join_year > 2020
  AND (salary + bonus) > 15000000
ORDER BY (salary + bonus) DESC
LIMIT 3;

-- Yêu cầu 4: Tìm tên bắt đầu bằng "Nguyễn" HOẶC kết thúc bằng "Hân"
SELECT * FROM employees
WHERE full_name LIKE 'Nguyễn%' OR full_name LIKE '%Hân';

-- Yêu cầu 5: Liệt kê phòng ban duy nhất có nhân viên có bonus
SELECT DISTINCT department
FROM employees
WHERE bonus IS NOT NULL;

-- Yêu cầu 6: Nhân viên gia nhập từ 2019 đến 2022
SELECT * FROM employees
WHERE join_year BETWEEN 2019 AND 2022;
