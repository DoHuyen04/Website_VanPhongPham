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
// --- PHÂN TRANG ---
    int pageSize = 12; // số sản phẩm mỗi trang

    // Sản phẩm bán chạy
    List<SanPham> dsBanChay = (List<SanPham>) request.getAttribute("spBanChay");
    int pageBanChay = 1;
    String pageBC = request.getParameter("pageBanChay");
    if (pageBC != null) {
        try {
            pageBanChay = Integer.parseInt(pageBC);
        } catch (Exception ignored) {
        }
    }
    int totalBC = dsBanChay.size();
    int totalPagesBC = (int) Math.ceil((double) totalBC / pageSize);
    int startBC = (pageBanChay - 1) * pageSize;
    int endBC = Math.min(startBC + pageSize, totalBC);
    List<SanPham> sanPhamBanChayTrang = dsBanChay.subList(startBC, endBC);

    // Sản phẩm khuyến mãi
    List<SanPham> dsKhuyenMai = (List<SanPham>) request.getAttribute("spKhuyenMai");
    int pageKhuyenMai = 1;
    String pageKM = request.getParameter("pageKhuyenMai");
    if (pageKM != null) {
        try {
            pageKhuyenMai = Integer.parseInt(pageKM);
        } catch (Exception ignored) {
        }
    }
    int totalKM = dsKhuyenMai.size();
    int totalPagesKM = (int) Math.ceil((double) totalKM / pageSize);
    int startKM = (pageKhuyenMai - 1) * pageSize;
    int endKM = Math.min(startKM + pageSize, totalKM);
    List<SanPham> sanPhamKhuyenMaiTrang = dsKhuyenMai.subList(startKM, endKM);
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
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }
            .right-content {
                flex: 1;
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
                    flex-direction: column;
                    gap: 0;
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
            /* ===== Nút Xem Chi Tiết ===== */
            .btn-xemchitiet {
                display: inline-block;
                background: linear-gradient(135deg, #42a5f5, #1e88e5); /* xanh nhẹ */
                color: white;
                border: none;
                padding: 7px 14px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                margin-top: 6px;
                margin-right: auto;
                margin-left: 10px; /* căn sang trái nhẹ cho cân */
                box-shadow: 0 2px 6px rgba(30, 136, 229, 0.4);
                transition: all 0.3s ease;
            }

            .btn-xemchitiet:hover {
                background: linear-gradient(135deg, #ff9800, #ff5722); /* chuyển sang cam khi hover */
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(255, 87, 34, 0.4);
            }
            .pagination-container {
                text-align: center;
                margin-top: 20px;
            }

            .pagination {
                list-style: none;
                padding: 0;
                display: inline-flex;
                gap: 5px;
            }

            .pagination li {
                display: inline-block;
            }

            .pagination li a {
                display: block;
                padding: 8px 12px;
                text-decoration: none;
                color: #007bff;
                background-color: #f0f0f0;
                border-radius: 6px;
                border: 1px solid transparent;
                transition: all 0.3s ease;
            }

            .pagination li a:hover {
                background-color: #007bff;
                color: #fff;
                transform: scale(1.05);
            }

            .pagination li.active a {
                background-color: #1e88e5;
                color: #fff;
                font-weight: 600;
                border: 1px solid #1565c0;
            }

            .pagination li.disabled a {
                pointer-events: none;
                color: #aaa;
                background-color: #e0e0e0;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <!-- Main -->
        <main class="container main-grid">

            <!-- Left Menu -->
            <aside class="left-menu">
                <form action="SanPhamServlet" method="get">
                    <h4>Danh mục sản phẩm</h4>
                    <ul>
                        <li><label><input type="checkbox" name="danhmuc" value="kynangsong"> Kỹ năng sống</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="sachtiengviet"> Sách tiếng Việt</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="sachgiaokhoa"> Sách giáo khoa - tham khảo</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="ngoai_ngu"> Sách ngoại ngữ</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="dungcu_hocsinh"> Dụng cụ học sinh</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="vanphongpham"> Văn phòng phẩm</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="quatang"> Quà tặng</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="dochoi"> Đồ chơi</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="tramhuong"> Sản phẩm trầm hương</label></li>
                        <li><label><input type="checkbox" name="danhmuc" value="vanhocnuocngoai"> Văn học nước ngoài</label></li>
                    </ul>

                    <h4>Mức giá</h4>
                    <ul>
                        <li><label><input type="checkbox" name="gia" value="duoi100"> Dưới 100.000đ</label></li>
                        <li><label><input type="checkbox" name="gia" value="100-200"> 100.000đ - 200.000đ</label></li>
                        <li><label><input type="checkbox" name="gia" value="200-300"> 200.000đ - 300.000đ</label></li>
                        <li><label><input type="checkbox" name="gia" value="300-500"> 300.000đ - 500.000đ</label></li>
                        <li><label><input type="checkbox" name="gia" value="500-1000"> 500.000đ - 1.000.000đ</label></li>
                        <li><label><input type="checkbox" name="gia" value="tren1000"> Trên 1.000.000đ</label></li>
                    </ul>

                    <h4>Sản phẩm</h4>
                    <ul>
                        <li><label><input type="checkbox" name="loai" value="banchay"> Bán chạy</label></li>
                        <li><label><input type="checkbox" name="loai" value="khuyenmai"> Khuyến mại - Giảm giá</label></li>
                    </ul>

                    <button type="submit" class="btn-loc">Lọc sản phẩm</button>
                </form>
            </aside>

            <!-- Cột bên phải: khu vực sản phẩm -->
            <section class="right-content">
                <jsp:include page="thanh_timkiem.jsp" />

                <!-- KHU VỰC SẢN PHẨM BÁN CHẠY -->
                <section class="best-seller-section">
                    <h2 class="title-banchay">🔥 Sản phẩm bán chạy</h2>
                    <div class="product-grid">
                        <%
                            if (sanPhamBanChayTrang != null && !sanPhamBanChayTrang.isEmpty()) {
                                for (SanPham sp : sanPhamBanChayTrang) {
                        %>
                        <div class="product-card">
                            <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                            <h3 class="product-name"><%= sp.getTen()%></h3>
                            <p class="product-price"><%= sp.getGia()%> đ</p>
                            <form action="GioHangServlet" method="post">

                                <input type="hidden" name="idSanPham" value="<%= sp.getId_sanpham()%>">
                                <button class="add-cart" title="Thêm vào giỏ hàng">+</button>
                            </form>
                            <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham()%>" class="btn-xemchitiet">
                                Detail
                            </a>
                        </div>

                        <%
                            }
                        } else {
                        %>
                        <p class="nos-product">Không có sản phẩm bán chạy nào.</p>
                        <%
                            }
                        %>
                    </div>
                    <div class="pagination-container">
                        <ul class="pagination">
                            <!-- Nút Previous -->
                            <li class="<%= pageBanChay == 1 ? "disabled" : ""%>">
                                <a href="TrangChuServlet?pageBanChay=<%= pageBanChay - 1%>&pageKhuyenMai=<%= pageKhuyenMai%>">«</a>
                            </li>

                            <!-- Danh sách trang -->
                            <%
                                for (int i = 1; i <= totalPagesBC; i++) {
                                    String cls = (i == pageBanChay) ? "active" : "";
                            %>
                            <li class="<%= cls%>">
                                <a href="TrangChuServlet?pageBanChay=<%= i%>&pageKhuyenMai=<%= pageKhuyenMai%>"><%= i%></a>
                            </li>
                            <% }%>

                            <!-- Nút Next -->
                            <li class="<%= pageBanChay == totalPagesBC ? "disabled" : ""%>">
                                <a href="TrangChuServlet?pageBanChay=<%= pageBanChay + 1%>&pageKhuyenMai=<%= pageKhuyenMai%>">»</a>
                            </li>
                        </ul>
                    </div>

                </section>

                <!-- KHU VỰC SẢN PHẨM KHUYẾN MẠI -->
                <section class="sale-section">
                    <h2 class="title-km">🎁 Sản phẩm khuyến mại</h2>
                    <div class="product-grid">
                        <%
                            if (sanPhamKhuyenMaiTrang != null && !sanPhamKhuyenMaiTrang.isEmpty()) {
                                for (SanPham sp : sanPhamKhuyenMaiTrang) {
                        %>
                        <div class="product-card">
                            <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                            <h3 class="product-name"><%= sp.getTen()%></h3>
                            <p class="product-price"><%= sp.getGia()%> đ</p>
                            <form action="GioHangServlet" method="post">

                                <input type="hidden" name="idSanPham" value="<%= sp.getId_sanpham()%>">
                                <button class="add-cart" title="Thêm vào giỏ hàng">+</button>
                            </form>
                            <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham()%>" class="btn-xemchitiet">
                                Detail
                            </a>
                        </div>

                        <%
                            }
                        } else {
                        %>
                        <p class="no-product">Không có sản phẩm khuyến mại nào.</p>
                        <%
                            }
                        %>
                    </div>

                    <div class="pagination-container">
                        <ul class="pagination">
                            <!-- Nút Previous -->
                            <li class="<%= pageKhuyenMai == 1 ? "disabled" : ""%>">
                                <a href="TrangChuServlet?pageKhuyenMai=<%= pageKhuyenMai - 1%>&pageBanChay=<%= pageBanChay%>">«</a>
                            </li>

                            <!-- Danh sách trang -->
                            <%
                                for (int i = 1; i <= totalPagesKM; i++) {
                                    String cls = (i == pageKhuyenMai) ? "active" : "";
                            %>
                            <li class="<%= cls%>">
                                <a href="TrangChuServlet?pageKhuyenMai=<%= i%>&pageBanChay=<%= pageBanChay%>"><%= i%></a>
                            </li>
                            <% }%>

                            <!-- Nút Next -->
                            <li class="<%= pageKhuyenMai == totalPagesKM ? "disabled" : ""%>">
                                <a href="TrangChuServlet?pageKhuyenMai=<%= pageKhuyenMai + 1%>&pageBanChay=<%= pageBanChay%>">»</a>
                            </li>
                        </ul>
                    </div>

                </section>
            </section>
        </main>

        <jsp:include page="footer.jsp" />
        <script src="js/script.js"></script>
    </body>
</html>
