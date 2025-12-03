<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <style>
        /* Reset cơ bản */
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: Arial, sans-serif; }

        body {
            background: linear-gradient(to right, #4e54c8, #8f94fb);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-page {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }

        .login-container {
            background: #fff;
            border-radius: 12px;
            padding: 30px 35px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: #4e54c8;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }

        input, select {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            transition: border 0.3s;
        }

        input:focus, select:focus {
            border-color: #4e54c8;
            outline: none;
        }

        .password-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 18px;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #4e54c8;
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }

        button:hover {
            background: #3b3f9a;
        }

        .login-links {
            text-align: center;
            margin-top: 15px;
        }

        .login-links a {
            color: #4e54c8;
            text-decoration: none;
            margin: 0 10px;
            font-size: 14px;
        }

        .error, .error-msg {
            color: #b71c1c;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .success-msg {
            color: #155724;
            background: #d4edda;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 10px;
            text-align: center;
        }

        .warning-msg {
            color: #856404;
            background: #fff3cd;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="login-page">
    <div class="login-container">
        <h2>Đăng nhập</h2>

        <% 
            String notLoggedIn = request.getParameter("error");
            if ("notloggedin".equals(notLoggedIn)) {
        %>
            <div class="warning-msg">⚠️ Vui lòng đăng nhập để thêm sản phẩm.</div>
        <% } %>

        <% 
            String error = (String) request.getAttribute("error");
            String success = request.getParameter("dangky");
            String roleMsg = (String) request.getAttribute("roleMsg");

            if(error != null) { 
        %>
            <div class="error-msg"><%= error %></div>
        <% } else if("thanhcong".equals(success)) { %>
            <div class="success-msg">Đăng ký thành công! Vui lòng đăng nhập.</div>
        <% } else if(roleMsg != null) { %>
            <div class="success-msg">Đăng nhập thành công! Vai trò: <strong><%= roleMsg %></strong></div>
        <% } %>

        <form action="nguoidung" method="post">
            <input type="hidden" name="hanhDong" value="dangnhap">

            <label for="tenDangNhap">Tên đăng nhập</label>
            <input type="text" id="tenDangNhap" name="tenDangNhap" required
                   value="<%= request.getParameter("tenDangNhap") != null ? request.getParameter("tenDangNhap") : "" %>">
            <div class="error"><%= request.getAttribute("loiTenDangNhap") != null ? request.getAttribute("loiTenDangNhap") : "" %></div>

            <label for="matKhau">Mật khẩu</label>
            <div class="password-wrapper">
                <input type="password" id="matKhau" name="matKhau" required>
                <span class="toggle-password" onclick="togglePassword()">👁</span>
            </div>
            <div class="error"><%= request.getAttribute("loiMatKhau") != null ? request.getAttribute("loiMatKhau") : "" %></div>

            <label for="role">Vai trò</label>
            <select name="role" id="role" required>
                <option value="USER" <%= "USER".equals(request.getParameter("role")) ? "selected" : "" %>>USER</option>
                <option value="ADMIN" <%= "ADMIN".equals(request.getParameter("role")) ? "selected" : "" %>>ADMIN</option>
                <option value="SHIPPER" <%= "SHIPPER".equals(request.getParameter("role")) ? "selected" : "" %>>SHIPPER</option>
            </select>

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
