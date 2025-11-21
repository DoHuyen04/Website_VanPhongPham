<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.SanPham" %>
<jsp:include page="header.jsp" />
<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
<div id="msgBox" class="msg-popup">
    <%= message %>
</div>
<script>
    // Tự động ẩn sau 3 giây
    setTimeout(() => {
        const box = document.getElementById('msgBox');
        if (box) box.style.display = 'none';
    }, 3000);
</script>
<%
        session.removeAttribute("message");
    }
%>

<style>
.msg-popup {
    position: fixed;
    top: 80px;
    right: 30px;
    background-color: #28a745;
    color: #fff;
    padding: 12px 20px;
    border-radius: 10px;
    font-weight: 500;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    z-index: 9999;
    animation: fadeInOut 3s ease;
}
@keyframes fadeInOut {
    0% { opacity: 0; transform: translateY(-10px); }
    10% { opacity: 1; transform: translateY(0); }
    90% { opacity: 1; }
    100% { opacity: 0; transform: translateY(-10px); }
}
</style>

<link rel="stylesheet" href="css/kieu.css">
<style>
    .detail {
  display: flex;
  align-items: center;
  justify-content: flex-start; /* căn toàn bộ nội dung sang trái */
  gap: 10px; /* khoảng cách giữa các phần tử trong .detail */
  margin-top: 8px;
}

.detail .btn-xemchitiet {
  display: inline-block;
  background: linear-gradient(135deg, #42a5f5, #1e88e5); /* xanh nhẹ */
  color: white;
  border: none;
  padding: 7px 16px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  text-decoration: none;
  box-shadow: 0 2px 6px rgba(30, 136, 229, 0.4);
  transition: all 0.3s ease;
}

.detail .btn-xemchitiet:hover {
  background: linear-gradient(135deg, #ff9800, #ff5722); /* chuyển sang cam khi hover */
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(255, 87, 34, 0.4);
}

</style>
<%
    List<SanPham> ds = (List<SanPham>) request.getAttribute("danhSachSanPham");
    if (ds == null) {
        ds = new ArrayList<>();
    }
    String tuKhoa = request.getAttribute("tuKhoa") != null ? (String) request.getAttribute("tuKhoa") : "";
    String danhMucHienTai = request.getAttribute("danhMucHienTai") != null ? (String) request.getAttribute("danhMucHienTai") : "";
    String sapXepHienTai = request.getAttribute("sapXepHienTai") != null ? (String) request.getAttribute("sapXepHienTai") : "";
%>
<div class="container main-grid">
    <!-- ===== DANH MỤC BÊN TRÁI ===== -->
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

    <!-- ===== NỘI DUNG CHÍNH ===== -->
    <section class="content">
        <h3>
            Sản phẩm
            <small>(<%= request.getAttribute("danhMucHienTai") == null ? "Tất cả" : request.getAttribute("danhMucHienTai")%>)</small>
        </h3>
<jsp:include page="thanh_timkiem.jsp" />

        <!-- 🛍️ LƯỚI SẢN PHẨM -->
        <div class="product-grid">
            <%
                if (ds != null && !ds.isEmpty()) {
                    for (SanPham sp : ds) {
            %>
            <div class="card" data-id="<%= sp.getId_sanpham()%>">
                <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                <h5><%= sp.getTen()%></h5>
                <p class="price"><%= String.format("%,.0f", sp.getGia())%> đ</p>
                <form action="GioHangServlet" method="post">

                    <input type="hidden" name="idSanPham" value="<%= sp.getId_sanpham()%>">
                    <button class="add-cart" title="Thêm vào giỏ hàng">+</button>
                </form>
                    <div class ="detail">
                        
                        <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham() %>" class="btn-xemchitiet">
    Detail
</a>
                    </div>
                   
            </div>
            <% }
            } else { %>
            <p>Không có sản phẩm phù hợp.</p>
            <% }%>
        </div>
    </section>
</div>

<jsp:include page="footer.jsp" />
