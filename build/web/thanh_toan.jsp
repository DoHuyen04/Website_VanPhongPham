<%-- 
    Document   : thanh_toan
    Created on : Oct 11, 2025, 1:56:12 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.SanPham" %>
<%
    List<Map<String,Object>> gioHang = (List<Map<String,Object>>) session.getAttribute("gioHang");
    if (gioHang == null || gioHang.isEmpty()) { response.sendRedirect("gio_hang.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Thanh toán</title></head>
<body>
<h2>Thanh toán</h2>
<form action="donhang" method="post">
    <label>Địa chỉ</label><br><input name="diaChi" required><br>
    <label>SDT</label><br><input name="soDienThoai" required><br>
    <label>Phương thức</label><br>
    <select name="phuongThuc">
        <option value="COD">COD</option>
        <option value="ChuyenKhoan">Chuyển khoản</option>
    </select><br><br>

    <h3>Giỏ hàng</h3>
    <table border="1" cellpadding="6">
    <tr><th>Tên</th><th>SL</th><th>Giá</th><th>Thành tiền</th></tr>
    <% double tong = 0;
       for (Map<String,Object> item : gioHang) {
         SanPham sp = (SanPham)item.get("sanpham");
         int sl = (int)item.get("soluong");
         tong += sp.getGia()*sl;
    %>
      <tr>
        <td><%= sp.getTen() %></td>
        <td><%= sl %></td>
        <td><%= sp.getGia() %></td>
        <td><%= sp.getGia()*sl %></td>
      </tr>
    <% } %>
    </table>
    <h3>Tổng: <%= tong %> VNĐ</h3>
    <button type="submit">Xác nhận & đặt hàng</button>
</form>
</body>
</html>
