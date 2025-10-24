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

                <button type="submit">Đăng ký</button>
            </form>
        </div>
    </div>
</body>
</html>
