<%-- 
    Document   : chi_tiet_san_pham
    Created on : Oct 11, 2025, 1:55:25 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="dao.SanPhamDAO" %>
<%@ page import="model.SanPham" %>
<%
    String idStr = request.getParameter("id");
    SanPham sp = null;
    if (idStr != null) {
        int id = Integer.parseInt(idStr);
        SanPhamDAO dao = new SanPhamDAO();
        sp = dao.layTheoId(id);
    }
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Chi tiết</title><link rel="stylesheet" href="css/kieu.css"></head>
<body>
<% if (sp != null) { %>
    <h2><%= sp.getTen() %></h2>
    <img src="hinh_anh/<%= sp.getHinhAnh() %>" alt="" style="max-width:200px"/>
    <p>Giá: <%= sp.getGia() %> VNĐ</p>
    <p><%= sp.getMoTa() %></p>
    <a href="giohang?hanhDong=them&id=<%= sp.getId_sanpham()%>">Thêm vào giỏ</a>
<% } else { %>
    <p>Không tìm thấy sản phẩm</p>
<% } %>
</body>
</html>
