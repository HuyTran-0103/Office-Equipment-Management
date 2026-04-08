import mysql.connector

def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root", 
        password="11111111", 
        database="OfficeEquipment"
    )

def add_equipment():
    db = connect_db()
    cursor = db.cursor()
    print("\n--- THÊM THIẾT BỊ MỚI ---")
    eq_id = input("ID: ")
    name = input("Tên thiết bị: ")
    eq_type = input("Loại: ")
    unit = input("Đơn vị: ")
    dept_id = input("Mã phòng ban (1-5): ")
    
    sql = "INSERT INTO Equipment VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(sql, (eq_id, name, eq_type, unit, dept_id))
    db.commit()
    print("Thêm thành công!")
    db.close()

def show_report():
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM View_EquipmentByDept")
    print("\n--- BÁO CÁO PHÂN BỔ THIẾT BỊ ---")
    for row in cursor.fetchall():
        print(f"Phòng: {row[0]} | Tên: {row[1]} | Loại: {row[2]}")
    db.close()

# Menu chính
while True:
    print("\n=== HỆ THỐNG QUẢN LÝ THIẾT BỊ ===")
    print("1. Thêm thiết bị")
    print("2. Xem báo cáo phân bổ")
    print("3. Thoát")
    choice = input("Chọn chức năng: ")
    
    if choice == '1': add_equipment()
    elif choice == '2': show_report()
    elif choice == '3': break