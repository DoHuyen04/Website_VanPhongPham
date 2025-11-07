<%-- 
    Document   : don_hang
    Created on : Oct 11, 2025, 1:56:26 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat, model.DonHang, model.DonHangChiTiet" %>

<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");
    List<DonHang> lichSu = (List<DonHang>) request.getAttribute("dsDonHang");
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
                cursor:pointer
            }
            .btn.primary{
                background:#ee4d2d;
                color:#fff;
                border-color:#ee4d2d
            }
            .btn.danger{
                color:#ee4d2d;
                border-color:#f3b1a6
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
                <a class="<%= "all".equals(activeTab) ? "active" : ""%>"      href="<%= base%>all">Tất cả</a>
                <a class="<%= "dadat".equals(activeTab) ? "active" : ""%>"    href="<%= base%>dadat">Đơn hàng đã đặt</a>
                <a class="<%= "dahuy".equals(activeTab) ? "active" : ""%>"    href="<%= base%>dahuy">Đơn hàng đã huỷ</a>
                <a class="<%= "hoantien".equals(activeTab) ? "active" : ""%>" href="<%= base%>hoantien">Đơn hàng đã hoàn tiền</a>
            </div>

            <%
                if (lichSu != null && !lichSu.isEmpty()) {
                    for (DonHang don : lichSu) {
            %>
            <div class="order">
                <h3>🛒 Đơn hàng #<%= don.getIdDonHang()%>
                    <span class="badge">
                        <%
                            String tt = don.getTrangthai(); // 'dadat' | 'dahuy' | 'hoantien'
                            String text = "ĐÃ ĐẶT";
                            if ("dahuy".equalsIgnoreCase(tt))
                                text = "ĐÃ HUỶ";
                            else if ("hoantien".equalsIgnoreCase(tt))
                                text = "ĐÃ HOÀN TIỀN";
                        %>
                        <%= text%>
                    </span>
                </h3>


                <p><b>Địa chỉ:</b> <%= don.getDiaChi()%></p>
                <p><b>Số điện thoại:</b> <%= don.getSoDienThoai()%></p>
                <p><b>Phương thức thanh toán:</b> <%= don.getPhuongThuc()%></p>
                <p><b>Ngày đặt:</b> <%= don.getNgayDat()%></p>

                <table>
                    <tr>
                        <th>Mã sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Giá</th>
                    </tr>
                    <%
                        List<DonHangChiTiet> chiTiet = don.getChiTiet();
                        for (DonHangChiTiet ct : chiTiet) {
                    %>
                    <tr>
                        <td><%= ct.getId_sanpham()%></td>
                        <td><%= ct.getSoLuong()%></td>
                        <td><%= df.format(ct.getGia())%></td>
                    </tr>
                    <% }%>
                    <tr>
                        <td colspan="2"><b>Tổng tiền</b></td>
                        <td><b><%= df.format(don.getTongTien())%></b></td>
                    </tr>
                </table>
                <div class="action-row">
                    <div>Thành tiền: <span class="price"><%= df.format(don.getTongTien())%></span></div>

                    <%
                        if ("dadat".equalsIgnoreCase(don.getTrangthai())) {
                    %>
                    <!-- Hoàn tiền -->
                    <form method="post" action="<%= request.getContextPath()%>/DonHangServlet" style="margin:0">
                        <input type="hidden" name="action" value="refund"/>
                        <input type="hidden" name="id" value="<%= don.getIdDonHang()%>"/>
                        <button class="btn primary" onclick="return confirm('Xác nhận hoàn tiền đơn #<%= don.getIdDonHang()%>?')">
                            Hoàn tiền
                        </button>
                    </form>

                    <!-- Huỷ đơn -->
                    <form method="post" action="<%= request.getContextPath()%>/DonHangServlet" style="margin:0">
                        <input type="hidden" name="action" value="cancel"/>
                        <input type="hidden" name="id" value="<%= don.getIdDonHang()%>"/>
                        <button class="btn danger" onclick="return confirm('Huỷ đơn hàng #<%= don.getIdDonHang()%>?')">
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
               
    </body>
</html>
