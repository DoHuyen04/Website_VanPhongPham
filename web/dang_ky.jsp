<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<<<<<<< HEAD
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>
    <link rel="stylesheet" href="css/kieu.css">
</head>
<body>
    <div class="register-page">
        <div class="register-container">
            <h2>Đăng ký tài khoản</h2>

            <% if (request.getAttribute("error") != null) { %>
                <p style="color:red;"><%= request.getAttribute("error") %></p>
            <% } %>

            <form action="DangKyServlet" method="post" id="registerForm">
                <label>Tên đăng nhập</label>
                <input type="text" name="tenDangNhap" id="tenDangNhap">

                <label>Mật khẩu</label>
                <input type="password" name="matKhau" id="matKhau">

                <label>Xác nhận mật khẩu</label>
                <input type="password" name="xacNhanMatKhau" id="xacNhanMatKhau">

                <label>Họ tên</label>
                <input type="text" name="hoTen" id="hoTen">

                <label>Email</label>
                <input type="text" name="email" id="email">

                <label>Số điện thoại</label>
                <input type="text" name="soDienThoai" id="soDienThoai">
=======
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký tài khoản</title>
        <link rel="stylesheet" href="css/kieu.css">
    </head>
    <body>
        <div class="register-page">
            <div class="register-container">
              <h2>Đăng ký tài khoản</h2>
                <form action="nguoidung" method="post" id="registerForm">
                    <input type="hidden" name="hanhDong" value="dangky">

                    <label>Tên đăng nhập</label>
                    <input type="text" name="tenDangNhap" id="tenDangNhap">
                    <div class="error" id="tenDangNhapError"></div>

                    <label>Mật khẩu</label>
                    <input type="password" name="matKhau" id="matKhau">
                    <div class="error" id="matKhauError"></div>

                    <label>Xác nhận mật khẩu</label>
                    <input type="password" name="xacNhanMatKhau" id="xacNhanMatKhau">
                    <div class="error" id="xacNhanMatKhauError"></div>

                    <label>Họ tên</label>
                    <input type="text" name="hoTen" id="hoTen">

                    <!-- 🔹 Giới tính -->
                    <label>Giới tính</label>
                    <select name="gioiTinh" id="gioiTinh">
                        <option value="">-- Chọn giới tính --</option>
                        <option value="Nam">Nam</option>
                        <option value="Nữ">Nữ</option>
                        <option value="Khác">Khác</option>
                    </select>
                    <div class="error" id="gioiTinhError"></div>

                    <!-- 🔹 Ngày sinh -->
                    <label>Ngày sinh</label>
                    <input type="date" name="ngaySinh" id="ngaySinh">
                    <div class="error" id="ngaySinhError"></div>
>>>>>>> origin/huyenpea

                    <label>Email</label>
                    <input type="text" name="email" id="email">
                    <div class="error" id="emailError"></div>

                    <label>Số điện thoại</label>
                    <input type="text" name="soDienThoai" id="soDienThoai">
                    <div class="error" id="soDienThoaiError"></div>

                    <button type="submit">Đăng ký</button>
                </form>
            </div>
        </div>
<<<<<<< HEAD
    </div>
</body>
</html>
=======

        <script>
            const form = document.getElementById('registerForm');

            form.addEventListener('submit', function (e) {
                let valid = true;

                // Reset lỗi
                document.querySelectorAll('.error').forEach(el => el.textContent = '');

                // Kiểm tra tên đăng nhập
                const username = document.getElementById('tenDangNhap').value.trim();
                if (username.length < 6 || username.length > 20 || /\s/.test(username) || /[^a-zA-Z0-9]/.test(username)) {
                    document.getElementById('tenDangNhapError').textContent = 'Tên đăng nhập từ 6-20 ký tự, không khoảng trắng hoặc ký tự đặc biệt.';
                    valid = false;
                }

                // Kiểm tra mật khẩu
                const password = document.getElementById('matKhau').value;
                if (!/[A-Z]/i.test(password) || !/[0-9]/.test(password) || !/[^a-zA-Z0-9]/.test(password)) {
                    document.getElementById('matKhauError').textContent = 'Mật khẩu phải có chữ, số và ký tự đặc biệt.';
                    valid = false;
                }

                // Xác nhận mật khẩu
                const confirmPassword = document.getElementById('xacNhanMatKhau').value;
                if (password !== confirmPassword) {
                    document.getElementById('xacNhanMatKhauError').textContent = 'Mật khẩu xác nhận không khớp.';
                    valid = false;
                }

                // Kiểm tra email
                const email = document.getElementById('email').value.trim();
                if (!email.endsWith('@gmail.com')) {
                    document.getElementById('emailError').textContent = 'Email phải có đuôi @gmail.com';
                    valid = false;
                }

                // Kiểm tra số điện thoại
                const phone = document.getElementById('soDienThoai').value.trim();
                if (!/^0\d{9}$/.test(phone)) {
                    document.getElementById('soDienThoaiError').textContent = 'SĐT phải có 10 số và bắt đầu bằng 0.';
                    valid = false;
                }

                // 🔹 Kiểm tra giới tính
                const gioiTinh = document.getElementById("gioiTinh").value;
                if (gioiTinh === "") {
                    document.getElementById("gioiTinhError").textContent = "Vui lòng chọn giới tính";
                    valid = false;
                }

                // 🔹 Kiểm tra ngày sinh
                const ngaySinh = document.getElementById("ngaySinh").value;
                if (ngaySinh === "") {
                    document.getElementById("ngaySinhError").textContent = "Vui lòng chọn ngày sinh";
                    valid = false;
                }

                // Ngăn form gửi đi nếu có lỗi
                if (!valid) e.preventDefault();
            });
        </script>
    </body>
</html>
>>>>>>> origin/huyenpea
