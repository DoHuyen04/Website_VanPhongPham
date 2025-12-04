<%-- 
    Document   : quen_mat_khau
    Created on : Oct 14, 2025, 10:35:26 PM
    Author     : asus
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>

    <style>
        body {
            margin: 0;
            font-family: "Arial", sans-serif;
            background: linear-gradient(120deg, #cce8ff, #9bd4ff, #7db8ff); /* SAME AS REGISTER */
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

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

        h2 {
            text-align: center;
            font-size: 26px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: bold;
            color: #003366;
            font-size: 15px;
            margin-bottom: 6px;
            display: block;
        }

        .form-label span {
            color: #ffcc00;
        }

        .input-line {
            width: 100%;
            padding: 12px 0;
            border: none;
            border-bottom: 1.4px solid #cccccc;
            background: transparent;
            font-size: 15px;
            outline: none;
            margin-bottom: 20px;
        }

        .input-line::placeholder {
            color: #999999;
        }

        /* tooltip lỗi */
        .tooltip-error {
            font-size: 13px;
            color: #c40000;
            margin-top: -15px;
            margin-bottom: 12px;
            display: none;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: #ffdd33;
            border: none;
            border-radius: 25px;
            font-weight: bold;
            font-size: 17px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: #ffcc00;
        }

        .back {
            margin-top: 20px;
            text-align: center;
        }

        .back a {
            text-decoration: none;
            color: #003366;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Đổi mật khẩu</h2>

    <form action="DoiMatKhauServlet" method="post" onsubmit="return validateChange()">

        <!-- mật khẩu hiện tại -->
        <label class="form-label">Mật khẩu hiện tại <span>*</span></label>
        <input type="password" id="oldPass" name="oldPass" class="input-line" placeholder="Nhập mật khẩu hiện tại">
        <div id="errOld" class="tooltip-error">⚠ Bạn chưa nhập mật khẩu hiện tại</div>

        <!-- mật khẩu mới -->
        <label class="form-label">Mật khẩu mới <span>*</span></label>
        <input type="password" id="newPass" name="newPass" class="input-line" placeholder="Nhập mật khẩu mới">
        <div id="errNew" class="tooltip-error">⚠ Mật khẩu mới không được để trống</div>

        <!-- xác nhận mật khẩu -->
        <label class="form-label">Xác nhận mật khẩu mới <span>*</span></label>
        <input type="password" id="confirmPass" name="confirmPass" class="input-line" placeholder="Nhập lại mật khẩu mới">
        <div id="errConfirm" class="tooltip-error">⚠ Mật khẩu xác nhận không trùng khớp</div>

        <button class="btn-submit" type="submit">Xác nhận đổi mật khẩu</button>
    </form>

    <div class="back">
        <a href="dang_nhap.jsp">← Trở lại đăng nhập</a>
    </div>

</div>

<script>
function validateChange() {
    let oldP = document.getElementById("oldPass");
    let newP = document.getElementById("newPass");
    let cfP  = document.getElementById("confirmPass");

    let errOld = document.getElementById("errOld");
    let errNew = document.getElementById("errNew");
    let errConfirm = document.getElementById("errConfirm");

    let valid = true;

    // check old password
    if (oldP.value.trim() === "") {
        errOld.style.display = "block";
        valid = false;
    } else errOld.style.display = "none";

    // check new password
    if (newP.value.trim() === "") {
        errNew.style.display = "block";
        valid = false;
    } else errNew.style.display = "none";

    // check confirm
    if (cfP.value.trim() !== newP.value.trim()) {
        errConfirm.style.display = "block";
        valid = false;
    } else errConfirm.style.display = "none";

    return valid;
}
</script>

</body>
</html>