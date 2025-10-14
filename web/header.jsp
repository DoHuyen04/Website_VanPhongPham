<%-- 
    Document   : header
    Created on : Oct 14, 2025, 9:59:18 AM
    Author     : asus
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<div class="banner">
  <div class="container banner-inner">
    <div class="logo">
      <a href="trang_chu.jsp"><img src="hinh_anh/logo.png" alt="logo" class="logo-img"></a>
      <div class="slogan">Văn phòng phẩm — Chất lượng & Giá tốt mỗi ngày</div>
    </div>
    <div class="banner-ad">
      <img src="hinh_anh/banner.jpg" alt="banner" class="banner-img">
    </div>
  </div>
</div>

<nav class="top-menu">
  <div class="container top-menu-inner">
    <div class="left">
      <a class="menu-item" href="trang_chu.jsp">Trang chủ</a>
      <a class="menu-item" href="san_pham.jsp">Sản phẩm</a>
      <a class="menu-item" href="gioi_thieu.jsp">Giới thiệu</a>
      <a class="menu-item" href="lien_he.jsp">Liên hệ</a>
    </div>
    <div class="right">
      <form class="search-form" action="SanPhamServlet" method="get">
        <input name="tuKhoa" type="search" placeholder="Tìm sản phẩm..." />
        <button type="submit">Tìm</button>
      </form>
      <a class="menu-item" href="dang_nhap.jsp">Đăng nhập</a>
      <a class="menu-item" href="gio_hang.jsp">Giỏ hàng (<span id="soLuongGio">0</span>)</a>
    </div>
  </div>
</nav>
