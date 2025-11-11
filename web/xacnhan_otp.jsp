<%-- 
    Document   : xac_thuc_ma
    Created on : Oct 14, 2025, 10:35:50 PM
    Author     : asus
--%>
<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<title>XÁC NHẬN OTP</title>
<style>
body { text-align:center; font-family:Arial; }
input { padding:8px; width:150px; text-align:center; margin:10px; }
.btn {
    background-color:#4CAF50; border:none; color:#fff;
    padding:8px 15px; border-radius:6px; cursor:pointer;
}
.btn:hover { background-color:#388e3c; }
</style>
<script>
let timeLeft = 300;

function startTimer() {
    const timerDisplay = document.getElementById("timer");
    const countdown = setInterval(() => {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;
        timerDisplay.innerText = minutes + " phút " + (seconds < 10 ? "0" : "") + seconds + " giây";
        timeLeft--;

        if (timeLeft < 0) {
            clearInterval(countdown);
            timerDisplay.innerText = "MÃ OTP ĐÃ HẾT THỜI GIAN HIỆU LỰC! VUI LÒNG NHẬP MÃ MỚI";
            document.getElementById("otpInput").disabled = true;
        }
    }, 1000);
}

window.onload = startTimer;
</script>
</head>
<body>
<h3>Nhập mã OTP thanh toán</h3>
<form action="KiemTraOTPServlet" method="post">
    <input type="text" name="otp" maxlength="6" placeholder="Nhập mã OTP">
    <br>
    <button type="submit" class="btn">Xác nhận</button>
    <button type="button" class="btn" onclick="window.location.href='GuiLaiOTPServlet'">Gửi lại mã</button>
</form>

        <div class="timer">
            Thời gian hiệu lực: <span id="timer"></span>
        </div>

        <% if (request.getAttribute("thongBao") != null) { %>
            <div class="notice"><%= request.getAttribute("thongBao") %></div>
        <% } %>
</body>
</html>
