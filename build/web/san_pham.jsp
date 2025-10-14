<%-- 
    Document   : san_pham
    Created on : Oct 11, 2025, 1:54:38 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.SanPham" %>
<jsp:include page="header.jsp" />

<div class="container main-grid">
  <aside class="left-menu">
    <h4>Danh mục</h4>
    <ul>
      <li><a href="san_pham.jsp?danhmuc=but">Bút các loại</a></li>
      <li><a href="san_pham.jsp?danhmuc=sotay">Sổ tay, giấy vở</a></li>
      <li><a href="san_pham.jsp?danhmuc=dungcu">Dụng cụ học tập</a></li>
      <li><a href="san_pham.jsp?danhmuc=mucin">Mực in & Thiết bị</a></li>
    </ul>
  </aside>

  <section class="content">
    <h3>Sản phẩm <small>(<%= request.getAttribute("danhMucHienTai") == null ? "Tất cả" : request.getAttribute("danhMucHienTai") %>)</small></h3>

    <!-- Filter / Sort -->
    <form class="filter-form" action="SanPhamServlet" method="get">
      <input type="hidden" name="danhmuc" value="<%= request.getParameter("danhmuc") != null ? request.getParameter("danhmuc") : "" %>" />
      <input type="text" name="tuKhoa" placeholder="Từ khóa..." value="<%= request.getParameter("tuKhoa") != null ? request.getParameter("tuKhoa") : "" %>" />
      <select name="sapXep">
        <option value="">-- Sắp xếp --</option>
        <option value="tang">Giá tăng dần</option>
        <option value="giam">Giá giảm dần</option>
      </select>
      <select name="locThuongHieu">
        <option value="">-- Nhà cung cấp --</option>
        <option value="Thiên Long">Thiên Long</option>
        <option value="HP">HP</option>
      </select>
      <button type="submit">Áp dụng</button>
    </form>

    <!-- Grid -->
    <div class="product-grid">
      <%
        List<SanPham> ds = (List<SanPham>) request.getAttribute("danhSachSanPham");
        if (ds != null && !ds.isEmpty()) {
          for (SanPham sp : ds) {
      %>
      <div class="card">
        <a href="chi_tiet_san_pham.jsp?id=<%= sp.getId() %>">
          <img src="<%= sp.getHinhAnh() %>" alt="<%= sp.getTen() %>">
        </a>
        <h5><%= sp.getTen() %></h5>
        <div class="sku">Mã: <%= sp.getId() %></div>
        <div class="price"><%= String.format("%,.0f", sp.getGia()) %> đ</div>
        <a class="btn" href="GioHangServlet?hanhDong=them&id=<%= sp.getId() %>">Thêm vào giỏ</a>
      </div>
      <%   }
        } else { %>
      <p>Không có sản phẩm phù hợp.</p>
      <% } %>
    </div>

    <!-- Pagination (nếu được set) -->
    <div class="pagination">
      <%
        Integer trangHienTai = (Integer) request.getAttribute("trangHienTai");
        Integer tongTrang = (Integer) request.getAttribute("tongTrang");
        if (trangHienTai == null) trangHienTai = 1;
        if (tongTrang == null) tongTrang = 1;
        for (int i = 1; i <= tongTrang; i++) {
          if (i == trangHienTai) {
      %>
        <span class="page current"><%= i %></span>
      <% } else { %>
        <a class="page" href="SanPhamServlet?page=<%= i %>&danhmuc=<%= request.getParameter("danhmuc") %>"><%= i %></a>
      <% } } %>
    </div>
  </section>
</div>

<jsp:include page="footer.jsp" />
