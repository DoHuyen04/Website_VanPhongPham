<%-- 
    Document   : thanh_toan_thanh_cong
    Created on : Oct 21, 2025, 7:04:30 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>Lịch sử đơn hàng</title>
<style>
body {
  background: #f5f6fa;
  font-family: Arial, sans-serif;
  padding: 40px;
}
.container {
  max-width: 700px; margin:auto;
  background:#fff; padding:20px; border-radius:10px;
  box-shadow:0 3px 8px rgba(0,0,0,0.1);
}
h2 { text-align:center; color:#5563DE; }
.order {
  border-bottom:1px solid #ddd; padding:10px 0;
}
.order:last-child { border-bottom:none; }
</style>
</head>
<body>
<div class="container">
  <h2>📜 Lịch sử đơn hàng</h2>
  <%
    List<String> lichSu = (List<String>) session.getAttribute("lichSuDonHang");
    if (lichSu != null && !lichSu.isEmpty()) {
        for (String don : lichSu) {
  %>
    <div class="order"><%= don %></div>
  <% }} else { %>
    <p>Chưa có đơn hàng nào.</p>
  <% } %>
</div>
</body>
</html>
