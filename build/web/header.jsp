<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.*"%>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession ses = request.getSession(false);
String tenDangNhap = null;
if (ses != null) {
    Object obj = ses.getAttribute("tenDangNhap");
    if (obj != null && obj instanceof String) {
        tenDangNhap = (String) obj;
    } else {
        ses.removeAttribute("tenDangNhap");
    }
}
%>
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

    <% if (tenDangNhap != null) { %>
      <div class="account-dropdown">
        <button class="account-btn" onclick="toggleAccountMenu()">
          <span class="account-icon">👤</span>
          <%= tenDangNhap %>
        </button>
        <div class="account-menu" id="accountMenu">
          <a href="thong_tin_ca_nhan.jsp">Tài khoản của tôi </a>
          <a href="don_hang.jsp">Đơn hàng</a>
          <a href="nguoidung?hanhDong=dang_xuat">Đăng xuất</a>
        </div>
      </div>
    <% } else { %>
      <a href="dang_nhap.jsp" class="account">👤 Tài khoản</a>
    <% } %>

    <%
      List<Map<String,Object>> gioHang = (List<Map<String,Object>>) session.getAttribute("gioHang");
      int soLuongGH = (gioHang == null) ? 0 : gioHang.size();
    %>
    <a href="GioHangServlet">🛒 Giỏ hàng (<%= soLuongGH %>)</a>
  </div>
</header>

<nav class="top-menu">
  <a href="trang_chu.jsp">Trang chủ</a>
  <a href="SanPhamServlet">Sản phẩm</a>
  <a href="gioi_thieu.jsp">Giới thiệu</a>
  <a href="lien_he.jsp">Liên hệ</a>
</nav>
