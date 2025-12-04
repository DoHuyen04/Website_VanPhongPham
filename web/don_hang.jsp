<%-- 
    Document   : don_hang
    Created on : Oct 11, 2025, 1:56:26 PM
    Author     : asus
--%>
<%@page import="model.SanPham"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat, model.DonHang, model.DonHangChiTiet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>      
<%@ page import="java.util.HashSet" %>   
 <jsp:include page="header.jsp" />
<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");

    List<DonHang> lichSu = (List<DonHang>) request.getAttribute("dsDonHang");
    Map<Integer, SanPham> mapSP = (Map<Integer, SanPham>) request.getAttribute("mapSP");
    if (mapSP == null) {
        mapSP = new HashMap<>();
    }
    Map<Integer, Integer> mapDonHangDanhGia
            = (Map<Integer, Integer>) request.getAttribute("mapDonHangDanhGia");
    if (mapDonHangDanhGia == null) {
        mapDonHangDanhGia = new HashMap<>();
    }
    Set<Integer> donDaDanhGia = mapDonHangDanhGia.keySet();

    DonHang donMoi = (DonHang) session.getAttribute("donHangHienTai");
    double phiVanChuyen = 15000;
    if (lichSu == null) {
        lichSu = new ArrayList<>();
    }
    if (donMoi != null) {
        lichSu.add(0, donMoi);
        session.removeAttribute("donHangHienTai");
    }
%>


