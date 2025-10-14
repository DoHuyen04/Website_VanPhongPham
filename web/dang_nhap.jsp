<%-- 
    Document   : dang_nhap
    Created on : Oct 11, 2025, 1:55:50 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="css/kieu.css">
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <h2>Đăng nhập</h2>
            <form action="nguoidung" method="post">
                <input type="hidden" name="hanhDong" value="dangnhap">

                <label for="tenDangNhap">Tên đăng nhập</label>
                <input type="text" id="tenDangNhap" name="tenDangNhap" required>
                <div class="error"><%= request.getAttribute("loiTenDangNhap") != null ? request.getAttribute("loiTenDangNhap") : "" %></div>

                <label for="matKhau">Mật khẩu</label>
                <div class="password-wrapper">
                    <input type="password" id="matKhau" name="matKhau" required>
                    <span class="toggle-password" onclick="togglePassword()">👁</span>
                </div>
                <div class="error"><%= request.getAttribute("loiMatKhau") != null ? request.getAttribute("loiMatKhau") : "" %></div>

                <button type="submit">Đăng nhập</button>
            </form>

            <div class="login-links">
                <a href="quen_mat_khau.jsp">Quên mật khẩu?</a>
                <a href="dang_ky.jsp">Đăng ký</a>
            </div>
        </div>
    </div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById("matKhau");
        const icon = document.querySelector(".toggle-password");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.textContent = "🙈";
        } else {
            passwordInput.type = "password";
            icon.textContent = "👁";
        }
    }
</script>
</body>
</html>
