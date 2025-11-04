<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
        <head>
            <title>Hệ thống quản lý tiệm hoa</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f5f8fa;
                    color: #222;
                    margin: 20px;
                }
                h1 {
                    color: #004aad;
                    text-align: center;
                    margin-bottom: 30px;
                }
                h2 {
                    color: #004aad;
                    border-bottom: 2px solid #004aad;
                    padding-bottom: 4px;
                }
                table {
                    border-collapse: collapse;
                    width: 100%;
                    margin-bottom: 25px;
                }
                th, td {
                    border: 1px solid #aaa;
                    padding: 6px 8px;
                    text-align: left;
                }
                th {
                    background-color: #dbeafe;
                }
                tr:nth-child(even) {
                    background-color: #f9f9f9;
                }
                .section {
                    margin-bottom: 40px;
                }
                .footer {
                    text-align: center;
                    margin-top: 40px;
                    font-style: italic;
                    color: #555;
                }
            </style>
        </head>

        <body>
            <h1>HỆ THỐNG QUẢN LÝ TIỆM HOA</h1>

            <!-- 1. DANH SÁCH HOA CÓ GIÁ TRÊN 30.000 -->
            <div class="section">
                <h2>1. Danh sách hoa có giá trên 30.000 VND</h2>
                <table>
                    <tr><th>Tên hoa</th><th>Loại</th><th>Giá</th><th>Tồn kho</th></tr>
                    <xsl:for-each select="HeThongQuanLyTiemHoa/SanPhams/SanPham[Gia &gt; 30000]">
                        <tr>
                            <td><xsl:value-of select="TenHoa"/></td>
                            <td><xsl:value-of select="LoaiHoa"/></td>
                            <td><xsl:value-of select="Gia"/></td>
                            <td><xsl:value-of select="SoLuongTon"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>

            <!-- 2. DANH SÁCH ĐƠN HÀNG ĐÃ GIAO -->
            <div class="section">
                <h2>2. Danh sách đơn hàng đã giao</h2>
                <table>
                    <tr><th>Mã ĐH</th><th>Khách hàng</th><th>Tổng tiền</th><th>Ngày giao</th></tr>
                    <xsl:for-each select="HeThongQuanLyTiemHoa/DonHangs/DonHang[TrangThai='Đã giao']">
                        <tr>
                            <td><xsl:value-of select="@MaDH"/></td>
                            <td><xsl:value-of select="@MaKH"/></td>
                            <td><xsl:value-of select="TongTien"/></td>
                            <td><xsl:value-of select="NgayGiao"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>

            <!-- 3. DANH SÁCH KHÁCH HÀNG Ở CẦN THƠ -->
            <div class="section">
                <h2>3. Khách hàng ở khu vực Cần Thơ</h2>
                <table>
                    <tr><th>Mã KH</th><th>Họ tên</th><th>SĐT</th><th>Địa chỉ</th></tr>
                    <xsl:for-each select="HeThongQuanLyTiemHoa/KhachHangs/KhachHang[contains(DiaChi, 'Cần Thơ')]">
                        <tr>
                            <td><xsl:value-of select="@MaKH"/></td>
                            <td><xsl:value-of select="HoTen"/></td>
                            <td><xsl:value-of select="SDT"/></td>
                            <td><xsl:value-of select="DiaChi"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>

            <!-- 4. DANH SÁCH VOUCHER CÒN HẠN -->
            <div class="section">
                <h2>4. Voucher còn hạn sử dụng</h2>
                <table>
                    <tr><th>Mã Voucher</th><th>Tên</th><th>Giảm (%)</th><th>Ngày KT</th><th>Trạng thái</th></tr>
                    <xsl:for-each select="HeThongQuanLyTiemHoa/Vouchers/Voucher[TrangThai='Còn hạn']">
                        <tr>
                            <td><xsl:value-of select="@MaVoucher"/></td>
                            <td><xsl:value-of select="TenVoucher"/></td>
                            <td><xsl:value-of select="GiaTri"/></td>
                            <td><xsl:value-of select="NgayKT"/></td>
                            <td><xsl:value-of select="TrangThai"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>

            <!-- 5. DANH SÁCH HOA CỦA NHÀ CUNG CẤP "Hoa Lan Đà Lạt" -->
            <div class="section">
                <h2>5. Sản phẩm của nhà cung cấp "Hoa Lan Đà Lạt"</h2>
                <table>
                    <tr><th>Tên hoa</th><th>Loại</th><th>Giá</th></tr>
                    <xsl:variable name="MaNCCDL" select="HeThongQuanLyTiemHoa/NhaCungCaps/NhaCungCap[TenNCC='Hoa Lan Đà Lạt']/@MaNCC"/>
                    <xsl:for-each select="HeThongQuanLyTiemHoa/SanPhams/SanPham[@MaNCC=$MaNCCDL]">
                        <tr>
                            <td><xsl:value-of select="TenHoa"/></td>
                            <td><xsl:value-of select="LoaiHoa"/></td>
                            <td><xsl:value-of select="Gia"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>

            <!-- 6. THỐNG KÊ TỔNG DOANH THU -->
            <div class="section">
                <h2>6. Thống kê tổng doanh thu</h2>
                <table>
                    <tr>
                        <th>Chỉ tiêu</th>
                        <th>Giá trị</th>
                    </tr>
                    <tr>
                        <td>Tổng số sản phẩm</td>
                        <td><xsl:value-of select="count(HeThongQuanLyTiemHoa/SanPhams/SanPham)"/></td>
                    </tr>
                    <tr>
                        <td>Tổng số khách hàng</td>
                        <td><xsl:value-of select="count(HeThongQuanLyTiemHoa/KhachHangs/KhachHang)"/></td>
                    </tr>
                    <tr>
                        <td>Tổng số đơn hàng</td>
                        <td><xsl:value-of select="count(HeThongQuanLyTiemHoa/DonHangs/DonHang)"/></td>
                    </tr>
                    <tr>
                        <td>Tổng doanh thu (VND)</td>
                        <td><xsl:value-of select="sum(HeThongQuanLyTiemHoa/DonHangs/DonHang/TongTien)"/></td>
                    </tr>
                    <tr>
                        <td>Tổng tiền đã thanh toán (VND)</td>
                        <td><xsl:value-of select="sum(HeThongQuanLyTiemHoa/DonHangs/DonHang/SoTien)"/></td>
                    </tr>
                </table>
            </div>

            <!-- 7. ĐƠN HÀNG CÓ TỔNG TIỀN > 300.000 -->
            <div class="section">
                <h2>7. Danh sách đơn hàng có tổng tiền lớn hơn 300.000 VND</h2>
                <table>
                    <tr><th>Mã ĐH</th><th>Khách hàng</th><th>Tổng tiền</th><th>Trạng thái</th></tr>
                    <xsl:for-each select="HeThongQuanLyTiemHoa/DonHangs/DonHang[TongTien &gt; 300000]">
                        <tr>
                            <td><xsl:value-of select="@MaDH"/></td>
                            <td><xsl:value-of select="@MaKH"/></td>
                            <td><xsl:value-of select="TongTien"/></td>
                            <td><xsl:value-of select="TrangThai"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>

            <!-- 8. THỐNG KÊ SỐ LƯỢNG ĐƠN HÀNG THEO TRẠNG THÁI -->
                <div class="section">
                    <h2>8. Thống kê đơn hàng theo trạng thái</h2>
                    <table>
                        <tr><th>Trạng thái</th><th>Số lượng</th></tr>
                        <tr>
                            <td>Đã giao</td>
                            <td><xsl:value-of select="count(HeThongQuanLyTiemHoa/DonHangs/DonHang[TrangThai='Đã giao'])"/></td>
                        </tr>
                        <tr>
                            <td>Đang giao</td>
                            <td><xsl:value-of select="count(HeThongQuanLyTiemHoa/DonHangs/DonHang[TrangThai='Đang giao'])"/></td>
                        </tr>
                        <tr>
                            <td>Đã hủy</td>
                            <td><xsl:value-of select="count(HeThongQuanLyTiemHoa/DonHangs/DonHang[TrangThai='Đã hủy'])"/></td>
                        </tr>
                    </table>
                </div>
        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
