
</head>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký tài khoản</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: linear-gradient(to right, #cce8ff, #90c8ff);

                display: flex;
                justify-content: center;
                align-items: flex-start;   /* căn từ trên xuống */

                min-height: 100vh;         /* cho phép cuộn ngoài */
                padding: 40px 0;           /* cách trên dưới */
            }

            /* KHUNG TRẮNG LỚN – KHÔNG CÒN THANH CUỘN TRONG */
            .container {
                width: 520px;              /* rộng hơn → form không dài */
                min-height: 85vh;          /* khung cao → chứa được hết */
                background: #fff;
                padding: 40px;
                border-radius: 22px;
                box-shadow: 0 6px 22px rgba(0,0,0,0.18);

                overflow: visible !important; /* bỏ cuộn trong */
            }


            /* TIÊU ĐỀ */
            h2 {
                text-align: center;
                margin-top: 0;
                color: #003366;
            }

            /* INPUT + SELECT */
            input, select {
                width: 100%;
                padding: 12px;
                margin: 6px 0 16px 0;
                font-size: 15px;
                border-radius: 10px;
                border: 1px solid #d0d7e2;
                outline: none;
            }

            input:focus, select:focus {
                border-color: #4b8dff;
                box-shadow: 0 0 6px rgba(75, 141, 255, 0.4);
            }

            /* NÚT */
            .btn {
                width: 100%;
                background: #ffcc00;
                color: #000;
                font-size: 16px;
                font-weight: bold;
                padding: 12px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
            }

            .btn:hover {
                background: #e6b800;
            }

            /* LINK */
            .bottom-text {
                text-align: center;
                margin-top: 10px;
            }

            a {
                color: #005bbb;
                font-weight: bold;
            }

        </style>
        <link rel="stylesheet" href="css/kieu.css">
    </head>
    <body>
        <div class="register-page">
            <div class="register-container">
                <h2>Đăng ký tài khoản</h2>
                <%
                    String thongBao = (String) request.getAttribute("thongBao");
                    if (thongBao != null) {
                %>
                <p style="color:red; text-align:center;"><%= thongBao%></p>
                <%
                    }
                %>

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
                    <label>Email</label>
                    <input type="text" name="email" id="email">
                    <div class="error" id="emailError"></div>

                    <label>Số điện thoại</label>
                    <input type="text" name="soDienThoai" id="soDienThoai">
                    <div class="error" id="soDienThoaiError"></div>

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

// Danh sách đuôi email hợp lệ
                const validDomains = ['@gmail.com', '@sv.uneti.edu.vn', '.com'];

// Kiểm tra email có kết thúc bằng 1 trong các đuôi hợp lệ
                const isValidEmail = validDomains.some(domain => email.endsWith(domain));

                if (!isValidEmail) {
                    document.getElementById('emailError').textContent =
                            'Email phải có đuôi hợp lệ: ' + validDomains.join(', ');
                    valid = false;
                } else {
                    document.getElementById('emailError').textContent = '';
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
                if (!valid)
                    e.preventDefault();
            });
        </script>
    </body>
</html>