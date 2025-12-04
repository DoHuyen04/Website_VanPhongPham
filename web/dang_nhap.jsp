<%@ page contentType="text/html;charset=UTF-8" %> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập</title>
        <style>
            body {
                margin: 0;
                font-family: "Arial", sans-serif;
                background: linear-gradient(120deg, #cce8ff, #9bd4ff, #7db8ff);
                min-height: 100vh;
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
                width: 100%;
                background: #ffffff;
                padding: 35px;
                border-radius: 20px;
                box-shadow: 0 6px 20px rgba(0,0,0,0.18);
                animation: fadeIn .35s ease;
            }
            .login-links {
                margin-top: 15px;
                font-size: 14px;
                text-align: left;
            }

            .login-links a {
                color: #5b2aa8;
                text-decoration: underline;
            }


            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h2.login-title {
                text-align: center;
                font-size: 26px;
                font-weight: bold;
                color: #003366;
                margin-bottom: 35px;
            }

            label.form-label {
                font-weight: bold;
                color: #003366;
                font-size: 15px;
                display: block;
                margin-bottom: 5px;
            }

            label.form-label span {
                color: #ffcc00;
            }

            input, select {
                width: 100%;
                padding: 10px 0;
                border: none;
                border-bottom: 1.5px solid #cccccc;
                background: transparent;
                font-size: 15px;
                outline: none;
                margin-bottom: 25px;
            }

            input::placeholder {
                color: #999999;
            }

            .forgot {
                margin-top: -8px;
                margin-bottom: 25px;
                font-size: 14px;
                color: #003366;
            }

            .forgot a {
                text-decoration: none;
                font-weight: bold;
                color: #003366;
            }
            .forgot a span {
                color: #ffcc00;
            }

            .btn-login {
                width: 100%;
                padding: 14px;
                border: none;
                border-radius: 25px;
                background: #ffdd33;
                font-size: 17px;
                font-weight: bold;
                color: #000;
                cursor: pointer;
                margin-bottom: 15px;
                transition: .2s;
            }

            .btn-login:hover {
                background: #ffcc00;
            }

            .register-text {
                text-align: center;
                font-size: 14px;
                color: #003366;
            }

            .register-text span {
                color: #ffcc00;
                font-weight: bold;
                cursor: pointer;
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
            /* CSS cho select Vai trò */
            select#role {
                width: 100%;
                padding: 10px 0;
                border: none;
                border-bottom: 1.5px solid #cccccc;
                background: transparent;
                font-size: 15px;
                outline: none;
                margin-bottom: 25px;
                appearance: none; /* loại bỏ mũi tên mặc định trên trình duyệt */
                -webkit-appearance: none;
                -moz-appearance: none;
                cursor: pointer;
            }

            select#role:focus {
                border-color: #ffdd33; /* highlight khi focus */
            }

            select#role option {
                color: #003366;
                background-color: #fff;
            }

            /* Thêm mũi tên custom bằng CSS (tùy chọn) */
            select#role {
                background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20width%3D'10'%20height%3D'5'%20viewBox%3D'0%200%2010%205'%20xmlns%3D'http://www.w3.org/2000/svg'%3E%3Cpath%20d%3D'M0%200l5%205%205-5z'%20fill%3D'%23003366'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 10px center;
                background-size: 10px 5px;
            }

        </style>
    </head>

    <body>
        <div class="login-page">
            <div class="login-container">
                <h2 class="login-title">Đăng nhập</h2>

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

                    if (error != null) {
                %>
                <div class="error-msg"><%= error%></div>
                <% } else if ("thanhcong".equals(success)) { %>
                <div class="success-msg">Đăng ký thành công! Vui lòng đăng nhập.</div>
                <% } else if (roleMsg != null) {%>
                <div class="success-msg">Đăng nhập thành công! Vai trò: <strong><%= roleMsg%></strong></div>
                <% }%>

                <form action="nguoidung" method="post">
                    <input type="hidden" name="hanhDong" value="dangnhap">

                    <label class="form-label" for="tenDangNhap">Tên đăng nhập</label>
                    <input type="text" id="tenDangNhap" name="tenDangNhap" required
                           value="<%= request.getParameter("tenDangNhap") != null ? request.getParameter("tenDangNhap") : ""%>">
                    <div class="error"><%= request.getAttribute("loiTenDangNhap") != null ? request.getAttribute("loiTenDangNhap") : ""%></div>

                    <label class="form-label" for="matKhau">Mật khẩu</label>
                    <div class="password-wrapper">
                        <input type="password" id="matKhau" name="matKhau" required>
                        <span class="toggle-password" onclick="togglePassword()">👁</span>
                    </div>
                    <div class="error"><%= request.getAttribute("loiMatKhau") != null ? request.getAttribute("loiMatKhau") : ""%></div>

                    <label class="form-label" for="role">Vai trò</label>
                    <select name="role" id="role" required>
                        <option value="USER" <%= "USER".equals(request.getParameter("role")) ? "selected" : ""%>>USER</option>

                        <option value="SHIPPER" <%= "SHIPPER".equals(request.getParameter("role")) ? "selected" : ""%>>SHIPPER</option>
                    </select>

                    <button type="submit" class="btn-login">Đăng nhập</button>
                </form>

                <div class="login-links">
                    <a href="dang_ky.jsp">Chưa có tài khoản? Đăng ký</a>
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
