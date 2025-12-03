<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="jakarta.servlet.http.HttpServletRequest"%>

<%
    // Lấy tham số "trangthai" từ URL
    String trangthai = request.getParameter("trangthai");
    if (trangthai == null) trangthai = "dashboard"; // mặc định là Dashboard (tất cả đơn hàng)

    // Active class cho từng tab
    String activeDashboard = "dashboard".equals(trangthai) ? "active" : "";
    String activeDangGiao = "dadat".equals(trangthai) ? "active" : "";
    String activeDaGiao = "dagiao".equals(trangthai) ? "active" : "";
    String activeHoanKho = "hoankho".equals(trangthai) ? "active" : "";
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="ShipperDonHang">Shipper Dashboard</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarShipper" aria-controls="navbarShipper" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarShipper">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link <%= activeDashboard %>" href="ShipperDonHang">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= activeDangGiao %>" href="ShipperDonHang?trangthai=dadat">Đơn hàng đang giao</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= activeDaGiao %>" href="ShipperDonHang?trangthai=dagiao">Đơn hàng đã giao</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= activeHoanKho %>" href="ShipperDonHang?trangthai=hoankho">Đơn hàng hoàn hàng</a>
                </li>
            </ul>
            <span class="navbar-text text-light">
                Xin chào, Shipper!
            </span>
        </div>
    </div>
</nav>