<html>
    <head>
        <title>Lịch sử đơn hàng</title>
        <style>
            /* ====== CHỈ ÁP DỤNG CHO TRANG ĐƠN HÀNG ====== */
            .order-page{
                background: #f5f6fa;
                font-family: Arial, sans-serif;
                padding: 40px 0;
                min-height: calc(100vh - 200px); /* chừa header/footer */
            }

            .order-page .container {
                max-width: 850px;
                margin: auto;
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            }

            .order-page h2 {
                text-align: center;
                color: #5563DE;
                margin-bottom: 20px;
            }

            .order-page .tabbar{
                display:flex;
                gap:18px;
                border-bottom:1px solid #eee;
                margin:6px 0 18px
            }
            .order-page .tabbar a{
                padding:10px 0;
                color:#555;
                text-decoration:none;
                font-weight:600
            }
            .order-page .tabbar a.active{
                color:#ee4d2d;
                border-bottom:2px solid #ee4d2d
            }

            .order-page .badge{
                display:inline-block;
                font-size:12px;
                border:1px solid #f6b;
                color:#f06;
                padding:2px 6px;
                border-radius:4px;
                margin-left:8px
            }
            .order-page .action-row{
                text-align: right;
                display:flex;
                gap:10px;
                justify-content:flex-end;
                margin-top:12px
            }
            .order-page .btn{
                padding:8px 14px;
                border-radius:6px;
                border:1px solid #ddd;
                background:#fff;
                cursor:pointer;
                font-weight: 600
            }
            .order-page .btn.primary{
                background:#ee4d2d;
                color:#fff;
                border-color:#ee4d2d
            }
            .order-page .btn.primary:hover{
                opacity: .9;
            }
            .order-page .btn.danger{
                color:#ee4d2d;
                border-color:#f3b1a6
            }
            .order-page .btn.cancel{
                background:#3498db;
                color:#fff;
                border-color:#3498db;
            }
            .order-page .btn.cancel:hover{
                background:#2c80c9;
                border-color:#2c80c9;
            }
            .order-page .price{
                font-size:18px;
                font-weight:700;
                color:#ee4d2d
            }

            .order-page .order {
                border-bottom: 1px solid #ddd;
                padding: 15px 0;
            }
            .order-page .order:last-child {
                border-bottom: none;
            }
            .order-page .order h3 {
                color: #333;
                margin-bottom: 10px;
            }
            .order-page table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .order-page th,
            .order-page td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: center;
            }
            .order-page th {
                background: #f0f2ff;
                color: #333;
            }
            .order-page .back-btn {
                display: block;
                text-align: center;
                margin-top: 20px;
            }
            .order-page .back-btn a {
                background: #5563DE;
                color: white;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
            }
            .order-page .empty {
                text-align: center;
                color: #888;
                font-style: italic;
            }
            .order-page .summary-right {
                text-align: right;
                width: 100%;
                font-size: 16px;
                font-weight: 600;
                margin-top: 10px;
            }

            /* ====== MODAL XÁC NHẬN & ĐÁNH GIÁ (giữ global) ====== */
            .modal-overlay {
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,0.55);
                justify-content:center;
                align-items:center;
                z-index:9999;
            }
            .modal-box {
                background:#fff;
                width:360px;
                padding:20px;
                border-radius:10px;
                text-align:center;
                box-shadow:0 4px 15px rgba(0,0,0,.2);
                animation:fadeIn .15s ease-out
            }
            .modal-buttons {
                margin-top:20px;
                display:flex;
                justify-content:flex-end;
                gap:10px;
            }
            .btn-modal {
                padding:8px 16px;
                border-radius:6px;
                border:none;
                cursor:pointer;
                font-weight:bold;
            }
            .btn-cancel {
                background:#ddd;
            }
            .btn-ok {
                background:#007bff;
                color:white;
            }

            .review-modal-overlay{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,0.55);
                justify-content:center;
                align-items:center;
                z-index:10000;
            }
            .review-modal-box{
                background:#fff;
                width:380px;
                padding:20px;
                border-radius:12px;
                box-shadow:0 6px 18px rgba(0,0,0,0.25);
                font-size:14px;
            }
            .review-modal-box h3{
                margin-top:0;
                margin-bottom:10px;
                color:#5563DE;
            }
            .review-field{
                margin-bottom:10px;
                text-align:left;
            }
            .review-field label{
                font-weight:600;
                display:block;
                margin-bottom:4px;
            }
            .review-field select,
            .review-field textarea{
                width:100%;
                border-radius:6px;
                border:1px solid #ddd;
                padding:6px 8px;
                font-family:inherit;
                font-size:14px;
            }
            .review-actions{
                margin-top:12px;
                display:flex;
                justify-content:flex-end;
                gap:10px;
            }
            .btn-review{
                padding:7px 14px;
                border-radius:6px;
                border:none;
                cursor:pointer;
                font-weight:600;
            }
            .btn-review-cancel{
                background:#ddd;
            }
            .btn-review-submit{
                background:#ee4d2d;
                color:#fff;
            }
            .order-page .btn[disabled],
            .order-page .btn:disabled{
                background:#ffffff !important;
                color:#b3b3b3 !important;
                border-color:#e5e5e5 !important;
                cursor: default;
                box-shadow:none;
            }
            .order-page .btn.reviewed{
                background:#ffffff;
                color:#b3b3b3;
                border-color:#e5e5e5;
            }
            .order-page .btn.reviewed:hover{
                background:#f7f7f7;
            }


            @keyframes fadeIn {
                from {
                    opacity:0;
                    transform:translateY(10px);
                }
                to   {
                    opacity:1;
                    transform:translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>

        <div class="order-page">
            <div class="container">
                <h2>📜 Lịch sử đơn hàng</h2>
                <%
                    String activeTab = (String) request.getAttribute("activeTab");
                    if (activeTab == null || activeTab.isBlank()) {
                        activeTab = "all";
                    }
                    String base = request.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=";
                %>
                <div class="tabbar">
                    <a class="<%= "all".equals(activeTab) ? "active" : ""%>"
                       href="<%= base%>all">Tất cả</a>

                    <a class="<%= "dadat".equals(activeTab) ? "active" : ""%>"
                       href="<%= base%>dadat">Đơn hàng đã đặt</a>

                    <a class="<%= "dahuy".equals(activeTab) ? "active" : ""%>"
                       href="<%= base%>dahuy">Đơn hàng đã huỷ</a>

                    <a class="<%= "hoantien".equals(activeTab) ? "active" : ""%>"
                       href="<%= base%>hoantien">Đơn hàng đã hoàn tiền</a>
                </div>

                <%
                    if (lichSu != null && !lichSu.isEmpty()) {
                        for (DonHang don : lichSu) {
                %>
                <div class="order">
                    <h3>🛒 Đơn hàng #<%= don.getIdDonHang()%>
                        <span class="badge">
                            <%
                                String tt = don.getTrangthai();
                                String text;
                                switch (tt) {
                                    case "dahuy":
                                        text = "ĐÃ HUỶ";
                                        break;
                                    case "hoantien":
                                        text = "ĐÃ HOÀN TIỀN";
                                        break;
                                    default:
                                        text = "ĐÃ ĐẶT";
                                        break;
                                }
                            %>
                            <%= text%>
                        </span>
                    </h3>
                    <p><b>Mã đơn hàng:</b> <%= don.getIdDonHang()%></p>
                    <p><b>Địa chỉ:</b> <%= don.getDiaChi()%></p>
                    <p><b>Số điện thoại:</b> <%= don.getSoDienThoai()%></p>
                    <p><b>Phương thức thanh toán:</b> <%= don.getPhuongThuc()%></p>
                    <p><b>Ngày đặt:</b> <%= don.getNgayDat()%></p>
                    <%
                        // Lấy danh sách SP trong đơn
                        List<DonHangChiTiet> chiTiet = don.getChiTiet();
                        if (chiTiet == null) {
                            chiTiet = Collections.emptyList();
                        }

                        boolean daDanhGiaDonNay = donDaDanhGia.contains(don.getIdDonHang());
                        Integer idSpDaDanhGia = mapDonHangDanhGia.get(don.getIdDonHang());

                    %>

                    <table>
                        <tr>
                            <th>Mã sản phẩm</th>
                            <th>Tên sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Giá</th>
                        </tr>
                        <%                            for (DonHangChiTiet ct : chiTiet) {
                                SanPham sp = mapSP.get(ct.getId_sanpham());
                        %>
                        <tr>
                            <td><%= ct.getId_sanpham()%></td>
                            <td><%= sp != null ? sp.getTen() : "Không tìm thấy"%></td>
                            <td><%= ct.getSoLuong()%></td>
                            <td><%= df.format(ct.getGia())%></td>
                        </tr>
                        <% }%>
                    </table>

                    <div class="summary-right">
                        Tổng tiền hàng: <%= df.format(don.getTongTien())%><br>
                        Phí vận chuyển: <%= df.format(phiVanChuyen)%><br>
                        <div>Thành tiền: <span class="price"><%= df.format(don.getTongTien() + phiVanChuyen)%></span></div>
                    </div>

                    <div class="action-row">
                        <%
                            if ("dadat".equalsIgnoreCase(don.getTrangthai())) {
                        %>
                        <!-- Hoàn tiền -->
                        <form method="post"
                              action="<%= request.getContextPath()%>/DonHangServlet"
                              style="margin:0"
                              data-action="refund"
                              data-id="<%= don.getIdDonHang()%>">
                            <input type="hidden" name="action" value="refund"/>
                            <input type="hidden" name="id" value="<%= don.getIdDonHang()%>"/>
                            <button type="button"
                                    class="btn primary"
                                    onclick="openRefundModal(<%= don.getIdDonHang()%>)"
                                    <%= daDanhGiaDonNay ? "disabled" : ""%>>
                                Hoàn tiền
                            </button>
                        </form>


                        <!-- Huỷ đơn -->
                        <form method="post"
                              action="<%= request.getContextPath()%>/DonHangServlet"
                              style="margin:0"
                              data-action="cancel"
                              data-id="<%= don.getIdDonHang()%>">
                            <input type="hidden" name="action" value="cancel"/>
                            <input type="hidden" name="id" value="<%= don.getIdDonHang()%>"/>
                            <button type="button"
                                    class="btn cancel"
                                    onclick="openCancelModal(<%= don.getIdDonHang()%>)"
                                    <%= daDanhGiaDonNay ? "disabled" : ""%>>
                                Huỷ đơn hàng
                            </button>
                        </form>


                        <%
                            // nếu đơn này đã có SP được user đánh giá
                            if (daDanhGiaDonNay && idSpDaDanhGia != null) {
                        %>
                        <!-- Nút ĐÃ ĐÁNH GIÁ: bấm vào để xem lại chi tiết + đánh giá -->
                        <a class="btn reviewed"
                           href="<%= request.getContextPath()%>/ChiTietSanPhamServlet?id=<%= idSpDaDanhGia%>">
                            Đã đánh giá
                        </a>
                        <%
                        } else {
                        %>
                        <!-- Nút ĐÃ GIAO (chưa đánh giá) -->
                        <button type="button" class="btn"
                                onclick="openReviewModal(<%= don.getIdDonHang()%>)">
                            Đã giao
                        </button>
                        <%
                                }   // end if daDanhGiaDonNay
                            }     // end if trangthai=dadat
                        %>

                    </div>

                    <%-- SELECT ẨN CHỨA DANH SÁCH SẢN PHẨM CỦA ĐƠN HÀNG NÀY (NEW) --%>
                    <select id="products-order-<%= don.getIdDonHang()%>" style="display:none;">
                        <%
                            // tạo lại vòng lặp để render option
                            List<DonHangChiTiet> chiTietHidden = don.getChiTiet();
                            if (chiTietHidden == null) {
                                chiTietHidden = Collections.emptyList();
                            }
                            for (DonHangChiTiet ctHidden : chiTietHidden) {
                                SanPham spHidden = mapSP.get(ctHidden.getId_sanpham());
                        %>
                        <option value="<%= ctHidden.getId_sanpham()%>">
                            <%= spHidden != null ? spHidden.getTen() : ("SP #" + ctHidden.getId_sanpham())%>
                        </option>
                        <% } %>
                    </select>

                </div>
                <%
                    }
                } else {
                %>
                <p class="empty">Chưa có đơn hàng nào.</p>
                <% }%>

                <div class="back-btn">
                    <a href="<%= request.getContextPath()%>/index.jsp">⬅ Quay lại trang chủ</a>
                </div>
            </div>

            <!-- MODAL ĐÁNH GIÁ SẢN PHẨM (NEW) -->
            <div id="reviewModal" class="review-modal-overlay">
                <div class="review-modal-box">
                    <h3>Đánh giá sản phẩm</h3>

                    <form method="post"
                          action="<%= request.getContextPath()%>/them_danh_gia"
                          enctype="multipart/form-data">  <!-- BẮT BUỘC cho upload ảnh -->
                        <div class="review-field">
                            <label>Hình ảnh (tuỳ chọn):</label>
                            <input type="file" name="hinhAnh" accept="image/*" />
                        </div>
                        <!-- HIDDEN: ID ĐƠN HÀNG, JS sẽ set value -->
                        <input type="hidden" name="idDonHang" id="reviewOrderId"/>

                        <div class="review-field">
                            <label>Sản phẩm trong đơn:</label>
                            <select name="idSanPham" id="reviewProductSelect" required>
                                <!-- options sẽ được JS nạp từ select ẩn -->
                            </select>
                        </div>

                        <div class="review-field">
                            <label>Số sao:</label>
                            <select name="sao" required>
                                <option value="5">5 sao</option>
                                <option value="4">4 sao</option>
                                <option value="3">3 sao</option>
                                <option value="2">2 sao</option>
                                <option value="1">1 sao</option>
                            </select>
                        </div>

                        <div class="review-field">
                            <label>Nhận xét:</label>
                            <textarea name="binhLuan" rows="3"
                                      placeholder="Nhập đánh giá của bạn..."></textarea>
                        </div>

                        <div class="review-field">
                            <label>Hình ảnh (tuỳ chọn):</label>
                            <input type="file" name="hinhAnh" accept="image/*">
                        </div>

                        <div class="review-actions">
                            <button type="button"
                                    class="btn-review btn-review-cancel"
                                    onclick="closeReviewModal()">Hủy</button>

                            <button type="submit"
                                    class="btn-review btn-review-submit">
                                Gửi đánh giá
                            </button>
                        </div>
                    </form>
                </div>
            </div>


            <script>
                let currentAction = null;
                let currentId = null;

                function openRefundModal(id) {
                    currentAction = "refund";
                    currentId = id;
                    document.getElementById("modalMessage").innerText =
                            "Bạn có chắc chắn muốn hoàn tiền đơn #" + id + "?";
                    document.getElementById("confirmModal").style.display = "flex";
                }

                function openCancelModal(id) {
                    currentAction = "cancel";
                    currentId = id;
                    document.getElementById("modalMessage").innerText =
                            "Bạn có chắc chắn muốn huỷ đơn hàng #" + id + "?";
                    document.getElementById("confirmModal").style.display = "flex";
                }

                function closeModal() {
                    document.getElementById("confirmModal").style.display = "none";
                }

                // Khi bấm OK trong popup hoàn tiền / huỷ đơn
                document.getElementById("modalConfirmBtn").onclick = function () {
                    if (!currentAction || !currentId)
                        return;

                    const form = document.querySelector(
                            'form[data-action="' + currentAction + '"][data-id="' + currentId + '"]'
                            );

                    if (form) {
                        form.submit();
                    }
                    closeModal();
                };
                function openReviewModal(orderId) {
                    const sourceSelect = document.getElementById("products-order-" + orderId);
                    const targetSelect = document.getElementById("reviewProductSelect");
                    if (!sourceSelect || !targetSelect)
                        return;

                    // copy list option từ select ẩn sang select trong modal
                    targetSelect.innerHTML = sourceSelect.innerHTML;

                    // GÁN ID ĐƠN HÀNG VÀO INPUT HIDDEN
                    document.getElementById("reviewOrderId").value = orderId;

                    // MỞ MODAL
                    document.getElementById("reviewModal").style.display = "flex";
                }



                function closeReviewModal() {
                    document.getElementById("reviewModal").style.display = "none";
                }
            </script>

            <jsp:include page="footer.jsp"/>

    </body>

     <jsp:include page="footer.jsp" />
</html>
