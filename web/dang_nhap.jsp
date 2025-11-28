<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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

        /* FORM TRẮNG GIỮ NGUYÊN KHUNG */
        .container {
            width: 420px;
            background: #ffffff;
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.18);
            animation: fadeIn .35s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* TIÊU ĐỀ */
        .login-title {
            text-align: center;
            font-size: 26px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 35px;
        }

        /* LABEL */
        .form-label {
            font-weight: bold;
            color: #003366;
            font-size: 15px;
            display: block;
            margin-bottom: 5px;
        }

        .form-label span {
            color: #ffcc00;
        }

        /* INPUT GẠCH CHÂN */
        .input-line {
            width: 100%;
            padding: 10px 0;
            border: none;
            border-bottom: 1.5px solid #cccccc;
            background: transparent;
            font-size: 15px;
            outline: none;
            margin-bottom: 25px;
        }

        .input-line::placeholder {
            color: #999999;
        }

        /* QUÊN MẬT KHẨU */
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

        /* BUTTON VÀNG */
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

        /* ĐĂNG KÝ */
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

    </style>
</head>

<body>

<div class="container">
    <h2 class="login-title">ĐĂNG NHẬP</h2>

    <form action="DangNhapServlet" method="post">

        <label class="form-label">Email <span>*</span></label>
        <input type="text" name="username" class="input-line" placeholder="Nhập Email">

        <label class="form-label">Mật khẩu <span>*</span></label>
        <input type="password" name="password" class="input-line" placeholder="Nhập Mật khẩu">

        <div class="forgot">
            Quên mật khẩu? Nhấn vào <a href="quen_mat_khau.jsp"><span>đây</span></a>
        </div>

        <button type="submit" class="btn-login">Đăng nhập</button>

        <div class="register-text">
            Bạn chưa có tài khoản? <span onclick="window.location='dang_ky.jsp'">Đăng ký tại đây</span>
        </div>
    </form>

</div>

</body>
</html>
