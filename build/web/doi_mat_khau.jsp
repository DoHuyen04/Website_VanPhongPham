<%-- 
    Document   : doi_mat_khau
    Created on : Oct 14, 2025, 10:36:11 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>
    <link rel="stylesheet" href="css/kieu.css">
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <h2>Đổi mật khẩu</h2>
            <form action="capNhatMatKhau" method="post">
                <label for="matKhauMoi">Mật khẩu mới</label>
                <div class="password-wrapper">
                    <input type="password" id="matKhauMoi" name="matKhauMoi" required>
                    <span class="toggle-password" onclick="toggleNewPassword()">👁</span>
                </div>

                <label for="xacNhanMatKhauMoi">Xác nhận mật khẩu</label>
                <input type="password" id="xacNhanMatKhauMoi" name="xacNhanMatKhauMoi" required>
                <div class="error"><%= request.getAttribute("loiMatKhauMoi") != null ? request.getAttribute("loiMatKhauMoi") : "" %></div>

                <button type="submit">Cập nhật mật khẩu</button>
            </form>
        </div>
    </div>

<script>
    function toggleNewPassword() {
        const input = document.getElementById("matKhauMoi");
        const icon = document.querySelector(".toggle-password");
        if (input.type === "password") {
            input.type = "text";
            icon.textContent = "🙈";
        } else {
            input.type = "password";
            icon.textContent = "👁";
        }
    }
</script>
</body>
</html>
