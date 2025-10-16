<%-- 
    Document   : header
    Created on : Oct 14, 2025, 9:59:18 AM
    Author     : asus
--%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" %>
   <%-- ✅ Lấy tên đăng nhập từ session --%>
  <%
      HttpSession ses = request.getSession(false);
      String tenDangNhap = null;
      if (ses != null) {
          tenDangNhap = (String) ses.getAttribute("tenDangNhap");
      }
  %>

  <!-- 🟥 Banner -->
  <header class="banner">
    <div class="banner-left">
      <img src="hinh_anh/logo.png" alt="Logo" class="logo-img">
    </div>
    <div class="banner-center">
      <input type="text" placeholder="Tìm theo thương hiệu..." class="search-box">
      <button class="search-btn">🔍</button>
    </div>
    <div class="banner-right">
      <div class="hotline">📞 0968.715.858</div>
<!-- 👤 Hiển thị tài khoản -->
            <%
                if (tenDangNhap != null) {
            %>
                <div class="account-dropdown">
                    <button class="account-btn" onclick="toggleAccountMenu()">
                        <span class="account-icon">👤</span>
                        <%= tenDangNhap %>
                    </button>
                    <div class="account-menu" id="accountMenu">
                        <a href="thong_tin_ca_nhan.jsp">Thông tin cá nhân</a>
                        <a href="don_hang.jsp">Đơn hàng đã mua</a>
                        <a href="nguoidung?hanhDong=dang_xuat">Đăng xuất</a>
                    </div>
                </div>
            <%
                } else {
            %>
                <a href="dang_nhap.jsp" class="account">👤 Tài khoản</a>
            <%
                }
            %>

      <%
    List<Map<String,Object>> gioHang = (List<Map<String,Object>>) session.getAttribute("gioHang");
    int soLuongGH = (gioHang == null) ? 0 : gioHang.size();
%>
<a href="GioHangServlet">🛒 Giỏ hàng (<%= soLuongGH %>)</a>

    </div>
  </header>
