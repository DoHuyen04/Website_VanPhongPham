<%-- 
    Document   : gio_hang
    Created on : Oct 11, 2025, 1:55:37 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.SanPham" %>
<%
    List<Map<String,Object>> gioHang = (List<Map<String,Object>>) session.getAttribute("gioHang");
    if (gioHang == null) gioHang = new ArrayList<>();
    double tong = 0;
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Giỏ hàng</title><link rel="stylesheet" href="css/kieu.css"></head>
<body>
<h2>Giỏ hàng</h2>
<% if (gioHang.isEmpty()) { %>
    <p>Giỏ hàng trống</p>
<% } else { %>
    <table border="1" cellpadding="6">
        <tr><th>Ảnh</th><th>Tên</th><th>Giá</th><th>Số lượng</th><th>Thành tiền</th><th>Hành động</th></tr>
        <% for (Map<String,Object> item : gioHang) {
            SanPham sp = (SanPham) item.get("sanpham");
            int sl = (int) item.get("soluong");
            double thanh = sp.getGia() * sl;
            tong += thanh;
        %>
        <tr>
            <td><img src="hinh_anh/<%= sp.getHinhAnh() %>" width="80"/></td>
            <td><%= sp.getTen() %></td>
            <td><%= sp.getGia() %></td>
            <td>
                <form action="giohang" method="get" style="display:inline">
                    <input type="hidden" name="hanhDong" value="capnhat">
                    <input type="hidden" name="id" value="<%= sp.getId() %>">
                    <input type="number" name="soLuong" value="<%= sl %>" min="1" style="width:60px">
                    <button type="submit">Cập nhật</button>
                </form>
            </td>
            <td><%= thanh %></td>
            <td><a href="giohang?hanhDong=xoa&id=<%= sp.getId() %>">Xóa</a></td>
        </tr>
        <% } %>
    </table>
    <h3>Tổng: <%= tong %> VNĐ</h3>
    <a href="donhang?hanhDong=thanhtoan">Tiến hành thanh toán</a>
<% } %>
</body>
</html>
