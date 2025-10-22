<%-- 
    Document   : lich_su_don_hang
    Created on : Oct 11, 2025, 1:56:26 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.DonHang" %>
<%
    List<DonHang> ds = (List<DonHang>) request.getAttribute("dsDonHang");
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Lịch sử đơn hàng</title></head>
<body>
<h2>Lịch sử đơn hàng</h2>
<% if (ds == null || ds.isEmpty()) { %>
    <p>Chưa có đơn hàng</p>
<% } else { %>
    <ul>
    <% for (DonHang dh : ds) { %>
        <li>Đơn #<%= dh.getIdDonHang()%> - <%= dh.getTongTien() %> VNĐ - <%= dh.getNgayDat()%></li>
    <% } %>
    </ul>
<% } %>
</body>
</html>
