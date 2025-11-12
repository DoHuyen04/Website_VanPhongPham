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

        <% if (tenDangNhap != null) {%>
        <div class="account-dropdown">
            <button class="account-btn" onclick="toggleAccountMenu()">
                <span class="account-icon">👤</span>
                <%= tenDangNhap%>
            </button>
            <div class="account-menu" id="accountMenu">
                <a href="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=profile">
                    Tài khoản của tôi
                </a>

                <a href="${ordersUrl}">Đơn hàng</a>

                <a href="${pageContext.request.contextPath}/DangXuatServlet">
                    Đăng xuất
                </a>
            </div>

        </div>
        <% } else { %>
        <a href="dang_nhap.jsp" class="account">👤 Tài khoản</a>
        <% } %>

        <%
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
            int soLuongGH = (gioHang == null) ? 0 : gioHang.size();
        %>
        <a href="GioHangServlet">🛒 Giỏ hàng (<%= soLuongGH%>)</a>
    </div>
</header>

<nav class="top-menu">
    <a href="trang_chu.jsp">Trang chủ</a>
    <a href="SanPhamServlet">Sản phẩm</a>
    <a href="gioi_thieu.jsp">Giới thiệu</a>
    <a href="lien_he.jsp">Liên hệ</a>
</nav>
<style>
    /* Khung dropdown tài khoản */
    .account-dropdown{
        position:relative;
        display:inline-block;
    }
    .account-btn{
        background:transparent;
        border:0;
        cursor:pointer;
        padding:.25rem .5rem;
    }

    /* Hộp menu */
    .account-menu{
        position:absolute;
        right:0;
        top:120%;
        min-width:210px;
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:6px;
        box-shadow:0 10px 25px rgba(0,0,0,.12);
        display:none;
        z-index:1000;
    }
    .account-menu a{
        display:block;
        padding:.7rem 1rem;
        text-decoration:none;
        color:#111827;
        font-weight:600;
    }
    .account-menu a:hover{
        background:#f3f4f6;
    }

    /* Mũi nhọn nhỏ như hình */
    .account-menu::before{
        content:"";
        position:absolute;
        top:-8px;
        right:20px;
        width:14px;
        height:14px;
        background:#fff;
        border-left:1px solid #e5e7eb;
        border-top:1px solid #e5e7eb;
        transform:rotate(45deg);
    }

    /* Hiện menu khi rê chuột */
    .account-dropdown:hover .account-menu{
        display:block;
    }
</style>
<script>
    (function () {
        // Dùng cho nút onclick="toggleAccountMenu()" đã có trong HTML (hữu ích trên mobile)
        window.toggleAccountMenu = function () {
            var menu = document.getElementById('accountMenu');
            if (!menu)
                return;
            var open = menu.style.display === 'block';
            menu.style.display = open ? 'none' : 'block';
        };

        // Click ra ngoài để đóng (mobile/desktop đều có lợi)
        document.addEventListener('click', function (e) {
            var wrapper = document.querySelector('.account-dropdown');
            var menu = document.getElementById('accountMenu');
            if (!wrapper || !menu)
                return;
            if (!wrapper.contains(e.target)) {
                menu.style.display = 'none';
            }
        });
    })();
</script>
<style>
    /* Giữ mở khi rê vào menu hoặc đang focus (tab) */
    .account-dropdown:hover .account-menu,
    .account-dropdown:focus-within .account-menu,
    .account-menu:hover{
        display:block;
    }

    /* Xóa gap giữa nút và menu (đặt thấp hơn 1-2px) */
    .account-menu{
        top: calc(100% + 2px) !important; /* trước là 120% nên có khe hở */
    }

    /* Mũi nhọn to hơn để “bắc cầu” hover */
    .account-menu::before{
        top:-9px;
        right:22px;
        width:18px;
        height:18px;
    }
</style>

