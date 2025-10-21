<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
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
            <input type="hidden" name="action" value="dangky">

            <label>Tên đăng nhập</label>
            <input type="text" name="tenDangNhap" id="tenDangNhap">

            <label>Mật khẩu</label>
            <input type="password" name="matKhau" id="matKhau">

            <label>Xác nhận mật khẩu</label>
            <input type="password" name="xacNhanMatKhau" id="xacNhanMatKhau">

            <label>Họ tên</label>
            <input type="text" name="hoTen" id="hoTen">

            <label>Giới tính</label><br>
            <input type="radio" name="gioiTinh" value="Nam" checked> Nam
            <input type="radio" name="gioiTinh" value="Nữ"> Nữ
            <br><br>

            <label>Ngày sinh</label>
            <input type="date" name="ngaySinh" id="ngaySinh">

            <label>Email</label>
            <input type="text" name="email" id="email">

            <label>Số điện thoại</label>
            <input type="text" name="soDienThoai" id="soDienThoai">

            <button type="submit">Đăng ký</button>
        </form>
        </div>
    </div>

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

            if (!valid) e.preventDefault();
        });
    </script>
</body>
</html>
