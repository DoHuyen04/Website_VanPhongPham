<%@page import="model.NguoiDung"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.*"%>
<%@page import="model.DonHang"%>
<%@page import="model.DonHangChiTiet"%>
<%@page import="model.SanPham"%>

<%
    if (request.getAttribute("dsDonHang") == null) {
        response.sendRedirect("ShipperDonHang");
        return;
    }
    String activeTab = (String) request.getAttribute("activeTab");
    List<DonHang> ds = (List<DonHang>) request.getAttribute("dsDonHang");
    Map<Integer, SanPham> mapSP = (Map<Integer, SanPham>) request.getAttribute("mapSP");
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    Integer ordersInProgress = (Integer) request.getAttribute("ordersInProgress");
    Integer ordersDelivered = (Integer) request.getAttribute("ordersDelivered");
    Integer ordersReturned = (Integer) request.getAttribute("ordersReturned");
    List<Map<String, Object>> topProducts = (List<Map<String, Object>>) request.getAttribute("topProducts");
    List<Map<String, Object>> topRatedProducts = (List<Map<String, Object>>) request.getAttribute("topRatedProducts");

    if (mapSP == null) {
        mapSP = new HashMap<>();
    }

    java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");

    String msg = (String) session.getAttribute("msg");
    String msgType = (String) session.getAttribute("msgType");
    if (msg != null) {
%>
<div class="alert alert-<%= (msgType != null && msgType.equals("success")) ? "success" : "danger"%> alert-dismissible fade show" role="alert">
    <%= msg%>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
        session.removeAttribute("msg");
        session.removeAttribute("msgType");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard Shipper</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }
            .container {
                max-width: 1200px;
            }

            .table th, .table td {
                vertical-align: middle;
            }
            .btn-action {
                min-height:36px;
                padding:5px 12px;
                font-size:0.85rem;
                border-radius:5px;
                display:inline-flex;
                align-items:center;
                justify-content:center;
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
            .topmenu .nav-link {
                cursor:pointer;
            }
            .shipper-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .shipper-greeting {
                font-size: 1.1rem;
                font-weight: bold;
            }
            .dropdown-logout {
                position: relative;
                display: inline-block;
            }
            .dropdown-logout-content {
                display: none;
                position: absolute;
                right: 0;
                background-color: #f9f9f9;
                min-width: 120px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
                border-radius: 5px;
            }
            .dropdown-logout-content a {
                color: black;
                padding: 10px 12px;
                text-decoration: none;
                display: block;
            }
            .stat-box {
                padding: 20px;
                border-radius: 10px;
                color: #fff;
                text-align: center;
                margin-bottom: 15px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            .bg-total {
                background-color: #6c757d;
            }       /* xám */
            .bg-inprogress {
                background-color: #ffc107;
            }  /* vàng */
            .bg-delivered {
                background-color: #28a745;
            }   /* xanh lá */
            .bg-returned {
                background-color: #dc3545;
            }    /* đỏ */

            .dropdown-logout-content a:hover {
                background-color: #ddd;
            }
            .dropdown-logout:hover .dropdown-logout-content {
                display: block;
                cursor: pointer;
            }
        </style>
    </head>
    <body class="p-4 bg-light">
        <div class="container">
            <h2 class="mb-4">📦 Dashboard Shipper</h2>
            <div class="shipper-header">
                <div class="shipper-greeting">
                    Xin chào, <%= ((NguoiDung) session.getAttribute("nguoiDung")).getHoTen()%>!
                </div>
                <div class="dropdown-logout">
                    <span>⚙️ Menu</span>
                    <div class="dropdown-logout-content">
                        <a href="DangXuatServlet">Đăng xuất</a>
                    </div>
                </div>
            </div>

            <ul class="nav nav-tabs mb-3">
                <li class="nav-item">
                    <a class="nav-link <%= "dashboard".equals(request.getAttribute("activeTab")) ? "active" : ""%>" href="ShipperDonHang">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "danggiao".equals(request.getAttribute("activeTab")) ? "active" : ""%>" href="ShipperDonHang?trangthai=danggiao">Đơn hàng đang giao</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "dagiao".equals(request.getAttribute("activeTab")) ? "active" : ""%>" href="ShipperDonHang?trangthai=dagiao">Đơn hàng đã giao</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "hoankho".equals(request.getAttribute("activeTab")) ? "active" : ""%>" href="ShipperDonHang?trangthai=hoankho">Đơn hàng hoàn hàng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "thongke".equals(activeTab) ? "active" : ""%>" 
                       href="ShipperDonHang?trangthai=thongke">Thống kê</a>
                </li>
            </ul>
            <div class="tab-content">

                <% if ("thongke".equals(activeTab)) {%>
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stat-box bg-total">
                            <h4>Tổng đơn hàng</h4>
                            <h2><%= totalOrders%></h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box bg-inprogress">
                            <h4>Đang giao</h4>
                            <h2><%= ordersInProgress%></h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box bg-delivered">
                            <h4>Đã giao</h4>
                            <h2><%= ordersDelivered%></h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box bg-returned">
                            <h4>Hoàn hàng</h4>
                            <h2><%= ordersReturned%></h2>
                        </div>
                    </div>
                </div>

                <!-- Biểu đồ đơn hàng theo trạng thái -->
                <div class="mb-4">
                    <canvas id="ordersChart" height="120"></canvas>
                </div>


                <script>
                    const ctx = document.getElementById('ordersChart').getContext('2d');
                    const ordersChart = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: ['Đang giao', 'Đã giao', 'Hoàn hàng'],
                            datasets: [{
                                    label: 'Số lượng đơn hàng',
                                    data: [<%= ordersInProgress%>, <%= ordersDelivered%>, <%= ordersReturned%>],
                                    backgroundColor: ['#ffc107', '#28a745', '#dc3545']
                                }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {position: 'bottom'}
                            }
                        }
                    });
                </script>
                <% }%>

            </div>
        </div>
        <p>Tổng đơn hàng: <strong><%= ds != null ? ds.size() : 0%></strong></p>

        <% if (ds != null && !ds.isEmpty()) { %>
        <table class="table table-bordered table-hover bg-white">
            <thead class="table-light">
                <tr>
                    <th>Mã đơn</th>
                    <th>Người đặt</th>
                    <th>Địa chỉ</th>
                    <th>SĐT</th>
                    <th>Phương thức thanh toán</th>
                    <th>Tiền hàng</th>
                    <th>Phí ship</th>
                    <th>Tổng tiền</th>
                    <th>Thu tiền</th>
                    <th>Ngày đặt</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <% for (DonHang dh : ds) {
                        String tt = dh.getTrangthai() != null ? dh.getTrangthai().trim().toLowerCase() : "";
                        // TÍNH TIỀN
                        int phiShip = 15000;
                        double tienHang = dh.getTongTien();
                        double tongTien = tienHang + phiShip;

                        // Thu tiền theo phương thức
                        double thuTien = dh.getPhuongThuc().equalsIgnoreCase("COD") ? tongTien : 0;
                %>
                <tr>
                    <td><%= dh.getIdDonHang()%></td>
                    <td><%= dh.getIdNguoiDung()%></td>
                    <td><%= dh.getDiaChi()%></td>
                    <td><%= dh.getSoDienThoai()%></td>
                    <td><%= dh.getPhuongThuc()%></td>
                    <td><%= df.format(tienHang)%></td>
                    <td><%= df.format(phiShip)%></td>
                    <td><%= df.format(tongTien)%></td>
                    <td><strong><%= df.format(thuTien)%></strong></td>
                    <td><%= dh.getNgayDat()%></td>
                    <td>
                        <% switch (tt) {
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
                        <div class="d-flex flex-wrap gap-1 align-items-center">
                            <!-- Chi tiết -->
                            <button class="btn btn-info btn-sm btn-action" type="button" data-bs-toggle="collapse" data-bs-target="#details<%= dh.getIdDonHang()%>">Chi tiết</button>

                            <% if ("dadat".equals(tt)) {%>
                            <form action="ShipperCapNhatTrangThai" method="post" class="d-inline">
                                <input type="hidden" name="idDonHang" value="<%= dh.getIdDonHang()%>"/>
                                <input type="hidden" name="trangThaiMoi" value="danggiao"/>
                                <button class="btn btn-warning btn-sm btn-action" type="submit" onclick="return confirm('Bắt đầu giao đơn hàng?')">Đang giao</button>
                            </form>
                            <% } %>

                            <% if ("danggiao".equals(tt)) {%>
                            <form action="ShipperCapNhatTrangThai" method="post" class="d-inline">
                                <input type="hidden" name="idDonHang" value="<%= dh.getIdDonHang()%>"/>
                                <input type="hidden" name="trangThaiMoi" value="dagiao"/>
                                <button class="btn btn-success btn-sm btn-action" type="submit" onclick="return confirm('Xác nhận đã giao?')">Đã giao</button>
                            </form>
                            <% } %>

                            <% if ("dahuy".equals(tt) || "hoantien".equals(tt)) {%>
                            <form action="ShipperCapNhatTrangThai" method="post" class="d-inline">
                                <input type="hidden" name="idDonHang" value="<%= dh.getIdDonHang()%>"/>
                                <input type="hidden" name="trangThaiMoi" value="hoankho"/>
                                <button class="btn btn-hoanhang btn-sm btn-action" type="submit" onclick="return confirm('Chuyển về kho?')">Hoàn hàng</button>
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
                                    if (chiTiet != null && !chiTiet.isEmpty()) {
                                        for (DonHangChiTiet ct : chiTiet) {
                                            SanPham sp = mapSP.get(ct.getId_sanpham());
                                %>
                                <tr>
                                    <td><%= ct.getId_sanpham()%></td>
                                    <td><%= sp != null ? sp.getTen() : "Không tìm thấy"%></td>
                                    <td><%= ct.getSoLuong()%></td>
                                    <td><%= df.format(ct.getGia())%></td>
                                </tr>
                                <%      }
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
        <p class="text-muted">Chưa có đơn hàng nào.</p>
        <% }%>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<jsp:include page="footer.jsp"/>
