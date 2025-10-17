<%-- 
    Document   : lien_he
    Created on : Oct 11, 2025, 1:56:35 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Liên hệ</title></head>
<body>
<h2>Liên hệ</h2>
<form action="lienhe" method="post">
    <label>Họ tên</label><br><input name="hoTen" required><br>
    <label>Email</label><br><input name="email" required><br>
    <label>SDT</label><br><input name="soDienThoai"><br>
    <label>Nội dung</label><br><textarea name="noiDung"></textarea><br>
    <button type="submit">Gửi</button>
</form>
<p style="color:green"><%= request.getAttribute("thongbao") != null ? request.getAttribute("thongbao") : "" %></p>
</body>
</html>
