<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực mã đăng ký</title>
    <style>
        body { background-color: #e6f2ff; display:flex; justify-content:center; align-items:center; height:100vh; font-family:Arial, sans-serif; }
        .otp-box { background:#fff; border-radius:12px; padding:40px 50px; width:480px; text-align:center; box-shadow:0 6px 15px rgba(0,0,0,0.08); }
        .otp-box h2{ font-size:20px; margin-bottom:10px; color:#111; }
        .otp-box p{ font-size:14px; color:#555; margin-bottom:22px; }
        .otp-input{ display:flex; justify-content:center; gap:12px; margin-bottom:18px; }
        .otp-input input{ width:52px; height:54px; border:2px solid #e0e6ee; border-radius:8px; font-size:22px; text-align:center; outline:none; transition:all .12s; }
        .otp-input input:focus{ border-color:#0b63ff; box-shadow:0 0 8px rgba(11,99,255,0.12); }
        .btn{ display:inline-block; padding:10px 24px; border-radius:8px; font-size:15px; cursor:pointer; border:none; color:white; margin:6px; }
        .btn-confirm{ background:#0b63ff; }
        .btn-resend{ background:#10a44a; }
        .timer{ color:#555; margin-top:8px; font-size:13px; }
        .error{ color:#d33; font-size:14px; margin-top:12px; }
        .success{ color:#0a8f3c; font-size:14px; margin-top:12px; }
        form.inline{ display:inline-block; margin-top:6px; }
    </style>
</head>
<body>

<div class="otp-box">
    <h2>Xác thực mã đăng ký</h2>
    <p>Vui lòng nhập mã OTP gồm 6 chữ số đã được gửi về email của bạn.</p>

    <!-- FORM XÁC THỰC -->
    <form id="otpForm" action="${pageContext.request.contextPath}/XacThucMaServlet" method="post">
        <div class="otp-input" aria-label="OTP inputs">
            <input inputmode="numeric" pattern="[0-9]*" maxlength="1" class="digit" />
            <input inputmode="numeric" pattern="[0-9]*" maxlength="1" class="digit" />
            <input inputmode="numeric" pattern="[0-9]*" maxlength="1" class="digit" />
            <input inputmode="numeric" pattern="[0-9]*" maxlength="1" class="digit" />
            <input inputmode="numeric" pattern="[0-9]*" maxlength="1" class="digit" />
            <input inputmode="numeric" pattern="[0-9]*" maxlength="1" class="digit" />
        </div>

        <!-- hidden field sẽ chứa mã 6 chữ số trước khi submit -->
        <input type="hidden" name="code" id="otpHidden" />

        <div>
            <button type="submit" class="btn btn-confirm" id="confirmBtn">Tiếp tục</button>
        </div>
    </form>

    <!-- FORM GỬI LẠI MÃ -->
    <form id="resendForm" class="inline" action="${pageContext.request.contextPath}/GuiLaiMaServlet" method="post">
        <input type="hidden" name="action" value="resend"/>
        <button type="submit" id="resendBtn" class="btn btn-resend">Gửi lại mã</button>
    </form>

    <div class="timer">
        Mã OTP sẽ hết hiệu lực sau: <span id="countdown">05:00</span>
    </div>

    <div class="error">${requestScope.error != null ? requestScope.error : ""}</div>
    <div class="success">${requestScope.success != null ? requestScope.success : ""}</div>
</div>

<script>
(function () {
  const digits = Array.from(document.querySelectorAll('.digit'));
  const otpHidden = document.getElementById('otpHidden');
  const otpForm = document.getElementById('otpForm');
  const confirmBtn = document.getElementById('confirmBtn');
  const resendBtn = document.getElementById('resendBtn');
  const countdownEl = document.getElementById('countdown');

  /* ========= OTP nhập ========= */
  digits.forEach((input, idx) => {
    input.addEventListener('input', (e) => {
      input.value = input.value.replace(/\D/g, '');
      if (input.value.length === 1 && idx < digits.length - 1) digits[idx + 1].focus();
    });
    input.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && input.value === '' && idx > 0) digits[idx - 1].focus();
    });
  });

  otpForm.addEventListener('submit', (e) => {
    const code = digits.map(d => d.value || '').join('');
    otpHidden.value = code;
    if (code.length !== 6) {
      e.preventDefault();
      alert('Vui lòng nhập đủ 6 chữ số mã OTP.');
      return false;
    }
  });

  /* ========= Countdown 5 phút ========= */
  const OTP_TTL_MS = 5 * 60 * 1000;
  let remaining = OTP_TTL_MS;
  function formatMMSS(ms) {
    const mm = Math.floor(ms / 60000);
    const ss = Math.floor((ms % 60000) / 1000);
    return (mm < 10 ? '0' : '') + mm + ':' + (ss < 10 ? '0' : '') + ss;
  }
  function tick() {
    countdownEl.textContent = formatMMSS(Math.max(0, remaining));
    if (remaining <= 0) {
      clearInterval(timerId);
      confirmBtn.disabled = true;
      resendBtn.disabled = false;
    }
    remaining -= 1000;
  }
  let timerId = setInterval(tick, 1000);

  /* ========= Gửi lại mã ========= */
  resendBtn.addEventListener('click', (e) => {
    resendBtn.disabled = true;
    resendBtn.innerText = "Đang gửi lại...";
    setTimeout(() => {
      resendBtn.disabled = false;
      resendBtn.innerText = "Gửi lại mã";
      remaining = OTP_TTL_MS; // reset thời gian đếm ngược
      clearInterval(timerId);
      timerId = setInterval(tick, 1000);
    }, 4000); // cho phép gửi lại sau 4 giây
  });
})();
</script>

</body>
</html>
