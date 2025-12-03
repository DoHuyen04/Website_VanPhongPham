<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.*"%>
<%@page import="model.DonHang"%>
<%@page import="model.DonHangChiTiet"%>
<%@page import="model.SanPham"%>
<jsp:include page="header_shipper.jsp" />

<%
    if (request.getAttribute("dsDonHang") == null) {
        response.sendRedirect("ShipperDonHang");
        return;
    }

    List<DonHang> ds = (List<DonHang>) request.getAttribute("dsDonHang");
    Map<Integer, SanPham> mapSP = (Map<Integer, SanPham>) request.getAttribute("mapSP");
    if (mapSP == null) {
        mapSP = new HashMap<>();
    }

    java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");

    String msg = (String) session.getAttribute("msg");
    if (msg != null) {
%>
<div class="alert alert-success alert-dismissible fade show" role="alert">
    <%= msg%>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
        session.removeAttribute("msg");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard Shipper</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .table th, .table td {
                vertical-align: middle;
            }
            .btn-action {
                margin-right: 5px;
                min-height: 36px;
                padding: 5px 12px;
                font-size: 0.85rem;
                border-radius: 5px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }
            .btn-info {
                background: #17a2b8;
                color:#fff;
                border:none;
            }
            .btn-success {
                background: #28a745;
                color:#fff;
                border:none;
            }
            .btn-warning {
                background: #ffc107;
                color:#000;
                border:none;
            }
            .btn-hoanhang {
                background: #FF6347;
                color:#fff;
                border:none;
            }
        </style>
    </head>
    <body class="p-4 bg-light">
        <div class="container">
            <h2 class="mb-4">📦 Dashboard Shipper</h2>
            <p>Tổng đơn hàng: <strong><%= ds.size()%></strong></p>

            <% if (!ds.isEmpty()) { %>
            <table class="table table-bordered table-hover bg-white">
                <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Người đặt</th>
                        <th>Địa chỉ</th>
                        <th>SĐT</th>
                        <th>Thanh toán</th>
                        <th>Tổng tiền</th>
                        <th>Ngày đặt</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (DonHang dh : ds) {
                            String tt = dh.getTrangthai();
                    %>
                    <tr>
                        <td><%= dh.getIdDonHang()%></td>
                        <td><%= dh.getIdNguoiDung()%></td>
                        <td><%= dh.getDiaChi()%></td>
                        <td><%= dh.getSoDienThoai()%></td>
                        <td><%= dh.getPhuongThuc()%></td>
                        <td><%= df.format(dh.getTongTien())%></td>
                        <td><%= dh.getNgayDat()%></td>
                        <td>
                            <% switch (tt.toLowerCase()) {
                                    case "dadat": %>
                            <span class="badge bg-warning text-dark">Đã đặt</span>
                            <% break;
                                case "danggiao": %>
                            <span class="badge bg-primary">Đang giao</span>
                            <% break;
                                case "dagiao": %>
                            <span class="badge bg-success">Đã giao</span>
                            <% break;
                                case "dahuy": %>
                            <span class="badge bg-danger">Đã hủy</span>
                            <% break;
                                case "hoantien": %>
                            <span class="badge bg-info">Hoàn tiền</span>
                            <% break;
                                case "hoankho": %>
                            <span class="badge bg-dark">Hoàn kho</span>
                            <% break;
                                default: %>
                            <span class="badge bg-secondary">Mới</span>
                            <% }%>
                        </td>
                        <td>
                            <div style="display:flex; gap:5px; flex-wrap:wrap;">
                                <!-- Chi tiết -->
                                <button class="btn btn-info btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#details<%= dh.getIdDonHang()%>">Chi tiết</button>

                                <!-- Đang giao -->
                                <% if ("dadat".equalsIgnoreCase(tt)) {%>
                                <form action="ShipperCapNhatTrangThai" method="post" style="margin:0;">
                                    <input type="hidden" name="idDonHang" value="<%= dh.getIdDonHang()%>"/>
                                    <input type="hidden" name="trangThaiMoi" value="danggiao"/>
                                    <button class="btn btn-warning btn-sm" type="submit" onclick="return confirm('Bắt đầu giao đơn hàng?')">Đang giao</button>
                                </form>
                                <% } %>

                                <!-- Đã giao -->
                                <% if ("danggiao".equalsIgnoreCase(tt)) {%>
                                <form action="ShipperCapNhatTrangThai" method="post" style="margin:0;">
                                    <input type="hidden" name="idDonHang" value="<%= dh.getIdDonHang()%>"/>
                                    <input type="hidden" name="trangThaiMoi" value="dagiao"/>
                                    <button class="btn btn-success btn-sm" type="submit" onclick="return confirm('Xác nhận đã giao?')">Đã giao</button>
                                </form>
                                <% } %>

                                <!-- Hoàn hàng -->
                                <% if ("dahuy".equalsIgnoreCase(tt) || "hoantien".equalsIgnoreCase(tt)) {%>
                                <form action="ShipperCapNhatTrangThai" method="post" style="margin:0;">
                                    <input type="hidden" name="idDonHang" value="<%= dh.getIdDonHang()%>"/>
                                    <input type="hidden" name="trangThaiMoi" value="hoankho"/>
                                    <button class="btn btn-danger btn-sm" type="submit" onclick="return confirm('Chuyển về kho?')">Hoàn hàng</button>
                                </form>
                                <% }%>
                            </div>
                        </td>



                    </tr>

                    <!-- Chi tiết sản phẩm collapse -->
                    <tr class="collapse" id="details<%= dh.getIdDonHang()%>">
                        <td colspan="9">
                            <table class="table table-sm table-bordered mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã SP</th>
                                        <th>Tên SP</th>
                                        <th>Số lượng</th>
                                        <th>Giá</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<DonHangChiTiet> chiTiet = dh.getChiTiet();
                                        if (chiTiet != null) {
                                            for (DonHangChiTiet ct : chiTiet) {
                                                SanPham sp = mapSP.get(ct.getId_sanpham());
                                    %>
                                    <tr>
                                        <td><%= ct.getId_sanpham()%></td>
                                        <td><%= sp != null ? sp.getTen() : "Không tìm thấy"%></td>
                                        <td><%= ct.getSoLuong()%></td>
                                        <td><%= df.format(ct.getGia())%></td>
                                    </tr>
                                    <%  }
                                    } else { %>
                                    <tr><td colspan="4" class="text-center">Chưa có sản phẩm</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </td>
                    </tr>

                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p>Chưa có đơn hàng nào.</p>
            <% }%>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
<jsp:include page="footer.jsp"/>
