<%-- 
    Document   : dang_nhap
    Created on : Oct 11, 2025, 1:55:50 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Đăng nhập</title></head>
<body>
<h2>Đăng nhập</h2>
<form action="nguoidung" method="post">
    <input type="hidden" name="hanhDong" value="dangnhap">
    <label>Tên đăng nhập</label><br><input name="tenDangNhap"><br>
    <label>Mật khẩu</label><br><input type="password" name="matKhau"><br>
    <button type="submit">Đăng nhập</button>
</form>
<p style="color:red"><%= request.getAttribute("loi") != null ? request.getAttribute("loi") : "" %></p>
<a href="dang_ky.jsp">Đăng ký</a>
</body>
</html>
