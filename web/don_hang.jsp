<%-- 
    Document   : don_hang
    Created on : Oct 11, 2025, 1:56:26 PM
    Author     : asus
--%>
<%@page import="model.SanPham"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat, model.DonHang, model.DonHangChiTiet" %>
<%@ page import="java.util.Map" %>
 <jsp:include page="header.jsp" />
<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");

    List<DonHang> lichSu = (List<DonHang>) request.getAttribute("dsDonHang");
    Map<Integer, SanPham> mapSP = (Map<Integer, SanPham>) request.getAttribute("mapSP");
    if (mapSP == null) {
        mapSP = new HashMap<>();
    }

    DonHang donMoi = (DonHang) session.getAttribute("donHangHienTai");
    double phiVanChuyen = 15000;
    if (lichSu == null) {
        lichSu = new ArrayList<>();
    }
    if (donMoi != null) {
        lichSu.add(0, donMoi); // thêm đơn mới lên đầu
        session.removeAttribute("donHangHienTai");
    }
%>

<html>
    <head>
        <title>Lịch sử đơn hàng</title>
        <style>
            .tabbar{
                display:flex;
                gap:18px;
                border-bottom:1px solid #eee;
                margin:6px 0 18px
            }
            .tabbar a{
                padding:10px 0;
                color:#555;
                text-decoration:none;
                font-weight:600
            }
            .tabbar a.active{
                color:#ee4d2d;
                border-bottom:2px solid #ee4d2d
            }
            .badge{
                display:inline-block;
                font-size:12px;
                border:1px solid #f6b;
                color:#f06;
                padding:2px 6px;
                border-radius:4px;
                margin-left:8px
            }
            .action-row{
                text-align: right;
                display:flex;
                gap:10px;
                justify-content:flex-end;
                margin-top:12px
            }
            .btn{
                padding:8px 14px;
                border-radius:6px;
                border:1px solid #ddd;
                background:#fff;
                cursor:pointer;
                font-weight: 600
            }
            .btn.primary{
                background:#ee4d2d;
                color:#fff;
                border-color:#ee4d2d
            }
            .btn.primary:hover{
                opacity: .9;
            }
            .btn.danger{
                color:#ee4d2d;
                border-color:#f3b1a6
            }
            .btn.cancel{
                background:#3498db;
                color:#fff;
                border-color:#3498db;
            }
            .btn.cancel:hover{
                background:#2c80c9;
                border-color:#2c80c9;
            }
            .price{
                font-size:18px;
                font-weight:700;
                color:#ee4d2d
            }

            body {
                background: #f5f6fa;
                font-family: Arial, sans-serif;
                padding: 40px;
            }
            .container {
                max-width: 850px;
                margin: auto;
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #5563DE;
                margin-bottom: 20px;
            }
            .order {
                border-bottom: 1px solid #ddd;
                padding: 15px 0;
            }
            .order:last-child {
                border-bottom: none;
            }
            .order h3 {
                color: #333;
                margin-bottom: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: center;
            }
            th {
                background: #f0f2ff;
                color: #333;
            }
            .back-btn {
                display: block;
                text-align: center;
                margin-top: 20px;
            }
            .back-btn a {
                background: #5563DE;
                color: white;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
            }
            .empty {
                text-align: center;
                color: #888;
                font-style: italic;
            }
            .summary-right {
                text-align: right;
                width: 100%;
                font-size: 16px;
                font-weight: 600;
                margin-top: 10px;
            }

        </style>
    </head>
    <body>

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

                <table>
                    <tr>
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Giá</th>
                    </tr>
                    <%
                        List<DonHangChiTiet> chiTiet = don.getChiTiet();
                        if (chiTiet == null) {
                            chiTiet = Collections.emptyList();
                        }
                        for (DonHangChiTiet ct : chiTiet) {
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
                        <button type="button" class="btn primary" onclick="openRefundModal(<%= don.getIdDonHang()%>)">
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
                        <button type="button" class="btn cancel" onclick="openCancelModal(<%= don.getIdDonHang()%>)">
                            Huỷ đơn hàng
                        </button>
                    </form>

                    <%
                        } // end if dadat
                    %>
                </div>


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
        <style>
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
        </style>

        <div id="confirmModal" class="modal-overlay">
            <div class="modal-box">
                <div id="modalMessage" style="font-size:17px; margin-bottom:20px;"></div>
                <div class="modal-buttons">
                    <button class="btn-modal btn-cancel" onclick="closeModal()">Huỷ bỏ</button>
                    <button class="btn-modal btn-ok" id="modalConfirmBtn">Đồng ý</button>
                </div>
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

            // Khi bấm OK trong popup
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
        </script>

    </body>
     <jsp:include page="footer.jsp" />
</html>