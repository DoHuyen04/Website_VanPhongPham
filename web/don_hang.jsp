<%@page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat, model.*" %>
<jsp:include page="header.jsp" />

<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");
    List<DonHang> lichSu = (List<DonHang>) request.getAttribute("dsDonHang");
    Map<Integer, SanPham> mapSP = (Map<Integer, SanPham>) request.getAttribute("mapSP");
    if (mapSP == null) mapSP = new HashMap<>();
    Set<Integer> spDaDanhGia = (Set<Integer>) request.getAttribute("spDaDanhGia");
    if (spDaDanhGia == null) spDaDanhGia = new HashSet<>();
    DonHang donMoi = (DonHang) session.getAttribute("donHangHienTai");
    double phiVanChuyen = 15000;
    if (lichSu == null) lichSu = new ArrayList<>();
    if (donMoi != null) {
        lichSu.add(0, donMoi);
        session.removeAttribute("donHangHienTai");
    }
%>

<html>
<head>
    <title>Lịch sử đơn hàng</title>
    <style>
        body {
            background: #f5f6fa;
            font-family: Arial, sans-serif;
            padding: 40px;
        }
        .container {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #5563DE;
            margin-bottom: 25px;
        }
        .tabbar {
            display:flex;
            gap:20px;
            border-bottom:1px solid #ddd;
            margin-bottom: 20px;
        }
        .tabbar a {
            padding:10px 0;
            color:#555;
            text-decoration:none;
            font-weight:600;
        }
        .tabbar a.active {
            color:#ee4d2d;
            border-bottom:2px solid #ee4d2d;
        }
        .order {
            border-bottom: 1px solid #ddd;
            padding: 20px 0;
        }
        .order:last-child { border-bottom: none; }
        .order h3 {
            color: #333;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #fff;
            text-transform: uppercase;
        }
        .badge.dadat { background:#ee4d2d; }
        .badge.dagiao { background:#2ecc71; }
        .badge.danggiao { background:#f39c12; }
        .badge.dahuy { background:#e74c3c; }
        .badge.hoantien { background:#3498db; }
        .badge.hoankho { background:#9b59b6; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
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
        .summary-right {
            text-align: right;
            margin-top: 10px;
            font-weight: 600;
        }
        .price { color:#ee4d2d; font-size:18px; font-weight:700; }

        .action-row {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 12px;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            border:1px solid #ddd;
            background:#fff;
            font-weight:600;
            cursor:pointer;
        }
        .btn.primary { background:#ee4d2d; color:#fff; border-color:#ee4d2d; }
        .btn.primary:hover { opacity:0.9; }
        .btn.cancel { background:#3498db; color:#fff; border-color:#3498db; }
        .btn.cancel:hover { background:#2c80c9; }
        .btn.review { background:#2ecc71; color:#fff; border:none; }
        .back-btn { text-align:center; margin-top:20px; }
        .back-btn a { background:#5563DE; color:#fff; padding:10px 20px; border-radius:6px; text-decoration:none; }

        /* Modal */
        .modal-overlay, .review-modal-overlay {
            display:none;
            position: fixed;
            top:0; left:0; right:0; bottom:0;
            background: rgba(0,0,0,0.4);
            justify-content: center;
            align-items: center;
            z-index: 999;
        }
        .modal-box, .review-modal-box {
            background:#fff;
            padding:20px 25px;
            border-radius:10px;
            max-width: 400px;
            width: 100%;
            text-align:center;
            box-shadow:0 5px 15px rgba(0,0,0,0.3);
        }
        .modal-buttons, .review-actions { margin-top: 15px; display:flex; justify-content:space-around; }
        .btn-modal, .btn-review { padding:8px 15px; border:none; border-radius:6px; font-weight:600; cursor:pointer; }
        .btn-modal.btn-cancel, .btn-review.btn-review-cancel { background:#bdc3c7; color:#fff; }
        .btn-modal.btn-ok, .btn-review.btn-review-submit { background:#2ecc71; color:#fff; }

        .review-field { margin:10px 0; text-align:left; }
        .review-field label { display:block; margin-bottom:5px; font-weight:600; }
        .review-field select, .review-field textarea { width:100%; padding:6px 8px; border-radius:5px; border:1px solid #ccc; }
    </style>
</head>
<body>
<div class="order-page">
    <div class="container">
        <h2>📜 Lịch sử đơn hàng</h2>
        <%
            String activeTab = (String) request.getAttribute("activeTab");
            if (activeTab == null || activeTab.isBlank()) activeTab = "all";
            String base = request.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=";
        %>
        <div class="tabbar">
            <a class="<%= "all".equals(activeTab) ? "active" : ""%>" href="<%= base%>all">Tất cả</a>
            <a class="<%= "dadat".equals(activeTab) ? "active" : ""%>" href="<%= base%>dadat">Đơn hàng đã đặt</a>
             <a class="<%= "dagiao".equals(activeTab) ? "active" : ""%>" href="<%= base%>dagiao">Đơn hàng đã giao</a>
            <a class="<%= "dahuy".equals(activeTab) ? "active" : ""%>" href="<%= base%>dahuy">Đơn hàng đã huỷ</a>
            <a class="<%= "hoantien".equals(activeTab) ? "active" : ""%>" href="<%= base%>hoantien">Đơn hàng đã hoàn tiền</a>
        </div>

        <%
            if (!lichSu.isEmpty()) {
                for (DonHang don : lichSu) {
                    final List<DonHangChiTiet> chiTiet = Optional.ofNullable(don.getChiTiet()).orElse(Collections.emptyList());
                    final Set<Integer> danhGia = spDaDanhGia;
                   List<Integer> spChuaDanhGia = new ArrayList<>();
for (DonHangChiTiet ct : chiTiet) {
    if (!spDaDanhGia.contains(ct.getId_sanpham())) {
        spChuaDanhGia.add(ct.getId_sanpham());
    }
}

boolean daDanhGiaHet = spChuaDanhGia.isEmpty();

                    String tt = don.getTrangthai();
                    String badgeClass = "dadat"; // default
                    String badgeText = "Đã đặt";
                    switch (tt.toLowerCase()) {
                        case "dagiao": badgeClass="dagiao"; badgeText="Đã giao"; break;
                        case "danggiao": badgeClass="danggiao"; badgeText="Đang giao"; break;
                        case "dahuy": badgeClass="dahuy"; badgeText="Đã huỷ"; break;
                        case "hoantien": badgeClass="hoantien"; badgeText="Đã hoàn tiền"; break;
                        case "hoankho": badgeClass="hoankho"; badgeText="Hoàn kho"; break;
                    }
        %>
        <div class="order">
            <h3>🛒 Đơn hàng #<%= don.getIdDonHang() %>
                <span class="badge <%= badgeClass %>"><%= badgeText %></span>
            </h3>
            <p><b>Địa chỉ:</b> <%= don.getDiaChi() %></p>
            <p><b>SĐT:</b> <%= don.getSoDienThoai() %></p>
            <p><b>Thanh toán:</b> <%= don.getPhuongThuc() %></p>
            <p><b>Ngày đặt:</b> <%= don.getNgayDat() %></p>

            <table>
                <tr><th>Mã SP</th><th>Tên SP</th><th>Số lượng</th><th>Giá</th></tr>
                <%
                    for (DonHangChiTiet ct : chiTiet) {
                        SanPham sp = mapSP.get(ct.getId_sanpham());
                %>
                <tr>
                    <td><%= ct.getId_sanpham() %></td>
                    <td><%= sp != null ? sp.getTen() : "Không tìm thấy" %></td>
                    <td><%= ct.getSoLuong() %></td>
                    <td><%= df.format(ct.getGia()) %></td>
                </tr>
                <% } %>
            </table>

            <div class="summary-right">
                Tổng tiền hàng: <%= df.format(don.getTongTien()) %><br>
                Phí vận chuyển: <%= df.format(phiVanChuyen) %><br>
                Thành tiền: <span class="price"><%= df.format(don.getTongTien() + phiVanChuyen) %></span>
            </div>

            <div class="action-row">
                <% if ("dadat".equalsIgnoreCase(tt)) { %>
                    <form method="post" action="<%= request.getContextPath() %>/DonHangServlet" data-action="refund" data-id="<%= don.getIdDonHang()%>">
                        <input type="hidden" name="action" value="refund"/>
                        <input type="hidden" name="id" value="<%= don.getIdDonHang()%>"/>
                        <button type="button" class="btn primary" onclick="openRefundModal(<%= don.getIdDonHang()%>)">Hoàn tiền</button>
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/DonHangServlet" data-action="cancel" data-id="<%= don.getIdDonHang()%>">
                        <input type="hidden" name="action" value="cancel"/>
                        <input type="hidden" name="id" value="<%= don.getIdDonHang()%>"/>
                        <button type="button" class="btn cancel" onclick="openCancelModal(<%= don.getIdDonHang()%>)">Huỷ đơn hàng</button>
                    </form>
                <% } else if ("dagiao".equalsIgnoreCase(tt)) {
    if (!daDanhGiaHet) { 
        %>
        <button type="button" class="btn review" onclick="openReviewModal(<%= don.getIdDonHang()%>)">
            Đánh giá (<%= spChuaDanhGia.size() %>)
        </button>
        <%
    } else {
        %>
        <button class="btn review" disabled>Đã đánh giá</button>
        <%
    }
}
%>
            </div>

            <select id="products-order-<%= don.getIdDonHang()%>" style="display:none;">
                <%
                    for (DonHangChiTiet ctHidden : chiTiet) {
    if (!spDaDanhGia.contains(ctHidden.getId_sanpham())) {
        SanPham spHidden = mapSP.get(ctHidden.getId_sanpham());
%>
<option value="<%= ctHidden.getId_sanpham()%>">
    <%= spHidden != null ? spHidden.getTen() : ("SP #" + ctHidden.getId_sanpham()) %>
</option>
<%
    }
}
%>

            </select>
        </div>
        <% }} else { %>
            <p class="empty">Chưa có đơn hàng nào.</p>
        <% } %>

        <div class="back-btn">
            <a href="<%= request.getContextPath() %>/index.jsp">⬅ Quay lại trang chủ</a>
        </div>
    </div>

    <!-- MODAL XÁC NHẬN -->
    <div id="confirmModal" class="modal-overlay">
        <div class="modal-box">
            <div id="modalMessage"></div>
            <div class="modal-buttons">
                <button class="btn-modal btn-cancel" onclick="closeModal()">Huỷ bỏ</button>
                <button class="btn-modal btn-ok" id="modalConfirmBtn">Đồng ý</button>
            </div>
        </div>
    </div>

    <!-- MODAL ĐÁNH GIÁ -->
    <div id="reviewModal" class="review-modal-overlay">
        <div class="review-modal-box">
            <h3>Đánh giá sản phẩm</h3>
            <form method="post" action="<%= request.getContextPath()%>/them_danh_gia">
                <div class="review-field">
                    <label>Sản phẩm:</label>
                    <select name="idSanPham" id="reviewProductSelect" required></select>
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
                    <textarea name="binhLuan" rows="3" placeholder="Nhập đánh giá của bạn..."></textarea>
                </div>
                <div class="review-actions">
                    <button type="button" class="btn-review btn-review-cancel" onclick="closeReviewModal()">Hủy</button>
                    <button type="submit" class="btn-review btn-review-submit">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
let currentAction = null;
let currentId = null;

function openRefundModal(id) {
    currentAction = "refund";
    currentId = id;
    document.getElementById("modalMessage").innerText = "Bạn có chắc chắn muốn hoàn tiền đơn #" + id + "?";
    document.getElementById("confirmModal").style.display = "flex";
}

function openCancelModal(id) {
    currentAction = "cancel";
    currentId = id;
    document.getElementById("modalMessage").innerText = "Bạn có chắc chắn muốn huỷ đơn hàng #" + id + "?";
    document.getElementById("confirmModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("confirmModal").style.display = "none";
}

document.getElementById("modalConfirmBtn").onclick = function () {
    if (!currentAction || !currentId) return;
    const form = document.querySelector('form[data-action="' + currentAction + '"][data-id="' + currentId + '"]');
    if (form) form.submit();
    closeModal();
};

function openReviewModal(orderId) {
    const sourceSelect = document.getElementById("products-order-" + orderId);
    const targetSelect = document.getElementById("reviewProductSelect");
    if (!sourceSelect || !targetSelect) return;
    targetSelect.innerHTML = sourceSelect.innerHTML;
    document.getElementById("reviewModal").style.display = "flex";
}

function closeReviewModal() {
    document.getElementById("reviewModal").style.display = "none";
}
</script>
<jsp:include page="footer.jsp" />
