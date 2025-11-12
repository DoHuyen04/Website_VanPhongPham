<%@page import="java.text.DecimalFormat"%>  
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.SanPham" %>
<html>
    <head>
        <title>Thanh toán đơn hàng</title>
        <link rel="stylesheet" href="css/kieu.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f9f9f9;
                margin: 40px;
            }
            h2 {
                text-align: center;
                color: #333;
            }
            .pay-form {
                width: 540px;
                margin: auto;
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .pay-form label {
                display: block;
                margin-top: 12px;
                font-weight: bold;
            }
            .pay-form input, .pay-form select {
                width: 100%;
                padding: 8px;
                margin-top: 6px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            .btn {
                background: #28a745;
                color: white;
                border: none;
                padding: 10px 15px;
                margin-top: 20px;
                border-radius: 5px;
                cursor: pointer;
                width: 100%;
            }
            .btn:hover {
                background: #218838;
            }
            .summary {
                margin-top: 20px;
                background: #f1f1f1;
                padding: 12px;
                border-radius: 6px;
            }
            #map {
                width: 100%;
                height: 250px;
                margin-top: 10px;
                border-radius: 8px;
            }
            .address-group input, .address-group select {
                margin-top: 6px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />
        <h2>Thanh toán đơn hàng</h2>

        <form id="payForm" action="XacNhanOTPServlet" method="post" class="pay-form">
            <label>Họ tên người nhận:</label>
            <input type="text" name="tenNguoiNhan" required>

            <label>Địa chỉ nhận hàng:</label>
            <div class="address-group">
                <input list="dsTinh" id="tinh" name="tinh" placeholder="Nhập hoặc chọn Tỉnh/Thành phố" required>
                <datalist id="dsTinh"></datalist>

                <input list="dsHuyen" id="huyen" name="huyen" placeholder="Nhập hoặc chọn Quận/Huyện" required>
                <datalist id="dsHuyen"></datalist>

                <input list="dsXa" id="xa" name="xa" placeholder="Nhập hoặc chọn Phường/Xã" required>
                <datalist id="dsXa"></datalist>

                <input type="text" name="duong" id="duong" placeholder="Tên đường, Số nhà" required>
            </div>

            <label>Tìm địa chỉ trên Google Maps (tùy chọn):</label>
            <input type="text" id="diaChi" placeholder="Nhập địa chỉ để hiển thị bản đồ...">
            <div id="map"></div>

            <label>Số điện thoại</label>
            <input type="text" name="soDienThoai" id="soDienThoai">
            <div class="error" id="soDienThoaiError"></div>

            <label>Phương thức thanh toán:</label>
            <select name="phuongThuc" id="phuongThuc" onchange="toggleTaiKhoan()" required>
                <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                <option value="Bank">Ngân hàng liên kết</option>
            </select>

            <div id="taiKhoanNganHang" style="display:none;">
                <label>Tài khoản ngân hàng (từ hồ sơ của tôi):</label>
                <%
                    String taiKhoan = (String) session.getAttribute("taiKhoanNganHang");
                    if (taiKhoan == null)
                        taiKhoan = "123456789 - Vietcombank";
                %>
                <input type="text" name="taiKhoan" value="<%= taiKhoan%>" readonly>
            </div>

            <div class="summary">
                
<%
    DecimalFormat df = new DecimalFormat("#,### VNĐ");

    // Giỏ hàng có thể là danh sách SanPham hoặc Map chứa {sanpham, soluong}
    List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");

    double tongTienHang = 0;
    double phiVanChuyen = 15000; // Phí cố định
    double tongThanhToan = 0;
%>

<% if (gioHang != null && !gioHang.isEmpty()) { %>
    <table border="1" cellpadding="8" cellspacing="0" width="100%" style="margin-top:20px; border-collapse:collapse;">
        <tr style="background-color:#f2f2f2;">
            <th>Tên sản phẩm</th>
            <th>Số lượng</th>
            <th>Đơn giá</th>
            <th>Thành tiền</th>
        </tr>
        <% 
            for (Map<String, Object> item : gioHang) {
                SanPham sp = (SanPham) item.get("sanpham");
                int soLuong = (int) item.get("soluong");
                double thanhTien = sp.getGia() * soLuong;
                tongTienHang += thanhTien;
        %>
        <tr>
            <td><%= sp.getTen() %></td>
            <td align="center"><%= soLuong %></td>
            <td align="right"><%= df.format(sp.getGia()) %></td>
            <td align="right"><%= df.format(thanhTien) %></td>
        </tr>
        <% } %>
       
    </table>

    <%
        // Tính tổng thanh toán cuối cùng
        tongThanhToan = tongTienHang + phiVanChuyen;

        // Lưu vào session (phục vụ cho bước OTP/thanh toán)
        session.setAttribute("tongTienHang", tongTienHang);
        session.setAttribute("phiVanChuyen", phiVanChuyen);
        session.setAttribute("tongThanhToan", tongThanhToan);
    %>

<% } else { %>
    <p style="color:red;">Không có sản phẩm nào trong giỏ hàng!</p>
<% } %>

                <p><b>Tổng tiền hàng:</b> <%= df.format(tongTienHang)%></p>
                <p><b>Phí vận chuyển:</b> <%= df.format(phiVanChuyen)%></p>
                <hr>
                <p><b>Tổng thanh toán:</b> <span style="color:red;"><%= df.format(tongThanhToan)%></span></p>
            </div>
<input type="hidden" name="diaChi" id="diaChiDayDu">
            <button type="button" class="btn" onclick="hienThiBanDo()">Hiển thị trên bản đồ</button>
            <button type="submit" class="btn">Xác nhận & Đặt hàng</button>
        </form>

        <!-- Google Maps -->
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCyk-_EMKXoUykzkL5nmg9OzJidA6cRW4A&libraries=places"></script>

        <!-- ====== Dữ liệu hành chính Việt Nam đầy đủ ====== -->
        <script>
              let dataVN = {};

              // 1️⃣ Đọc dữ liệu hành chính Việt Nam
              fetch('data/hanhchinhvn.json')
                      .then(res => res.json())
                      .then(data => {
                          dataVN = data;
                          const tinhSelect = document.getElementById('dsTinh');
                          Object.keys(dataVN).forEach(k => {
                              const opt = document.createElement('option');
                              opt.value = dataVN[k].name_with_type;
                              tinhSelect.appendChild(opt);
                          });
                      });

              // 2️⃣ Khi chọn tỉnh → hiện huyện
              document.getElementById('tinh').addEventListener('input', e => {
                  const tinhTen = e.target.value;
                  const huyenList = document.getElementById('dsHuyen');
                  const xaList = document.getElementById('dsXa');
                  huyenList.innerHTML = '';
                  xaList.innerHTML = '';

                  const maTinh = Object.keys(dataVN).find(
                          k => dataVN[k].name_with_type === tinhTen || dataVN[k].name === tinhTen
                  );
                  if (!maTinh)
                      return;

                  const dsHuyen = dataVN[maTinh]['quan-huyen'];
                  Object.keys(dsHuyen).forEach(k => {
                      const opt = document.createElement('option');
                      opt.value = dsHuyen[k].name_with_type;
                      huyenList.appendChild(opt);
                  });
              });

              // 3️⃣ Khi chọn huyện → hiện xã
              document.getElementById('huyen').addEventListener('input', e => {
                  const tinhTen = document.getElementById('tinh').value;
                  const huyenTen = e.target.value;
                  const xaList = document.getElementById('dsXa');
                  xaList.innerHTML = '';

                  const maTinh = Object.keys(dataVN).find(
                          k => dataVN[k].name_with_type === tinhTen || dataVN[k].name === tinhTen
                  );
                  if (!maTinh)
                      return;

                  const dsHuyen = dataVN[maTinh]['quan-huyen'];
                  const maHuyen = Object.keys(dsHuyen).find(
                          k => dsHuyen[k].name_with_type === huyenTen || dsHuyen[k].name === huyenTen
                  );
                  if (!maHuyen)
                      return;

                  const dsXa = dsHuyen[maHuyen]['xa-phuong'];
                  Object.keys(dsXa).forEach(x => {
                      const opt = document.createElement('option');
                      opt.value = dsXa[x].name_with_type;
                      xaList.appendChild(opt);
                  });
              });

              // ====== Google Map ======
              let map, marker;
              function initMap() {
                  map = new google.maps.Map(document.getElementById("map"), {
                      center: {lat: 21.0285, lng: 105.8542},
                      zoom: 13
                  });
                  marker = new google.maps.Marker({map});
              }
              window.onload = initMap;

              function hienThiBanDo() {
                  const diaChi = `${document.getElementById("duong").value}, ${document.getElementById("xa").value}, ${document.getElementById("huyen").value}, ${document.getElementById("tinh").value}, Việt Nam`;
                  const geocoder = new google.maps.Geocoder();
                  geocoder.geocode({address: diaChi}, (results, status) => {
                      if (status === "OK") {
                          map.setCenter(results[0].geometry.location);
                          map.setZoom(16);
                          marker.setPosition(results[0].geometry.location);
                      } else {
                          alert("Không tìm thấy địa chỉ: " + status);
                      }
                  });
              }

              function toggleTaiKhoan() {
                  document.getElementById("taiKhoanNganHang").style.display =
                          document.getElementById("phuongThuc").value === "Bank" ? "block" : "none";
              }
const form = document.getElementById('payForm');
        form.addEventListener('submit', function (e) {
            const tinh = document.getElementById('tinh').value.trim();
            const huyen = document.getElementById('huyen').value.trim();
            const xa = document.getElementById('xa').value.trim();
            const duong = document.getElementById('duong').value.trim();

            const phone = document.getElementById('soDienThoai').value.trim();
            const error = document.getElementById('soDienThoaiError');
            const fullAddress = `${duong}, ${xa}, ${huyen}, ${tinh}, Việt Nam`;

            document.getElementById('diaChiDayDu').value = fullAddress;
            error.textContent = '';

            if (phone === "") {
                error.textContent = 'Vui lòng nhập số điện thoại.';
                e.preventDefault();
                return;
            }
            if (!/^0\d{9,10}$/.test(phone)) {
                error.textContent = 'SĐT phải bắt đầu bằng 0 và có 10 hoặc 11 số.';
                e.preventDefault();
                return;
            }
});

        </script>
       
 <jsp:include page="footer.jsp" />
    </body>
</html>
