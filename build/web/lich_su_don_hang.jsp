<%-- 
    Document   : lich_su_don_hang
    Created on : Oct 11, 2025, 1:56:26 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat, model.DonHang, model.DonHangChiTiet" %>

<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");
    List<DonHang> lichSu = (List<DonHang>) request.getAttribute("dsDonHang");
%>

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
          max-width: 850px;
          margin: auto;
          background: #fff;
          padding: 30px;
          border-radius: 10px;
          box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; color: #5563DE; margin-bottom: 20px; }
        .order {
          border-bottom: 1px solid #ddd;
          padding: 15px 0;
        }
        .order:last-child { border-bottom: none; }
        .order h3 {
          color: #333;
          margin-bottom: 10px;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 10px;
        }
        th, td {
          border: 1px solid #ccc;
          padding: 8px;
          text-align: center;
        }
        th {
          background: #f0f2ff;
          color: #333;
        }
        .back-btn {
          display: block;
          text-align: center;
          margin-top: 20px;
        }
        .back-btn a {
          background: #5563DE;
          color: white;
          padding: 10px 20px;
          border-radius: 6px;
          text-decoration: none;
        }
        .empty {
          text-align: center;
          color: #888;
          font-style: italic;
        }
    </style>
</head>
<body>
<div class="container">
  <h2>📜 Lịch sử đơn hàng</h2>

  <%
    if (lichSu != null && !lichSu.isEmpty()) {
        for (DonHang don : lichSu) {
  %>
    <div class="order">
      <h3>🛒 Đơn hàng #<%= don.getIdDonHang() %></h3>
      <p><b>Địa chỉ:</b> <%= don.getDiaChi() %></p>
      <p><b>Số điện thoại:</b> <%= don.getSoDienThoai() %></p>
      <p><b>Phương thức thanh toán:</b> <%= don.getPhuongThuc() %></p>
      <p><b>Ngày đặt:</b> <%= don.getNgayDat() %></p>

      <table>
        <tr>
          <th>Mã sản phẩm</th>
          <th>Số lượng</th>
          <th>Giá</th>
        </tr>
        <%
          List<DonHangChiTiet> chiTiet = don.getChiTiet();
          for (DonHangChiTiet ct : chiTiet) {
        %>
        <tr>
          <td><%= ct.getId_sanpham() %></td>
          <td><%= ct.getSoLuong() %></td>
          <td><%= df.format(ct.getGia()) %></td>
        </tr>
        <% } %>
        <tr>
          <td colspan="2"><b>Tổng tiền</b></td>
          <td><b><%= df.format(don.getTongTien()) %></b></td>
        </tr>
      </table>
    </div>
  <%  
        }
    } else { 
  %>
    <p class="empty">Chưa có đơn hàng nào.</p>
  <% } %>

  <div class="back-btn">
    <a href="index.jsp">⬅ Quay lại trang chủ</a>
  </div>
</div>
</body>
</html>
