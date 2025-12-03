<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.NguoiDung" %>
<%
    NguoiDung shipper = (NguoiDung) session.getAttribute("shipper");
    if (shipper == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String trangThai = request.getParameter("trangthai");
%>

<!-- Header Shipper -->
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm" style="background: linear-gradient(135deg, #5563DE, #74ABE2);">
    <div class="container-fluid">
        <!-- Logo / Brand -->
        <a class="navbar-brand fw-bold fs-4" href="shipper_dashboard.jsp">ShipperDashboard</a>

        <!-- Toggle cho mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#shipperNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menu -->
        <div class="collapse navbar-collapse" id="shipperNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link <%= "dadat".equals(trangThai)?"active fw-bold":"" %>" href="shipper_dashboard.jsp?trangthai=dangGiao">
                        Đơn hàng đang giao
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "dagiao".equals(trangThai)?"active fw-bold":"" %>" href="shipper_dashboard.jsp?trangthai=dagiao">
                        Đơn hàng đã giao
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "hoantien".equals(trangThai)?"active fw-bold":"" %>" href="shipper_dashboard.jsp?trangthai=hoantien">
                        Đơn hàng hoàn hàng
                    </a>
                </li>
            </ul>

            <!-- Account dropdown -->
            <div class="dropdown">
                <button class="btn btn-outline-light dropdown-toggle" type="button" id="accountDropdown" data-bs-toggle="dropdown">
                    👤 <%= shipper.getHoTen() %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accountDropdown">
                   
                    <li><a class="dropdown-item" href="shipper_dashboard.jsp">Đơn hàng</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="LogoutServlet">Đăng xuất</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- Custom CSS -->
<style>
    .navbar-nav .nav-link {
        transition: all 0.3s ease;
    }
    .navbar-nav .nav-link:hover {
        color: #ffd700;
        text-shadow: 0 0 5px rgba(255, 215, 0, 0.7);
    }
    .navbar-nav .nav-link.active {
        color: #ffeb3b;
        border-bottom: 2px solid #ffeb3b;
    }
    .btn-outline-light:hover {
        background-color: rgba(255,255,255,0.2);
        color: #fff;
    }
</style>
