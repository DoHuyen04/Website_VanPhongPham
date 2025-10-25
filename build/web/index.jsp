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

      @media (max-width: 900px) {
          .main-grid {
              grid-template-columns: 1fr;
          }
          .left-menu {
              order: 2;
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
                    List<SanPham> dsBanChay = (List<SanPham>) request.getAttribute("spBanChay");
                    if (dsBanChay != null && !dsBanChay.isEmpty()) {
                        for (SanPham sp : dsBanChay) {
                %>
                <div class="product-card">
                    <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                    <h3 class="product-name"><%= sp.getTen() %></h3>
                    <p class="product-price"><%= sp.getGia() %> đ</p>
                     <form action="GioHangServlet" method="post">

                    <input type="hidden" name="idSanPham" value="<%= sp.getId_sanpham()%>">
                    <button class="add-cart" title="Thêm vào giỏ hàng">+</button>
                </form>
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
                    <h3 class="product-name"><%= sp.getTen() %></h3>
                    <p class="product-price"><%= sp.getGia() %> đ</p>
                    <form action="GioHangServlet" method="post">

                    <input type="hidden" name="idSanPham" value="<%= sp.getId_sanpham()%>">
                    <button class="add-cart" title="Thêm vào giỏ hàng">+</button>
                </form>
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
        </section>
    </section>
  </main>

  <jsp:include page="footer.jsp" />
  <script src="js/script.js"></script>
</body>
</html>
