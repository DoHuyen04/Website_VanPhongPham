
<%@page import="model.SanPham"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>  
<%@page import="model.TKNganHang"%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Thanh toán đơn hàng</title>
        <%
            // Không cần: HttpSession session = request.getSession();
            @SuppressWarnings(
                    
            
            "unchecked")
    List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");

            List<Map<String, Object>> gioHangChon = (List<Map<String, Object>>) session.getAttribute("gioHangChon");

            if (gioHangChon == null) {
                gioHangChon = new ArrayList<>();
                if (gioHang != null) {
                    for (Map<String, Object> item : gioHang) {
                        item.put("daChon", true);
                        gioHangChon.add(item);
                    }
                    session.setAttribute("gioHangChon", gioHangChon);
                }
            }

            double tongTienHang = 0;
            double phiVanChuyen = 15000;
            java.text.DecimalFormat df = new java.text.DecimalFormat("#,### VNĐ");

            // ==========================
            // 🔹 LẤY DANH SÁCH ĐỊA CHỈ USER
            // ==========================
            // Danh sách địa chỉ đã truyền từ ThanhToanServlet
            List<model.DiaChi> dsDiaChi = (List<model.DiaChi>) request.getAttribute("dsDiaChi");

            model.DiaChi diaChiMacDinh = null;

            if (dsDiaChi != null && !dsDiaChi.isEmpty()) {
                for (model.DiaChi d : dsDiaChi) {
                    if (d.isMacDinh()) {
                        diaChiMacDinh = d;
                        break;
                    }
                }
                // Nếu không có mặc định → lấy cái đầu tiên
                if (diaChiMacDinh == null) {
                    diaChiMacDinh = dsDiaChi.get(0);
                }
            }
        %>

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
            /* Thanh gạt CSS */
            .switch {
                position: relative;
                display: inline-block;
                width: 50px;
                height: 26px;
            }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: .4s;
                border-radius: 26px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #28a745;
            }

            input:checked + .slider:before {
                transform: translateX(24px);
            }
            .dc-macdinh{
                magin-left : auto;
            }
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />
        <h2>Thanh toán đơn hàng</h2>

        <form id="payForm" action="${pageContext.request.contextPath}/XacNhanOTPServlet" method="post" class="pay-form">
            <input type="hidden" name="xacNhan" value="1">
            <%-- Gửi danh sách sản phẩm đã chọn để servlet tính lại --%>
            <% for (Map<String, Object> item : gioHangChon) {
                    SanPham sp = (SanPham) item.get("sanpham");%>
            <input type="hidden" name="chonSP" value="<%= sp.getId_sanpham()%>">
            <% }%>

            <!-- HỌ TÊN NGƯỜI NHẬN -->
            <label>Họ tên người nhận:</label>
            <input type="text" name="tenNguoiNhan" id="tenNguoiNhan" required>

            <!-- CÁC Ô NHẬP THÔNG TIN ĐỊA CHỈ / NGƯỜI NHẬN -->

            <label>Địa chỉ nhận hàng:</label>
            <div class="address-group">
                <label>Tỉnh/Thành phố:</label>
                <input list="dsTinh" id="tinh" name="tinh" placeholder="Nhập hoặc chọn Tỉnh/Thành phố" required>
                <datalist id="dsTinh"></datalist>
                <label>Huyện/Quận:</label>
                <input list="dsHuyen" id="huyen" name="huyen" placeholder="Nhập hoặc chọn Quận/Huyện" required>
                <datalist id="dsHuyen"></datalist>
                <label>Xã/Phường:</label>
                <input list="dsXa" id="xa" name="xa" placeholder="Nhập hoặc chọn Phường/Xã" required>
                <datalist id="dsXa"></datalist>
                <label>Tên đường , số nhà:</label>
                <input type="text" name="duong" id="duong" placeholder="Tên đường, Số nhà" required>
            </div>
            <div  class ="dc-macdinh" style="margin:10px 0 15px;">
                <span style="font-weight:bold;">Mặc định</span>

                <label class="switch" style="margin-left:10px;">
                    <input type="checkbox"
                           id="toggleAddressMode"
                           <%= (dsDiaChi != null && !dsDiaChi.isEmpty()) ? "checked" : ""%> >
                    <span class="slider"></span>
                </label>
            </div>

            <!-- CHẾ ĐỘ ĐỊA CHỈ -->

            <% if (dsDiaChi != null && !dsDiaChi.isEmpty()) { %>
            <div id="savedAddressBox" style="margin-bottom:10px;">
                <select name="selectedDiaChiId" id="selectedDiaChiId"
                        style="width:100%; padding:8px; border:1px solid #ccc; border-radius:5px; margin-top:5px;">
                    <% for (model.DiaChi d : dsDiaChi) {%>
                    <option value="<%= d.getId()%>"
                            data-hotennhan="<%= d.getHoTen()%>"
                            data-sdt="<%= d.getSoDienThoai()%>"
                            data-tinh="<%= d.getTinhThanh()%>"
                            data-huyen="<%= d.getQuanHuyen()%>"
                            data-xa="<%= d.getXaPhuong()%>"
                            data-duong="<%= d.getDiaChiDuong()%>"
                            <%= (diaChiMacDinh != null && diaChiMacDinh.getId() == d.getId()) ? "selected" : ""%>>
                        <%= d.isMacDinh() ? "[Mặc định] " : ""%>
                        <%= d.getHoTen()%> - <%= d.getDiaChiDuong()%>, <%= d.getXaPhuong()%>, <%= d.getQuanHuyen()%>, <%= d.getTinhThanh()%>
                    </option>
                    <% } %>
                </select>
            </div>
            <% } else { %>
            <p style="font-size:13px; color:#777;">Bạn chưa có địa chỉ nào trong hồ sơ. Vui lòng nhập địa chỉ mới.</p>
            <% }%>

            <label>Tìm địa chỉ trên Google Maps (tùy chọn):</label>
            <input type="text" id="diaChiMap" placeholder="Nhập địa chỉ để hiển thị bản đồ...">
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
                <label>Tài khoản ngân hàng:</label>

                <%
                    // Lấy danh sách tài khoản ngân hàng đã được servlet truyền xuống
                    List<TKNganHang> dsTk = (List<TKNganHang>) request.getAttribute("dsTaiKhoanNganHang");
                    TKNganHang macDinh = null;

                    if (dsTk != null && !dsTk.isEmpty()) {
                        // Ưu tiên tìm tài khoản được đặt MẶC ĐỊNH
                        for (TKNganHang b : dsTk) {
                            if (b.isMacDinh()) {
                                macDinh = b;
                                break;
                            }
                        }
                        // Nếu không có cái nào macDinh = true thì lấy cái đầu tiên
                        if (macDinh == null) {
                            macDinh = dsTk.get(0);
                        }
                    }
                %>

                <% if (dsTk == null || dsTk.isEmpty()) {%>
                <p style="color:#666; font-size:14px; margin-top:6px;">
                    Bạn chưa liên kết tài khoản ngân hàng nào.
                    <a href="<%= request.getContextPath()%>/nguoidung?hanhDong=hoso&tab=tknh">
                        Bấm vào đây để thêm.
                    </a>
                </p>
                <% } else { %>
                <select name="idTaiKhoanNganHang"
                        id="idTaiKhoanNganHang"
                        style="margin-top:6px; width:100%; padding:8px; border:1px solid #ccc; border-radius:5px;">
                    <% for (TKNganHang b : dsTk) {%>
                    <option value="<%= b.getIdTkNganHang()%>"
                            <%= (macDinh != null && macDinh.getIdTkNganHang() == b.getIdTkNganHang()) ? "selected" : ""%>>
                        <%= b.getTenNganHang()%> - <%= b.getSoTaiKhoan()%> ( <%= b.getChuTaiKhoan()%> )
                    </option>
                    <% } %>
                </select>
                <% } %>
            </div>


            <div class="summary">

                <h3>Sản phẩm thanh toán</h3>

                <% if (gioHangChon.isEmpty()) { %>
                <p style="color:red; font-weight:bold;">Không có sản phẩm nào được chọn để thanh toán.</p>
                <% } else { %>
                <table border="1" cellpadding="5" cellspacing="0" width="100%">
                    <tr>
                        <th>STT</th>
                        <th>Sản phẩm</th>
                        <th>SL</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                    <%
                        int stt = 1;

                        for (Map<String, Object> item : gioHangChon) {
                            SanPham sp = (SanPham) item.get("sanpham");
                            int sl = (Integer) item.get("soluong");
                            double thanhTien = sp.getGia() * sl;
                            tongTienHang += thanhTien;
                    %>
                    <tr>
                        <td>
                            <%= stt++%>
                        </td>

                        <td><%=sp.getTen()%></td>
                        <td><%=sl%></td>
                        <td><%=df.format(sp.getGia())%></td>
                        <td><%=df.format(thanhTien)%></td>
                    </tr>
                    <% }%>
                </table>

                <% }%>

                <p><b>Tổng tiền hàng:</b> <%=df.format(tongTienHang)%></p>
                <p><b>Phí vận chuyển:</b> <%=df.format(phiVanChuyen)%></p>

                <p><b>Tổng thanh toán:</b> <span style="color:red;"><%=df.format(tongTienHang + phiVanChuyen)%></span></p>
            </div>

            <input type="hidden" name="diaChi" id="diaChiDayDu">
            <button type="button" class="btn" onclick="hienThiBanDo()">Hiển thị trên bản đồ</button>
            <button type="submit" class="btn">Xác nhận & Đặt hàng</button>
        </form>

        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCyk-_EMKXoUykzkL5nmg9OzJidA6cRW4A&libraries=places"></script>

        <script>
                let dataVN = {};
                // ====== ĐỊA CHỈ: chọn từ hồ sơ hoặc nhập mới ======
                function setAddressInputsReadonly(isReadonly) {
                    var ids = ["tenNguoiNhan", "soDienThoai", "tinh", "huyen", "xa", "duong"];
                    ids.forEach(function (id) {
                        var el = document.getElementById(id);
                        if (el) {
                            el.readOnly = isReadonly;
                        }
                    });
                }

                function fillAddressFromSaved() {
                    var select = document.getElementById("selectedDiaChiId");
                    if (!select)
                        return;

                    var opt = select.options[select.selectedIndex];
                    if (!opt)
                        return;

                    // Lấy dữ liệu từ option và đổ vào các ô input
                    document.getElementById("tenNguoiNhan").value = opt.dataset.hotennhan || "";
                    document.getElementById("soDienThoai").value = opt.dataset.sdt || "";
                    document.getElementById("tinh").value = opt.dataset.tinh || "";
                    document.getElementById("huyen").value = opt.dataset.huyen || "";
                    document.getElementById("xa").value = opt.dataset.xa || "";
                    document.getElementById("duong").value = opt.dataset.duong || "";

                    // Dùng địa chỉ từ hồ sơ thì khóa lại cho đỡ sửa nhầm
                    setAddressInputsReadonly(true);
                }

                function updateAddressModeUI() {
                    var modeSaved = document.querySelector('input[name="addressMode"][value="saved"]');
                    var modeNew = document.querySelector('input[name="addressMode"][value="new"]');
                    var boxSaved = document.getElementById("savedAddressBox");

                    if (modeSaved && modeSaved.checked && boxSaved) {
                        // Đang chọn "Chọn địa chỉ từ hồ sơ"
                        boxSaved.style.display = "block";
                        fillAddressFromSaved();          // auto fill từ địa chỉ mặc định / đã chọn
                    } else {
                        // Đang chọn "Nhập địa chỉ khác"
                        if (boxSaved)
                            boxSaved.style.display = "none";

                        // Cho phép nhập mới
                        setAddressInputsReadonly(false);

                        // XÓA CÁC Ô ĐỊA CHỈ cũ để người dùng nhập lại bằng hanhchinhvn.json
                        ["tinh", "huyen", "xa", "duong"].forEach(function (id) {
                            var el = document.getElementById(id);
                            if (el)
                                el.value = "";
                        });

                    }
                }

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
                function capNhatDiaChi() {
                    const duong = document.getElementById('duong').value;
                    const xa = document.getElementById('xa').value;
                    const huyen = document.getElementById('huyen').value;
                    const tinh = document.getElementById('tinh').value;
                    document.getElementById('diaChiDayDu').value = `${duong}, ${xa}, ${huyen}, ${tinh}, Việt Nam`;
                }
                function toggleTaiKhoan() {
                    document.getElementById("taiKhoanNganHang").style.display =
                            document.getElementById("phuongThuc").value === "Bank" ? "block" : "none";
                }
                const form = document.getElementById('payForm');
                form.addEventListener('submit', function (e) {
                    capNhatDiaChi();
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
                    // 🔹 Kiểm tra phương thức thanh toán & tài khoản ngân hàng
                    const phuongThuc = document.getElementById('phuongThuc').value;
                    const dsTkSelect = document.getElementById('idTaiKhoanNganHang');
                    if (phuongThuc === 'Bank') {
                        // Nếu chọn Ngân hàng liên kết nhưng không có select (hoặc không có option nào)
                        if (!dsTkSelect || dsTkSelect.options.length === 0) {
                            alert('Bạn chưa có tài khoản ngân hàng liên kết. Vui lòng thêm trong "Hồ sơ của tôi" trước khi thanh toán bằng Ngân hàng liên kết.');
                            e.preventDefault();
                            return;
                        }

                        // Nếu có select nhưng chưa chọn giá trị (phòng hờ)
                        if (!dsTkSelect.value) {
                            alert('Vui lòng chọn một tài khoản ngân hàng để thanh toán.');
                            e.preventDefault();
                            return;
                        }
                    }
                });
                function capNhatChonSP() {
                    const formData = new FormData();
                    document.querySelectorAll('.chonSP').forEach(cb => {
                        if (cb.checked) {
                            // append value (id)
                            formData.append('chonSP', cb.value);
                        }
                    });
                    fetch('CapNhatGioHangServlet', {
                        method: 'POST',
                        body: formData
                    })
                            .then(resp => resp.json())
                            .then(data => {
                                // optional: console.log(data);
                                location.reload(); // tải lại để JSP lấy gioHangChon mới
                            })
                            .catch(err => console.error(err));
                }

                // Gắn sự kiện cho radio & select sau khi DOM đã có
                document.addEventListener('DOMContentLoaded', function () {
                    // radio chọn chế độ địa chỉ
                    var radiosAddress = document.querySelectorAll('input[name="addressMode"]');
                    radiosAddress.forEach(function (r) {
                        r.addEventListener("change", updateAddressModeUI);
                    });

                    // select địa chỉ đã lưu
                    var selectSaved = document.getElementById("selectedDiaChiId");
                    if (selectSaved) {
                        selectSaved.addEventListener("change", fillAddressFromSaved);
                    }

                    // Khởi tạo trạng thái ban đầu (ưu tiên địa chỉ mặc định nếu có)
                    updateAddressModeUI();

                    // (giữ logic cũ) gắn sự kiện cho checkbox chọn sản phẩm nếu trên trang có dùng
                    document.querySelectorAll('.chonSP').forEach(cb => {
                        cb.addEventListener('change', capNhatChonSP);
                    });
                });
                document.querySelectorAll('.chonSP').forEach(cb => {
                    cb.addEventListener('change', capNhatChonSP);
                })
                        ;
// =================== SWITCH ĐỊA CHỈ ===================
                document.getElementById("toggleAddressMode").addEventListener("change", function () {
                    let isUseSaved = this.checked;

                    if (isUseSaved) {
                        // Nếu bật → dùng địa chỉ hồ sơ
                        let savedBox = document.getElementById("savedAddressBox");
                        if (savedBox)
                            savedBox.style.display = "block";

                        fillAddressFromSaved(); // Tự động đổ dữ liệu vào
                        setAddressInputsReadonly(true);

                    } else {
                        // Tắt → Nhập địa chỉ mới
                        let savedBox = document.getElementById("savedAddressBox");
                        if (savedBox)
                            savedBox.style.display = "none";

                        setAddressInputsReadonly(false);

                        // Xóa các trường địa chỉ cũ
                        ["tenNguoiNhan", "soDienThoai", "tinh", "huyen", "xa", "duong"].forEach(id => {
                            let el = document.getElementById(id);
                            if (el)
                                el.value = "";
                        });
                    }
                });

        </script>
        <jsp:include page="footer.jsp" />
    </body>
</html>