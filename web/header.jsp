<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="ordersUrl" value="/DonHangServlet">
    <c:param name="hanhDong" value="lichsu"/>
    <c:param name="tab" value="all"/>
</c:url>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    HttpSession ses = request.getSession(false);
    String tenDangNhap = null;
    if (ses != null) {
        Object obj = ses.getAttribute("tenDangNhap");
        if (obj instanceof String) {
            tenDangNhap = (String) obj;
        }
    }
%>
<style>
/* RESET KHÔNG CHO HEADER BỊ CO */
header, .header-main, .header-menu, .category-bar {
    width: 100% !important;
    max-width: 100% !important;
    margin: 0 !important;
    padding-left: 0 !important;
    padding-right: 0 !important;
}

/* Cho nội dung header căng ra full */
.header-main > div,
.header-menu > a,
.category-bar > a {
    max-width: none !important;
}

/* Tạo khung bên trong header để căn giữa đẹp, nhưng header vẫn full width */
.header-inner {
    width: 100%;
    max-width: 1400px;
    margin: auto;
    padding: 0 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}
</style>

<!-- ======================================
         HEADER TẦNG 1 (PASTEL)
====================================== -->
<header class="header-main">
    <div class="site-logo">
        <div class="logo-text">Văn Phòng Phẩm</div>
        <div class="logo-slogan">Học tập - Văn phòng - Tiện lợi mỗi ngày</div>
    </div>


    <div class="header-search">
        <input type="text" placeholder="Tìm kiếm sản phẩm..." class="search-box">
        <button class="search-btn">🔍</button>
    </div>

    <div class="header-right">
        <div class="hotline">📞 0968.715.858</div>

        <% if (tenDangNhap != null) { %>
        <div class="account-dropdown">
            <button class="account-btn">👤 <%= tenDangNhap %></button>
            <div class="account-menu">
                <a href="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=profile">Tài khoản của tôi</a>
                <a href="${ordersUrl}">Đơn hàng</a>
                <a href="${pageContext.request.contextPath}/DangXuatServlet">Đăng xuất</a>
            </div>
        </div>

        <% } else { %>
        <a href="dang_nhap.jsp" class="account">👤 Tài khoản</a>
        <% } %>

        <%
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
            int soLuongGH = (gioHang == null) ? 0 : gioHang.size();
        %>
        <a href="GioHangServlet" class="cart-icon">🛒</a>
    </div>
</header>

<!-- ======================================
         HEADER TẦNG 2 – MENU CHÍNH
====================================== -->
<nav class="header-menu">
    <a href="trang_chu.jsp">Trang chủ</a>
    <a href="SanPhamServlet">Sản phẩm</a>
    <a href="gioi_thieu.jsp">Giới thiệu</a>
    <a href="lien_he.jsp">Liên hệ</a>
</nav>

<!-- ======================================
         HEADER TẦNG 3 – DANH MỤC
====================================== -->
<nav class="category-bar">
    <a href="#"><span>🖊️</span> Bút viết</a>
    <a href="#"><span📑</span> Văn phòng phẩm</a>
    <a href="#"><span>✏️</span> Dụng cụ học tập</a>
    <a href="#"><span>🎨</span> Mỹ thuật</a>
    <a href="#"><span>📄</span> Giấy in</a>
    <a href="#"><span>🎁</span> Quà tặng</a>
</nav>

<!-- ======================================
                 CSS
====================================== -->
<style>
/* FONT */
body, * {
    font-family: "Segoe UI", sans-serif;
}

/* ================= HEADER TẦNG 1 ================= */
.header-main {
    width: 100%;
    background: #BEE3F8; /* Xanh pastel nhẹ */
    padding: 12px 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: sticky;
    top: 0;
    z-index: 999;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.logo-img {
    height: 60px;
}

.header-search {
    display: flex;
    flex: 1;
    margin: 0 50px;
}

.search-box {
    flex: 1;
    padding: 12px 20px;
    border-radius: 30px 0 0 30px;
    border: 1px solid #A0AEC0;
    background: #fff;
}

.search-btn {
    padding: 12px 25px;
    background: #63B3ED;
    border: none;
    border-radius: 0 30px 30px 0;
    cursor: pointer;
    font-size: 17px;
}

/* Right Side */
.header-right {
    display: flex;
    align-items: center;
    gap: 30px;
}

/* ================= HEADER TẦNG 2 – MENU ================= */
.header-menu {
    width: 100%;
    background: white;
    padding: 10px 0;
    display: flex;
    justify-content: center;
    gap: 40px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.07);
    position: sticky;
    top: 75px; /* dưới header 1 */
    z-index: 998;
}

