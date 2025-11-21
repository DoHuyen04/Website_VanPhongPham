<%@page import="model.SanPham"%>
<%@page import="java.util.List"%>
<%
    // Nếu chưa có dữ liệu từ TrangChuServlet thì tự động forward
    if (request.getAttribute("spBanChay") == null && request.getAttribute("spKhuyenMai") == null) {
        RequestDispatcher rd = request.getRequestDispatcher("TrangChuServlet");
        rd.forward(request, response);
        return;
    }
%>
<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
<div style="background-color:#f0f8ff; color:#333; padding:10px; margin:10px 0; border-left:5px solid #007bff;">
    <%= message%>
</div>
<%
        session.removeAttribute("message"); // Xóa để không lặp lại
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ page contentType="text/html; charset=UTF-8" %>
        <title>Trang chủ - Cửa hàng Văn phòng phẩm</title>
        <link rel="stylesheet" href="css/kieu.css">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <style>
            /* --- Responsive layout cho phần sản phẩm --- */
            .main-grid {
                display: grid;
                grid-template-columns: 250px 1fr;
                gap: 20px;
                align-items: start;
            }
            .left-menu {
                position: sticky;
                top: 240px; /* Cố định menu từ trên đầu container */
                align-self: flex-start; /* Căn menu cùng top với nội dung */
                background: #fff;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e5e7eb;
            }

            @media (max-width: 900px) {
                .main-grid {
                    grid-template-columns: 1fr;
                }

                .left-menu {
                    position: relative;
                    top: auto;
                    margin-bottom: 20px;
                }
            }

            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 20px;
                margin-top: 15px;
            }

            .product-card {
                background: #fff;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 10px;
                text-align: center;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .product-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .product-card img {
                width: 100%;
                height: 160px;
                object-fit: contain;
                border-radius: 8px;
            }

            .product-name {
                font-size: 15px;
                font-weight: 600;
                color: #333;
                margin: 8px 0 4px;
            }

            .product-price {
                color: #d9534f;
                font-weight: bold;
            }
            .best-seller-section, .sale-section {
                margin-bottom: 40px;
            }

            .title-banchay, .title-km {
                font-size: 20px;
                color: #222;
                margin-bottom: 10px;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <!-- Main -->
        <main class="container main-grid">

            <!-- Left Menu -->
            <jsp:include page="left_menu.jsp" />

            <!-- Cột bên phải: khu vực sản phẩm -->
            <section class="right-content">
                <jsp:include page="thanh_timkiem.jsp" />

                <!-- KHU VỰC SẢN PHẨM BÁN CHẠY -->
                <section class="best-seller-section">
                    <h2 class="title-banchay">🔥 Sản phẩm bán chạy</h2>
                    <div class="product-grid">
                        <%
                            List<SanPham> dsBanChay = (List<SanPham>) request.getAttribute("spBanChay");
                            if (dsBanChay != null && !dsBanChay.isEmpty()) {
                                for (SanPham sp : dsBanChay) {
                        %>
                        <div class="product-card">
                            <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                            <h3 class="product-name"><%= sp.getTen()%></h3>
                            <p class="product-price"><%= sp.getGia()%> đ</p>
                        </div>
                        <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham()%>" class="btn-xemchitiet">
                            Detail
                        </a>
                        <%
                            }
                        } else {
                        %>
                        <p class="nos-product">Không có sản phẩm bán chạy nào.</p>
                        <%
                            }
                        %>
                    </div>
                </section>

                <!-- KHU VỰC SẢN PHẨM KHUYẾN MẠI -->
                <section class="sale-section">
                    <h2 class="title-km">🎁 Sản phẩm khuyến mại</h2>
                    <div class="product-grid">
                        <%
                            List<SanPham> dsKhuyenMai = (List<SanPham>) request.getAttribute("spKhuyenMai");
                            if (dsKhuyenMai != null && !dsKhuyenMai.isEmpty()) {
                                for (SanPham sp : dsKhuyenMai) {
                        %>
                        <div class="product-card">
                            <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                            <h3 class="product-name"><%= sp.getTen()%></h3>
                            <p class="product-price"><%= sp.getGia()%> đ</p>
                        </div>
                        <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham()%>" class="btn-xemchitiet">
                            Detail
                        </a>

                        <%
                            }
                        } else {
                        %>
                        <p class="no-product">Không có sản phẩm khuyến mại nào.</p>
                        <%
                            }
                        %>
                    </div>
                </section>
            </section>
        </main>

        <jsp:include page="footer.jsp" />
        <script src="js/script.js"></script>
    </body>
</html>
