#!/usr/bin/env python3
# xpath_reports.py - Báo cáo XPath nâng cao
# Cài: pip install lxml tabulate

import os
from lxml import etree
from tabulate import tabulate

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
XML_FILE = os.path.join(BASE_DIR, "quanlytiemhoa.xml")

def load_xml(path):
    parser = etree.XMLParser(remove_blank_text=True)
    return etree.parse(path, parser)

# 1. Tổng tồn kho và giá trị
def xpath_total_inventory(tree):
    qty = tree.xpath("sum(/HeThongQuanLyTiemHoa/SanPhams/SanPham/SoLuongTon)")
    total_value = 0.0
    for sp in tree.xpath("/HeThongQuanLyTiemHoa/SanPhams/SanPham"):
        so = int(sp.findtext("SoLuongTon"))
        gia = float(sp.findtext("Gia"))
        total_value += so * gia
    return {"total_quantity": int(qty), "total_value": total_value}

# 2. Thống kê doanh thu
def xpath_total_revenue(tree):
    orders = tree.xpath("/HeThongQuanLyTiemHoa/DonHangs/DonHang")
    total = sum(float(o.findtext("SoTien")) for o in orders)
    avg_order = total / len(orders) if orders else 0
    num_customers = len(set(tree.xpath("/HeThongQuanLyTiemHoa/DonHangs/DonHang/@MaKH")))
    return {"total_revenue": total, "avg_order": avg_order, "num_customers": num_customers}

# 3. Đếm số đơn theo trạng thái
def xpath_orders_by_status_count(tree):
    statuses = [s.text for s in tree.xpath("/HeThongQuanLyTiemHoa/DonHangs/DonHang/TrangThai")]
    unique_statuses = sorted(set(statuses))
    results = []
    for s in unique_statuses:
        count = len(tree.xpath(f"/HeThongQuanLyTiemHoa/DonHangs/DonHang[TrangThai='{s}']"))
        results.append((s, count))
    return results

# 4. Top sản phẩm bán chạy
def xpath_top_products_by_qty(tree, top_n=5):
    counts = {}
    for ct in tree.xpath("/HeThongQuanLyTiemHoa/ChiTietDonHangs/ChiTietDonHang"):
        maSP = ct.get("MaSP")
        so = int(ct.findtext("SoLuong"))
        counts[maSP] = counts.get(maSP, 0) + so
    items = []
    for maSP, cnt in counts.items():
        ten = tree.xpath(f"string(/HeThongQuanLyTiemHoa/SanPhams/SanPham[@MaSP='{maSP}']/TenHoa)")
        items.append((maSP, ten, cnt))
    items.sort(key=lambda x: x[2], reverse=True)
    return items[:top_n]

# 5. Top khách hàng chi tiêu nhiều nhất
def xpath_top_customers(tree, top_n=3):
    spend = {}
    for d in tree.xpath("/HeThongQuanLyTiemHoa/DonHangs/DonHang"):
        maKH = d.get("MaKH")
        tien = float(d.findtext("SoTien"))
        spend[maKH] = spend.get(maKH, 0) + tien
    result = []
    for maKH, tong in spend.items():
        ten = tree.xpath(f"string(/HeThongQuanLyTiemHoa/KhachHangs/KhachHang[@MaKH='{maKH}']/HoTen)")
        result.append((maKH, ten, tong))
    result.sort(key=lambda x: x[2], reverse=True)
    return result[:top_n]

# 6. Danh sách đơn hàng theo trạng thái (Dùng để lấy "Đã giao")
def xpath_orders_by_status(tree, status):
    orders = tree.xpath(f"/HeThongQuanLyTiemHoa/DonHangs/DonHang[TrangThai='{status}']")
    return [{
        "Mã ĐH": d.get("MaDH"),
        "Mã KH": d.get("MaKH"),
        "Tổng tiền": float(d.findtext("TongTien")),
        "Trạng thái": d.findtext("TrangThai"),
        "Thanh toán": d.findtext("HinhThucTT")
    } for d in orders]

def main():
    tree = load_xml(XML_FILE)

    print("\n== 1. TỔNG TỒN KHO ==")
    inv = xpath_total_inventory(tree)
    print(tabulate([[inv['total_quantity'], f"{inv['total_value']:,}"]],
                   headers=["Tổng SL tồn", "Giá trị tồn (VND)"], tablefmt="grid"))

    print("\n== 2. THỐNG KÊ DOANH THU ==")
    revenue = xpath_total_revenue(tree)
    print(tabulate([[f"{revenue['total_revenue']:,}", f"{revenue['avg_order']:,}", revenue['num_customers']]],
                   headers=["Tổng doanh thu", "TB mỗi đơn (VND)", "Số KH mua hàng"], tablefmt="grid"))

    print("\n== 3. SỐ ĐƠN THEO TRẠNG THÁI ==")
    orders_count = xpath_orders_by_status_count(tree)
    print(tabulate(orders_count, headers=["Trạng thái", "Số đơn"], tablefmt="github"))

    print("\n== 4. TOP 5 SẢN PHẨM BÁN CHẠY ==")
    top_products = xpath_top_products_by_qty(tree)
    print(tabulate(top_products, headers=["Mã SP", "Tên Hoa", "Số lượng bán"], tablefmt="fancy_grid"))

    print("\n== 5. TOP 3 KHÁCH HÀNG CHI TIÊU NHIỀU NHẤT ==")
    top_customers = xpath_top_customers(tree)
    print(tabulate(top_customers, headers=["Mã KH", "Họ tên", "Tổng chi tiêu (VND)"], tablefmt="psql"))

    print("\n== 6. DANH SÁCH ĐƠN HÀNG 'ĐÃ GIAO' ==")
    orders = xpath_orders_by_status(tree, "Đã giao")
    print(tabulate(orders, headers="keys", tablefmt="grid"))

if __name__ == "__main__":
    main()