.header-menu a {
    text-decoration: none;
    color: #2B6CB0;
    font-weight: 600;
    font-size: 17px;
    padding-bottom: 4px;
}

.header-menu a:hover {
    color: #2C5282;
    border-bottom: 3px solid #63B3ED;
}

/* ================= HEADER TẦNG 3 – CATEGORY ================= */
.category-bar {
    width: 100%;
    background: #EBF8FF;
    padding: 12px 0;
    display: flex;
    justify-content: center;
    gap: 35px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.category-bar a {
    text-decoration: none;
    color: #2A4365;
    font-size: 15px;
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 8px;
    border-radius: 8px;
}

.category-bar a:hover {
    background: #bee3f8;
}

/* ================= ACCOUNT DROPDOWN ================= */
.account-dropdown {
    position: relative;
}

.account-btn {
    background: transparent;
    border: none;
    font-size: 15px;
    cursor: pointer;
}

.account-menu {
    display: none;
    position: absolute;
    right: 0;
    top: 120%;
    background: white;
    border-radius: 10px;
    min-width: 200px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}

.account-dropdown:hover .account-menu {
    display: block;
}

.account-menu a {
    display: block;
    padding: 12px 15px;
    text-decoration: none;
    color: #2D3748;
}

.account-menu a:hover {
    background: #EDF2F7;
}

/* Giỏ hàng */
.cart-icon {
    font-size: 22px;
    color: #2D3748;
    text-decoration: none;
    padding: 8px;
    border-radius: 50%;
}

.cart-icon:hover {
    background: #cfe9ff;
}
/* -------------------------------
   LÀM TRANG TỰ FIT MỌI MÀN HÌNH
-------------------------------- */

/* Khung trang chung */
.container {
    width: 100%;
    max-width: 1400px;      /* Không bao giờ giãn quá to */
    margin: 0 auto;
    padding: 0 20px;        /* Fit 2 bên */
}

/* Header căn giữa nội dung */
.header-main,
.header-menu,
.category-bar {
    padding-left: max(20px, 5vw);
    padding-right: max(20px, 5vw);
}

/* Search box tự co */
.header-search {
    flex: 1;
}

/* Nếu màn nhỏ hơn laptop */
@media (max-width: 1200px) {
    .header-main {
        padding: 10px 20px;
    }
    .category-bar a {
        font-size: 14px;
    }
}

/* Tablet */
@media (max-width: 900px) {
    .header-search {
        margin: 0 20px;
    }
    .header-right {
        gap: 15px;
    }
    .header-menu {
        gap: 25px;
    }
}

/* Mobile */
@media (max-width: 600px) {
    .header-main {
        flex-direction: column;
        gap: 10px;
        padding: 15px;
        text-align: center;
    }
    .header-search {
        width: 100%;
        margin: 0;
    }
    .header-menu {
        gap: 15px;
        font-size: 14px;
        flex-wrap: wrap;
    }
    .category-bar {
        gap: 15px;
        flex-wrap: wrap;
        padding: 10px;
    }
}
/* ================================
   SUPER STICKY HEADER 3 TẦNG
================================ */

/* Tầng 1 */
.header-main {
    position: sticky;
    top: 0;
    z-index: 999;
}

/* Tầng 2 */
.header-menu {
    position: sticky;
    top: 72px; /* bằng đúng chiều cao tầng 1 */
    z-index: 998;
}

/* Tầng 3 */
.category-bar {
    position: sticky;
    top: 120px; /* = tầng 1 + tầng 2 */
    z-index: 997;
}

</style>

