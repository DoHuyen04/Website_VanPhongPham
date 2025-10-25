<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.SanPham" %>
<jsp:include page="header.jsp" />

<link rel="stylesheet" href="css/kieu.css">
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
        <h4>Danh mục</h4>
        <ul>
            <li><a href="SanPhamServlet?danhmuc=but">🖊️ Bút các loại</a></li>
            <li><a href="SanPhamServlet?danhmuc=sotay">📒 Sổ tay - giấy vở</a></li>
            <li><a href="SanPhamServlet?danhmuc=dungcu_hocsinh">📚 Dụng cụ học sinh</a></li>
            <li><a href="SanPhamServlet?danhmuc=mucin">🖨️ Mực in & Thiết bị</a></li>
            <li><a href="SanPhamServlet?danhmuc=kynangsong">📘 Kỹ năng sống</a></li>
            <li><a href="SanPhamServlet?danhmuc=sachtiengviet">📗 Sách tiếng Việt</a></li>
            <li><a href="SanPhamServlet?danhmuc=sachgiaokhoa">📕 Sách giáo khoa - tham khảo</a></li>
            <li><a href="SanPhamServlet?danhmuc=ngoai_ngu">📙 Sách ngoại ngữ</a></li>
            <li><a href="SanPhamServlet?danhmuc=vanphongpham">🖋️ Văn phòng phẩm</a></li>
            <li><a href="SanPhamServlet?danhmuc=quatang">🎁 Quà tặng</a></li>
            <li><a href="SanPhamServlet?danhmuc=dochoi">🧸 Đồ chơi</a></li>
            <li><a href="SanPhamServlet?danhmuc=tramhuong">🪵 Sản phẩm trầm hương</a></li>
            <li><a href="SanPhamServlet?danhmuc=vanhocnuocngoai">📖 Văn học nước ngoài</a></li>
        </ul>
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
            </div>
            <% }
            } else { %>
            <p>Không có sản phẩm phù hợp.</p>
            <% }%>
        </div>
    </section>
</div>

<jsp:include page="footer.jsp" />
