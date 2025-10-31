<%-- 
    Document   : thanh_toan_thanh_cong
    Created on : Oct 21, 2025, 7:04:30 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>

<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");
    // Lấy danh sách đơn hàng từ session (hoặc DB trong bước sau)
    List<Map<String, Object>> donHangList = (List<Map<String, Object>>) session.getAttribute("lichSuDonHang");

    // Nếu đây là đơn hàng mới, thêm vào danh sách
    Map<String, Object> donHangMoi = (Map<String, Object>) request.getAttribute("donHangMoi");
    if (donHangMoi != null) {
        if (donHangList == null) donHangList = new ArrayList<>();
        donHangList.add(donHangMoi);
        session.setAttribute("lichSuDonHang", donHangList);
    }
%>

<html>
<head>
    <title>Thanh toán thành công</title>
    <style>
        body {
          background: #f5f6fa;
          font-family: Arial, sans-serif;
          padding: 40px;
        }
        .container {
          max-width: 700px; margin:auto;
          background:#fff; padding:30px; border-radius:10px;
          box-shadow:0 3px 8px rgba(0,0,0,0.1);
          text-align:center;
        }
        h2 { color:#28a745; margin-bottom:20px; }
        .btn {
          background:#5563DE; color:white;
          border:none; padding:10px 20px; margin:10px;
          border-radius:6px; cursor:pointer;
          font-size:15px; text-decoration:none;
          display:inline-block;
        }
        .btn:hover { background:#3b4cc0; }
        .order {
          border-bottom:1px solid #ddd; text-align:left; padding:10px 0;
        }
        .order:last-child { border-bottom:none; }
        .summary {
          background:#f8f9fa; border-radius:8px;
          padding:15px; margin-top:10px; text-align:left;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>✅ Thanh toán thành công!</h2>
    <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đã được ghi nhận.</p>

    <div style="margin-top:25px;">
        <a href="index.jsp" class="btn">🏠 Quay lại trang chủ</a>
        <a href="don_hang.jsp" class="btn">🧾 Xem đơn hàng đã đặt</a>
    </div>

    <% if (donHangMoi != null) { %>
      <div class="summary">
        <h3>Chi tiết đơn hàng mới nhất:</h3>
        <p><b>Mã đơn hàng:</b> <%= donHangMoi.get("id_donhang") %></p>
        <p><b>Địa chỉ:</b> <%= donHangMoi.get("diaChi") %></p>
        <p><b>Số điện thoại:</b> <%= donHangMoi.get("soDienThoai") %></p>
        <p><b>Phương thức thanh toán:</b> <%= donHangMoi.get("phuongThuc") %></p>
        <p><b>Tổng tiền:</b> <%= df.format(donHangMoi.get("tongTien")) %></p>
        <p><b>Ngày đặt:</b> <%= donHangMoi.get("ngayDat") %></p>
      </div>
    <% } %>
</div>
</body>
</html>
