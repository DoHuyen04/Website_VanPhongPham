<%-- 
    Document   : quen_mat_khau
    Created on : Oct 14, 2025, 10:35:26 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="css/kieu.css">
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <h2>Quên mật khẩu</h2>
            <form action="guiMaXacThuc" method="post">
                <label for="email">Nhập email đã đăng ký</label>
                <input type="text" id="email" name="email" required>
                <div class="error"><%= request.getAttribute("loiEmail") != null ? request.getAttribute("loiEmail") : "" %></div>

                <button type="submit">Gửi mã xác thực</button>
            </form>
        </div>
    </div>
</body>
</html>
