<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.SanPham" %>
<jsp:include page="header.jsp" />

<div class="container main-grid">
  <!-- MENU TRÁI -->
  <aside class="left-menu">
    <h4>Danh mục sản phẩm</h4>
    <ul>
      <li><a href="SanPhamServlet?danhmuc=kynangsong">Kỹ năng sống</a></li>
      <li><a href="SanPhamServlet?danhmuc=sachtiengviet">Sách tiếng Việt</a></li>
      <li><a href="SanPhamServlet?danhmuc=sachgiaokhoa">Sách giáo khoa - tham khảo</a></li>
      <li><a href="SanPhamServlet?danhmuc=ngoai_ngu">Sách ngoại ngữ</a></li>
      <li><a href="SanPhamServlet?danhmuc=dungcu_hocsinh">Dụng cụ học sinh</a></li>
      <li><a href="SanPhamServlet?danhmuc=vanphongpham">Văn phòng phẩm</a></li>
      <li><a href="SanPhamServlet?danhmuc=quatang">Quà tặng</a></li>
      <li><a href="SanPhamServlet?danhmuc=dochoi">Đồ chơi</a></li>
      <li><a href="SanPhamServlet?danhmuc=tramhuong">Sản phẩm trầm hương</a></li>
      <li><a href="SanPhamServlet?danhmuc=vanhocnuocngoai">Văn học nước ngoài</a></li>
    </ul>

    <h4>Mức giá</h4>
    <ul>
      <li><a href="SanPhamServlet?gia=duoi100">Dưới 100.000đ</a></li>
      <li><a href="SanPhamServlet?gia=100-200">100.000đ - 200.000đ</a></li>
      <li><a href="SanPhamServlet?gia=200-300">200.000đ - 300.000đ</a></li>
      <li><a href="SanPhamServlet?gia=300-500">300.000đ - 500.000đ</a></li>
      <li><a href="SanPhamServlet?gia=500-1000">500.000đ - 1.000.000đ</a></li>
      <li><a href="SanPhamServlet?gia=tren1000">Trên 1.000.000đ</a></li>
    </ul>

    <h4>Loại sản phẩm</h4>
    <ul>
      <li><a href="SanPhamServlet?loai=banchay">Bán chạy</a></li>
      <li><a href="SanPhamServlet?loai=giamgia">Khuyến mại - Giảm giá</a></li>
      <li><a href="SanPhamServlet?loai=magiamgia">Mã giảm giá</a></li>
    </ul>
  </aside>

  <!-- NỘI DUNG CHÍNH -->
  <section class="content">

    <!-- HÀNG MỚI -->
    <h3>Hàng mới</h3>
    <div class="product-grid">
      <%
        List<SanPham> listMoi = (List<SanPham>) request.getAttribute("sanPhamMoi");
        if (listMoi == null) listMoi = (List<SanPham>) request.getAttribute("danhSachSanPham");
        if (listMoi != null && !listMoi.isEmpty()) {
          for (SanPham sp : listMoi) {
      %>
      <div class="card">
        <a href="chi_tiet_san_pham.jsp?id=<%= sp.getId() %>">
          <img src="<%= sp.getHinhAnh() %>" alt="<%= sp.getTen() %>">
        </a>
        <h5><%= sp.getTen() %></h5>
        <div class="price"><%= String.format("%,.0f", sp.getGia()) %> đ</div>
        <form action="GioHangServlet" method="post">
          <input type="hidden" name="id" value="<%= sp.getId() %>">
          <button type="submit" class="add-cart">+</button>
        </form>
      </div>
      <% }} else { %>
      <p>Chưa có sản phẩm nào.</p>
      <% } %>
    </div>

    <!-- SẢN PHẨM BÁN CHẠY -->
    <h3>Sản phẩm bán chạy</h3>
    <div class="product-grid">
      <%
        List<SanPham> listHot = (List<SanPham>) request.getAttribute("sanPhamBanChay");
        if (listHot != null && !listHot.isEmpty()) {
          for (SanPham sp : listHot) {
      %>
      <div class="card">
        <a href="chi_tiet_san_pham.jsp?id=<%= sp.getId() %>">
          <img src="<%= sp.getHinhAnh() %>" alt="<%= sp.getTen() %>">
        </a>
        <h5><%= sp.getTen() %></h5>
        <div class="price"><%= String.format("%,.0f", sp.getGia()) %> đ</div>
        <form action="GioHangServlet" method="post">
          <input type="hidden" name="id" value="<%= sp.getId() %>">
          <button type="submit" class="add-cart">+</button>
        </form>
      </div>
      <% }} else { %>
      <p>Không có sản phẩm bán chạy.</p>
      <% } %>
    </div>

    <!-- SẢN PHẨM GIẢM GIÁ -->
    <h3>Sản phẩm giảm giá</h3>
    <div class="product-grid">
      <%
        List<SanPham> listSale = (List<SanPham>) request.getAttribute("sanPhamGiamGia");
        if (listSale != null && !listSale.isEmpty()) {
          for (SanPham sp : listSale) {
      %>
      <div class="card sale">
        <a href="chi_tiet_san_pham.jsp?id=<%= sp.getId() %>">
          <img src="<%= sp.getHinhAnh() %>" alt="<%= sp.getTen() %>">
        </a>
        <h5><%= sp.getTen() %></h5>
        <div class="price">
          <span class="old-price"><%= String.format("%,.0f", sp.getGia()*1.2) %> đ</span>
          <strong><%= String.format("%,.0f", sp.getGia()) %> đ</strong>
        </div>
        <form action="GioHangServlet" method="post">
          <input type="hidden" name="id" value="<%= sp.getId() %>">
          <button type="submit" class="add-cart">+</button>
        </form>
      </div>
      <% }} else { %>
      <p>Không có chương trình giảm giá.</p>
      <% } %>
    </div>

  </section>
</div>

<jsp:include page="footer.jsp" />
