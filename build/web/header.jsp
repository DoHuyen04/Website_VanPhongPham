<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
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
        <% if (tenDangNhap != null) { %>
        <div class="account-dropdown">
            <button class="account-btn" onclick="toggleAccountMenu()">
                👤 <%= tenDangNhap %>
            </button>
            <div class="account-menu" id="accountMenu">
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
        <a href="GioHangServlet" class="cart">🛒(<%= soLuongGH %>)</a>
    </div>
</header>

<nav class="top-menu">
    <a href="trang_chu.jsp">Trang chủ</a>
    <a href="SanPhamServlet">Sản phẩm</a>
    <a href="gioi_thieu.jsp">Giới thiệu</a>
    <a href="lien_he.jsp">Liên hệ</a>
</nav>

<style>
/* ================= HEADER ================= */
body { margin:0; padding:0; }

.banner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    background-color: #3498db;
    height: 80px;
}

.banner-left .logo-img { height: 60px; }

.banner-center {
    display: flex;
    align-items: center;
    width: 450px;
    background: #fff;
    border-radius: 30px;
    overflow: hidden;
}

.search-box {
    flex: 1;
    padding: 10px 15px;
    border: none;
    outline: none;
    font-size: 15px;
}

.search-btn {
    border: none;
    padding: 10px 20px;
    background: #fff9c4;
    color: #111;
    cursor: pointer;
    font-size: 16px;
}

.banner-right {
    display: flex;
    align-items: center;
    gap: 12px;
}

/* ================= NÚT TÀI KHOẢN & GIỎ HÀNG ================= */
.account, .account-btn, .cart {
    padding: 8px 14px !important;
    border-radius: 8px !important;
    font-weight: bold !important;
    text-decoration: none !important;
    background-color: #fff9c4 !important;
    color: #111 !important;
    cursor: pointer !important;
    border: none !important;
}


.account:hover, .account-btn:hover, .cart:hover {
    background-color: #fff176;
    color: #111;
}

/* ================= DROPDOWN ================= */
.account-dropdown { position: relative; }
.account-menu {
    position: absolute;
    right: 0;
    top: calc(100% + 2px);
    min-width: 200px;
    background: #fff;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
    box-shadow: 0 5px 15px rgba(0,0,0,0.15);
    display: none;
    z-index: 1000;
}

.account-dropdown:hover .account-menu,
.account-dropdown:focus-within .account-menu,
.account-menu:hover { display: block; }

.account-menu a {
    display: block;
    padding: 12px;
    color: #111;
    font-weight: 600;
    text-decoration: none;
}

.account-menu a:hover { background-color: #f3f4f6; }

.account-menu::before {
    content:"";
    position: absolute;
    top: -9px;
    right: 22px;
    width: 18px;
    height: 18px;
    background: #fff;
    border-left:1px solid #e5e7eb;
    border-top:1px solid #e5e7eb;
    transform: rotate(45deg);
}

/* ================= MENU CHÍNH ================= */
.top-menu {
    display: flex;
    justify-content: center;
    gap: 40px;
    background-color: #3498db;
    padding: 0;
}

.top-menu a {
    padding: 12px 18px;
    color: #fff;
    text-decoration: none;
    font-weight: 600;
}

.top-menu a:hover { background-color: #1e88e5; }

/* ================= RESPONSIVE ================= */
@media (max-width: 720px) {
    .banner { flex-direction: column; gap: 8px; height:auto; padding: 10px 15px; }
    .banner-center { width: 95%; }
    .top-menu { flex-wrap: wrap; gap: 10px; }
}
</style>

<script>
(function () {
    window.toggleAccountMenu = function () {
        var menu = document.getElementById('accountMenu');
        if (!menu) return;
        menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
    };

    document.addEventListener('click', function (e) {
        var wrapper = document.querySelector('.account-dropdown');
        var menu = document.getElementById('accountMenu');
        if (!wrapper || !menu) return;
        if (!wrapper.contains(e.target)) menu.style.display = 'none';
    });
})();
</script>
