CREATE DATABASE OfficeEquipment;
USE OfficeEquipment;

-- 1. Tạo bảng Phòng ban 
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- 2. Tạo bảng Nhân viên 
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 3. Tạo bảng Thiết bị 
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(100),
    Type VARCHAR(50),
    Unit VARCHAR(20),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 4. Tạo bảng Bảo trì 
CREATE TABLE Maintenance (
    MaintenanceID INT PRIMARY KEY,
    EquipmentID INT,
    MaintenanceDate DATE,
    Description TEXT,
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

-- 5. Tạo bảng Mua sắm
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY,
    EquipmentID INT,
    PurchaseDate DATE,
    Value DECIMAL(15, 2),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

-- Chèn dữ liệu mẫu (5 dòng mỗi bảng) 
INSERT INTO Departments VALUES (1, 'Kế toán'), (2, 'Nhân sự'), (3, 'IT'), (4, 'Marketing'), (5, 'Giám đốc');
INSERT INTO Employees VALUES (101, 'Nguyen Van A', 1), (102, 'Tran Thi B', 2), (103, 'Le Van C', 3), (104, 'Pham Van D', 4), (105, 'Hoang Thi E', 5);
INSERT INTO Equipment VALUES (201, 'Dell XPS 13', 'Laptop', 'Cái', 3), (202, 'HP LaserJet', 'Máy in', 'Cái', 1), (203, 'Ghế xoay', 'Nội thất', 'Cái', 2), (204, 'MacBook Pro', 'Laptop', 'Cái', 4), (205, 'Màn hình LG', 'Phụ kiện', 'Cái', 3);
INSERT INTO Maintenance VALUES (301, 201, '2025-10-10', 'Cài lại Win'), (302, 202, '2025-11-15', 'Thay mực');
INSERT INTO Purchases VALUES (401, 201, '2025-01-20', 25000000), (402, 202, '2025-02-10', 5000000);
-- 1. Index: Tăng tốc tìm kiếm theo tên thiết bị 
CREATE INDEX idx_equipment_name ON Equipment(EquipmentName);

-- 2. View: Thống kê thiết bị theo từng phòng ban 
CREATE VIEW View_EquipmentByDept AS
SELECT d.DepartmentName, e.EquipmentName, e.Type
FROM Departments d
JOIN Equipment e ON d.DepartmentID = e.DepartmentID;

-- 3. Function: Tính tổng giá trị tài sản đang có 
DELIMITER //
CREATE FUNCTION TotalAssetValue() RETURNS DECIMAL(15,2) DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15,2);
    SELECT SUM(Value) INTO total FROM Purchases;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- 4. Stored Procedure: Thêm nhanh một bản ghi bảo trì 
DELIMITER //
CREATE PROCEDURE AddMaintenance(IN eqID INT, IN mDate DATE, IN descr TEXT)
BEGIN
    INSERT INTO Maintenance (EquipmentID, MaintenanceDate, Description)
    VALUES (eqID, mDate, descr);
END //
DELIMITER ;

-- 5. Trigger: Tự động ghi log hoặc thông báo (Ví dụ đơn giản) 
-- (Vì bảng Equipment chưa có cột Status, ta tạo trigger kiểm tra giá trị mua sắm không được âm)
DELIMITER //
CREATE TRIGGER Before_Purchase_Insert
BEFORE INSERT ON Purchases
FOR EACH ROW
BEGIN
    IF NEW.Value < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá trị không được âm';
    END IF;
END //
DELIMITER ;