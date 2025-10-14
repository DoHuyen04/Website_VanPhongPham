<%-- 
    Document   : xac_thuc_ma
    Created on : Oct 14, 2025, 10:35:50 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác thực mã</title>
    <link rel="stylesheet" href="css/kieu.css">
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <h2>Xác thực mã</h2>
            <form action="kiemTraMaXacThuc" method="post">
                <label for="maXacThuc">Nhập mã xác thực</label>
                <input type="text" id="maXacThuc" name="maXacThuc" required>
                <div class="error"><%= request.getAttribute("loiMa") != null ? request.getAttribute("loiMa") : "" %></div>

                <button type="submit">Xác thực</button>
            </form>

            <form action="guiLaiMa" method="post">
                <button type="submit" class="resend-btn">Gửi lại mã</button>
            </form>
        </div>
    </div>
</body>
</html>
