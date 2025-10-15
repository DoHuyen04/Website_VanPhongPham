<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <title>Trang chủ - Cửa hàng Văn phòng phẩm</title>
  <link rel="stylesheet" href="css/kieu.css">
  <meta name="viewport" content="width=device-width,initial-scale=1">
</head>
<body>
   <!-- 🟥 Banner -->
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
      <a href="dang_nhap.jsp" class="account">👤 Tài khoản</a>
      <a href="gio_hang.jsp" class="cart">🛒 Giỏ hàng (0)</a>
    </div>
  </header>

  <!-- 🟡 Menu ngang -->
  <nav class="top-menu">
    <a href="trang_chu.jsp">Trang chủ</a>
    <a href="san_pham.jsp">Sản phẩm</a>
    <a href="gioi_thieu.jsp">Giới thiệu</a>
    <a href="lien_he.jsp">Liên hệ</a>
  </nav>

  <!-- Main -->
  <main class="container main-grid">
   <!-- Left Menu -->
<aside class="left-menu">
  <form action="san_pham.jsp" method="get">
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
      <li><label><input type="checkbox" name="loai" value="giamgia"> Khuyến mại - Giảm giá</label></li>
      <li><label><input type="checkbox" name="loai" value="magiamgia"> Mã giảm giá</label></li>
    </ul>

    <button type="submit" class="btn-loc">Lọc sản phẩm</button>
  </form>
</aside>


    <!-- Content -->
      <!-- Khu vực hiển thị sản phẩm -->
    <section class="content">
      <div class="sort-bar">
        <label>Sắp xếp:</label>
        <select>
          <option>Theo giá tăng dần</option>
          <option>Theo giá giảm dần</option>
          <option>Tên A → Z</option>
          <option>Tên Z → A</option>
        </select>
      </div>

      <div class="product-grid">
        <div class="card">
          <img src="hinh_anh/pen1.jpg" alt="Bút bi">
          <h5>Bút bi Thiên Long</h5>
          <div class="price">5.000 đ</div>
          <button class="add-cart">+</button>
        </div>

        <div class="card">
          <img src="hinh_anh/notebook1.jpg" alt="Sổ tay">
          <h5>Sổ tay A5</h5>
          <div class="price">15.000 đ</div>
          <button class="add-cart">+</button>
        </div>

        <div class="card">
          <img src="hinh_anh/ink1.jpg" alt="Mực in">
          <h5>Mực in HP</h5>
          <div class="price">350.000 đ</div>
          <button class="add-cart">+</button>
        </div>
      </div>
    </section>
  </main>
<!-- Footer -->
<footer class="footer">
  <div class="container footer-grid">
    <div class="member">
      <h4>Đỗ Thị Huyền</h4>
      <p>📅 03/04/2004</p>
      <p>📞 033 7949 703</p>
      <p>✉️ dohuyen34204@gmail.com</p>
    </div>

    <div class="member">
      <h4>Đậu Thị Mai</h4>
      <p>📅 (chưa cập nhật)</p>
      <p>📞 0123 456 789</p>
      <p>✉️ mai@example.com</p>
    </div>

    <div class="member">
      <h4>Nông Thị Mai Hương</h4>
      <p>📅 03/03/2000</p>
      <p>📞 0123 456 789</p>
      <p>✉️ huong@example.com</p>
    </div>
  </div>
</footer>

<script src="js/script.js"></script>

</body>
</html>
