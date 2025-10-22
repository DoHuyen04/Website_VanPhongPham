<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Lấy tổng tiền từ tham số hoặc session
    double tongTienHang = 0;
    try {
        tongTienHang = Double.parseDouble(request.getParameter("tongTien"));
    } catch (Exception e) {
        // Nếu chưa có thì thử lấy từ session (VD: khi quay lại trang)
        if (session.getAttribute("tongTien") != null)
            tongTienHang = (double) session.getAttribute("tongTien");
    }

    double phiVanChuyen = 15000;
    double tongThanhToan = tongTienHang + phiVanChuyen;

    // Lưu lại vào session để dùng cho bước OTP sau
    session.setAttribute("tongTien", tongThanhToan);
%>
<html>
<head>
  <title>Thanh toán đơn hàng</title>
  <link rel="stylesheet" href="css/kieu.css">
</head>
<body>
<h2>Thanh toán đơn hàng</h2>

<form action="XacNhanOTPServlet" method="post" class="pay-form">
  <label>Họ tên người nhận:</label>
  <input type="text" name="tenNguoiNhan" required>

  <label>Địa chỉ nhận hàng:</label>
  <div class="address-group">
    <select name="tinh" id="tinh" required>
      <option value="">-- Chọn Tỉnh/Thành phố --</option>
      <option value="Hà Nội">Hà Nội</option>
      <option value="TP Hồ Chí Minh">TP Hồ Chí Minh</option>
      <option value="Đà Nẵng">Đà Nẵng</option>
      <option value="Hải Phòng">Hải Phòng</option>
      <option value="Cần Thơ">Cần Thơ</option>
    </select>

    <select name="huyen" id="huyen" required>
      <option value="">-- Chọn Quận/Huyện --</option>
    </select>

    <select name="xa" id="xa" required>
      <option value="">-- Chọn Phường/Xã --</option>
    </select>

    <input type="text" name="duong" placeholder="Tên đường, Số nhà" required>
  </div>

  <label>Số điện thoại:</label>
  <input type="text" name="sdt" required>

  <label>Phương thức thanh toán:</label>
  <select name="phuongThuc" id="phuongThuc" onchange="toggleTaiKhoan()" required>
    <option value="COD">Thanh toán khi nhận hàng (COD)</option>
    <option value="Bank">Ngân hàng liên kết</option>
  </select>

  <div id="taiKhoanNganHang" style="display:none;">
    <label>Tài khoản ngân hàng (từ hồ sơ của tôi):</label>
    <%
      // Giả sử trong Session có thông tin tài khoản ngân hàng của người dùng
      String taiKhoan = (String) session.getAttribute("taiKhoanNganHang");
      if(taiKhoan == null) taiKhoan = "123456789 - Vietcombank";
    %>
    <input type="text" name="taiKhoan" value="<%= taiKhoan %>" readonly>
  </div>

  <div class="summary">
    <p><b>Tổng tiền hàng:</b> <%= String.format("%,.0f", tongTienHang) %> VNĐ</p>
    <p><b>Phí vận chuyển:</b> <%= String.format("%,.0f", phiVanChuyen) %> VNĐ</p>
    <p><b>Tổng thanh toán:</b> <%= String.format("%,.0f", tongThanhToan) %> VNĐ</p>
  </div>

  <button type="submit" class="btn">Xác nhận & Đặt hàng</button>
</form>

<script>
  function toggleTaiKhoan(){
    const v = document.getElementById("phuongThuc").value;
    document.getElementById("taiKhoanNganHang").style.display = (v==="Bank")?"block":"none";
  }

  // Dữ liệu mẫu mô phỏng danh sách quận/huyện và xã/phường
  const data = {
    "Hà Nội": {
      "Ba Đình": ["Phúc Xá", "Trúc Bạch", "Vĩnh Phúc"],
      "Hoàn Kiếm": ["Hàng Bạc", "Hàng Đào", "Lý Thái Tổ"]
    },
    "TP Hồ Chí Minh": {
      "Quận 1": ["Bến Nghé", "Bến Thành", "Nguyễn Thái Bình"],
      "Quận 3": ["Võ Thị Sáu", "Phường 7", "Phường 8"]
    },
    "Đà Nẵng": {
      "Hải Châu": ["Phước Ninh", "Thạch Thang", "Hòa Cường Bắc"],
      "Thanh Khê": ["An Khê", "Vĩnh Trung"]
    }
  };

  const tinh = document.getElementById("tinh");
  const huyen = document.getElementById("huyen");
  const xa = document.getElementById("xa");

  tinh.addEventListener("change", () => {
    huyen.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
    xa.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    if(tinh.value && data[tinh.value]) {
      Object.keys(data[tinh.value]).forEach(q => {
        const opt = document.createElement("option");
        opt.value = q;
        opt.textContent = q;
        huyen.appendChild(opt);
      });
    }
  });

  huyen.addEventListener("change", () => {
    xa.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    if(tinh.value && huyen.value && data[tinh.value][huyen.value]) {
      data[tinh.value][huyen.value].forEach(p => {
        const opt = document.createElement("option");
        opt.value = p;
        opt.textContent = p;
        xa.appendChild(opt);
      });
    }
  });
</script>
</body>
</html>
