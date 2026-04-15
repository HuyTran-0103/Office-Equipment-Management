import mysql.connector
from mysql.connector import Error

def connect_db():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="11111111",
            database="OfficeEquipment"
        )
        return connection
    except Error as e:
        print(f"Lỗi kết nối: {e}")
        return None

def add_equipment():
    db = connect_db()
    if db is None: return
    
    cursor = db.cursor()
    print("\n--- THÊM THIẾT BỊ MỚI ---")
    try:
        eq_id = input("ID: ")
        name = input("Tên thiết bị: ")
        eq_type = input("Loại: ")
        unit = input("Đơn vị: ")
        dept_id = input("Mã phòng ban (1-5): ")
        
        sql = "INSERT INTO Equipment (EquipmentID, EquipmentName, Category, Unit, DepartmentID) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(sql, (eq_id, name, eq_type, unit, dept_id))
        db.commit()
        print("Thêm thành công!")
    except Error as e:
        print(f"Lỗi khi thêm dữ liệu: {e}")
    finally:
        db.close()

def show_maintenance():
    db = connect_db()
    if db is None: return
    
    cursor = db.cursor()
    print("\n--- DANH SÁCH CHI PHÍ BẢO TRÌ ---")
    try:
        # Nếu chưa có bảng Maintenance, câu lệnh này sẽ báo lỗi thay vì sập app
        cursor.execute("SELECT EquipmentID, MaintenanceDate, Cost FROM Maintenance")
        rows = cursor.fetchall()
        if not rows:
            print("Chưa có dữ liệu bảo trì.")
        for row in rows:
            print(f"ID Thiết bị: {row[0]} | Ngày: {row[1]} | Chi phí: {row[2]} VND")
    except Error as e:
        print("Lưu ý: Bảng Maintenance chưa tồn tại hoặc lỗi truy vấn.")
    finally:
        db.close()

def show_report():
    db = connect_db()
    if db is None: return
    
    cursor = db.cursor()
    print("\n--- BÁO CÁO PHÂN BỔ THIẾT BỊ ---")
    try:
        cursor.execute("SELECT * FROM View_EquipmentByDept")
        rows = cursor.fetchall()
        for row in rows:
            print(f"Phòng: {row[0]} | Tên: {row[1]} | Loại: {row[2]}")
    except Error as e:
        print("Lưu ý: View_EquipmentByDept chưa tồn tại hoặc lỗi truy vấn.")
    finally:
        db.close()

while True:
    print("\n=== HỆ THỐNG QUẢN LÝ THIẾT BỊ ===")
    print("1. Thêm thiết bị")
    print("2. Xem chi phí bảo trì")
    print("3. Xem báo cáo phân bổ")
    print("4. Thoát")
    
    choice = input("Chọn chức năng: ")
    
    if choice == '1': add_equipment()
    elif choice == '2': show_maintenance()
    elif choice == '3': show_report()
    elif choice == '4': break
    else: print("Lựa chọn không hợp lệ!")