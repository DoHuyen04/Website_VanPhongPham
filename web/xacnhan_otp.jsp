<%-- xac_thuc_ma.jsp (sửa) --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
     request.setCharacterEncoding("UTF-8");

    // Lấy dữ liệu người nhận từ session hoặc request
    String tenNguoiNhan = request.getAttribute("tenNguoiNhan") != null
            ? (String) request.getAttribute("tenNguoiNhan")
            : (String) session.getAttribute("tenNguoiNhan");

    String diaChi = request.getAttribute("diaChi") != null
            ? (String) request.getAttribute("diaChi")
            : (String) session.getAttribute("diaChi");

    String soDienThoai = request.getAttribute("soDienThoai") != null
            ? (String) request.getAttribute("soDienThoai")
            : (String) session.getAttribute("soDienThoai");

    String email = request.getAttribute("email") != null
            ? (String) request.getAttribute("email")
            : (String) session.getAttribute("email");
    Long exp = (Long) session.getAttribute("otp_expire");
    long remain = 0;
    if (exp != null) {
        remain = Math.max(0, (exp - System.currentTimeMillis()) / 1000); // giây còn lại
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>XÁC NHẬN OTP</title>
        <style>
            body {
                text-align:center;
                font-family:Arial;
            }
            input {
                padding:8px;
                width:150px;
                text-align:center;
                margin:10px;
            }
            .btn {
                background-color:#4CAF50;
                border:none;
                color:#fff;
                padding:8px 15px;
                border-radius:6px;
                cursor:pointer;
            }
            .btn:hover {
                background-color:#388e3c;
            }
            .notice {
                margin-top:12px;
                color:#2e7d32;
            }
            .error {
                margin-top:12px;
                color:#c62828;
            }
            .timer {
                margin-top:8px;
                color:#555;
            }
        </style>
        <script>
    let timeLeft = <%= remain%>;

    function startTimer() {
        const timerDisplay = document.getElementById("timer");
        const otpInput = document.getElementById("otpInput");
        function tick() {
            if (timeLeft <= 0) {
                timerDisplay.innerText = "MÃ OTP HẾT HẠN – vui lòng gửi lại mã";
                if (otpInput)
                    otpInput.disabled = true;
                return;
            }
            const m = Math.floor(timeLeft / 60);
            const s = timeLeft % 60;
            timerDisplay.innerText = m + " phút " + (s < 10 ? "0" : "") + s + " giây";
            timeLeft--;
            setTimeout(tick, 1000);
        }
        tick();
    }
    window.onload = startTimer;
        </script>
    </head>
    <body>
        <h3>🔐 Nhập mã OTP thanh toán</h3>

        <!-- Form xác nhận OTP: POST về XacNhanOTPServlet -->
        <form method="post" action="${pageContext.request.contextPath}/XacNhanOTPServlet">
            <input type="hidden" name="tenNguoiNhan" value="<%= tenNguoiNhan != null ? tenNguoiNhan : "" %>">
        <input type="hidden" name="diaChi" value="<%= diaChi != null ? diaChi : "" %>">
        <input type="hidden" name="soDienThoai" value="<%= soDienThoai != null ? soDienThoai : "" %>">
        <input type="hidden" name="email" value="<%= email != null ? email : "" %>">
<input type="hidden" name="phuongThuc" value="${phuongThuc}">
            <input id="otpInput" type="text" name="otp" maxlength="6" placeholder="Nhập mã OTP">
            <br>
            <button type="submit" class="btn">Xác nhận</button>
        </form>

        <!-- Gửi lại mã: cũng POST về XacNhanOTPServlet nhưng KHÔNG gửi trường otp -->
        <form method="post" action="${pageContext.request.contextPath}/XacNhanOTPServlet" style="margin-top:8px;">
            <input type="hidden" name="tenNguoiNhan" value="<%= tenNguoiNhan != null ? tenNguoiNhan : "" %>">
        <input type="hidden" name="diaChi" value="<%= diaChi != null ? diaChi : "" %>">
        <input type="hidden" name="soDienThoai" value="<%= soDienThoai != null ? soDienThoai : "" %>">
        <input type="hidden" name="email" value="<%= email != null ? email : "" %>">

            <button type="submit" class="btn">Gửi lại mã</button>
        </form>

        <div class="timer">
            Thời gian hiệu lực: <span id="timer"></span>
        </div>

        <% if (request.getAttribute("thongBao") != null) {%>
        <div class="notice"><%= request.getAttribute("thongBao")%></div>
        <% } %>
        <% if (request.getAttribute("error") != null) {%>
        <div class="error"><%= request.getAttribute("error")%></div>
        <% }%>

    </body>
</html>
