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

        <!-- 🔍 THANH TÌM KIẾM + SẮP XẾP -->
        <form class="filter-form" action="SanPhamServlet" method="get">
            <input type="hidden" name="danhmuc" value="<%= request.getParameter("danhmuc") != null ? request.getParameter("danhmuc") : ""%>" />
            <input type="text" name="tuKhoa" placeholder="🔎 Từ khóa..."
                   value="<%= request.getParameter("tuKhoa") != null ? request.getParameter("tuKhoa") : ""%>"
                   style="padding: 6px 10px; border-radius: 5px; border: 1px solid #ccc; width: 250px;">
            <select name="sapXep" style="margin-left: 10px;">
                <option value="">-- Sắp xếp --</option>
                <option value="tang">Giá tăng dần</option>
                <option value="giam">Giá giảm dần</option>
                <option value="az">Tên A - Z</option>
                <option value="za">Tên Z - A</option>
            </select>
            <button type="submit" class="btn-loc" style="margin-left: 10px;">Áp dụng</button>
        </form>


        <!-- 🛍️ LƯỚI SẢN PHẨM -->
        <div class="product-grid">
            <%
                if (ds != null && !ds.isEmpty()) {
                    for (SanPham sp : ds) {
            %>
            <div class="card" data-id="<%= sp.getId()%>">
                <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                <h5><%= sp.getTen()%></h5>
                <p class="price"><%= String.format("%,.0f", sp.getGia())%> đ</p>
                <form action="GioHangServlet" method="post">

                    <input type="hidden" name="idSanPham" value="<%= sp.getId()%>">
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
