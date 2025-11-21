<%-- 
    Document   : thanh_timkiem
    Created on : Oct 24, 2025, 7:56:28 AM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
/* ==== THANH TÌM KIẾM DÙNG CHUNG ==== */

.filter-bar {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
  margin: 20px auto;
  padding: 10px 20px;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 12px;
  box-shadow: 0 3px 6px rgba(0,0,0,0.1);
  max-width: 800px;
}

.search-group {
  display: flex;
  align-items: center;
}

.input-search {
  width: 280px;
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s;
}

.input-search:focus {
  border-color: #007bff;
  box-shadow: 0 0 4px rgba(0,123,255,0.5);
}

.sort-group {
  display: flex;
  align-items: center;
  gap: 6px;
}

.select-sort {
  padding: 7px 10px;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 14px;
}

.btn-apply {
  background: linear-gradient(135deg, #4e9af1, #007bff);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 8px 18px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 600;
}

.btn-apply:hover {
  background: #f9a11b;
  color: #000;
  transform: translateY(-1px);
}

/* Responsive */
@media (max-width: 768px) {
  .filter-bar {
    flex-direction: column;
    max-width: 95%;
  }
  .input-search {
    width: 100%;
  }
}
</style>

<!-- ==== FORM THANH TÌM KIẾM ==== -->
<form class="filter-bar" action="SanPhamServlet" method="get">

  <!-- Giữ lại danh mục, giá, loại khi tìm kiếm -->
  <%
    String[] danhMucs = request.getParameterValues("danhmuc");
    String[] gias = request.getParameterValues("gia");
    String[] loais = request.getParameterValues("loai");
    if (danhMucs != null)
        for (String dm : danhMucs) {
  %>
      <input type="hidden" name="danhmuc" value="<%= dm %>">
  <% } %>
  <% if (gias != null)
        for (String g : gias) {
  %>
      <input type="hidden" name="gia" value="<%= g %>">
  <% } %>
  <% if (loais != null)
        for (String l : loais) {
  %>
      <input type="hidden" name="loai" value="<%= l %>">
  <% } %>

  <div class="search-group">
    <input type="text" name="tuKhoa" class="input-search"
           placeholder="🔍 Tìm sản phẩm..."
           value="<%= request.getParameter("tuKhoa") != null ? request.getParameter("tuKhoa") : ""%>">
  </div>

  <div class="sort-group">
    <label for="sapXep">Sắp xếp:</label>
    <select id="sapXep" name="sapXep" class="select-sort">
      <option value="">-- Chọn --</option>
      <option value="tang" <%= "tang".equals(request.getParameter("sapXep")) ? "selected" : ""%>>Giá tăng dần</option>
      <option value="giam" <%= "giam".equals(request.getParameter("sapXep")) ? "selected" : ""%>>Giá giảm dần</option>
      <option value="az" <%= "az".equals(request.getParameter("sapXep")) ? "selected" : ""%>>Tên A - Z</option>
      <option value="za" <%= "za".equals(request.getParameter("sapXep")) ? "selected" : ""%>>Tên Z - A</option>
    </select>
    <button type="submit" class="btn-apply">Áp dụng</button>
  </div>
</form>
