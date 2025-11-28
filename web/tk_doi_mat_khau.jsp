<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="active" value="password"/>
<c:set var="nguoiDung"
       value="${not empty requestScope.nguoiDung ? requestScope.nguoiDung : sessionScope.nguoiDung}" />

<style>
    body{
        background:#f6f6f6;
        font-family:Arial,sans-serif
    }
    .account-shell{
        max-width:1200px;
        margin:20px auto;
        padding:0 16px;
        display:grid;
        grid-template-columns:260px 1fr;
        gap:24px;
    }
    .account-sidebar{
        background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        padding:16px;
        position:sticky;
        top:16px;
        height:fit-content;
    }
    .side-head{
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:12px
    }
    .side-avatar{
        width:36px;
        height:36px;
        border-radius:50%;
        object-fit:cover
    }
    .side-username{
        font-weight:700
    }
    .side-edit-hint{
        font-size:12px;
        color:#888
    }

    .side-nav{
        display:flex;
        flex-direction:column;
        gap:8px
    }
    .tab-btn{
        display:flex;
        align-items:center;
        gap:8px;
        padding:10px 12px;
        border-radius:8px;
        text-decoration:none;
        color:#333;
        background:#fff;
        border:1px solid #ececec;
        transition:.15s;
    }
    .tab-btn:hover{
        background:#e9f2ff;
        color:#1677ff;
        border-color:#d6e6ff
    }
    .tab-btn.active{
        background:#e9f2ff;
        color:#1677ff;
        font-weight:700;
        border-color:#1677ff;
        box-shadow:0 0 0 1px #1677ff inset;
    }

    .account-content{
        background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        box-shadow:0 1px 3px rgba(0,0,0,.05);
        padding:30px 40px;
    }
    .page-title{
        font-size:24px;
        font-weight:800;
        margin:0 0 6px
    }
    .page-sub{
        color:#6b7280;
        margin:0 0 20px
    }

    .pw-card{
        border:1px solid #eef2f7;
        border-radius:16px;
        padding:24px 28px;
        box-shadow:0 1px 0 #eef2f7 inset;
    }
    .pw-row{
        display:flex;
        align-items:center;
        margin:18px 0
    }
    .pw-label{
        width:200px;
        color:#374151;
        font-weight:600
    }
    .pw-field{
        flex:1;
        position:relative
    }

    .pw-input{
        width:100%;
        height:44px;
        border:1px solid #e5e7eb;
        border-radius:8px;
        padding:0 44px 0 14px;
        font-size:15px;
        outline:none;
        background:#fff
    }
    .pw-input:focus{
        border-color:#7295E3;
        box-shadow:0 0 0 3px rgba(114,149,227,.15)
    }

    .pw-eye{
        position:absolute;
        right:12px;
        top:50%;
        transform:translateY(-50%);
        cursor:pointer;
        user-select:none
    }
    .pw-help{
        font-size:13px;
        color:#6b7280;
        margin-top:6px
    }
    .pw-error{
        font-size:13px;
        color:#dc2626;
        margin-top:6px
    }
    .pw-ok{
        font-size:13px;
        color:#059669;
        margin-top:6px
    }

    .pw-btn{
        border:0;
        border-radius:10px;
        padding:10px 22px;
        font-weight:700;
        color:#fff;
        background:linear-gradient(180deg,#7aa3ff,#7295E3);
        box-shadow:0 6px 18px rgba(114,149,227,.25), 0 2px 6px rgba(114,149,227,.18);
        transition:transform .05s ease, box-shadow .2s ease, opacity .2s ease;
    }
    .pw-btn:hover{
        transform:translateY(-1px);
        box-shadow:0 10px 24px rgba(114,149,227,.28)
    }
    .pw-btn:active{
        transform:translateY(0)
    }
    .pw-btn[disabled]{
        opacity:.55;
        cursor:not-allowed;
        box-shadow:none;
        background:#9bb4f0
    }

    .alert{
        margin:0 0 14px 0;
        padding:10px 12px;
        border-radius:8px
    }
    .alert-error{
        background:#fee2e2;
        color:#991b1b
    }
    .alert-success{
        background:#dcfce7;
        color:#166534
    }
    /* Toast thành công sau khi đổi mật khẩu */
    .toast {
        position: fixed;
        top: 24px;
        left: 50%;
        transform: translateX(-50%);
        background: #dcfce7;
        color: #166534;
        border: 1px solid #86efac;
        padding: 10px 14px;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0,0,0,.12);
        z-index: 10000;
        display: none;
        font-weight: 600;
    }
    .toast.show {
        display: block;
        animation: toastIn .18s ease, toastOut .2s ease 2.8s forwards;
    }
    @keyframes toastIn {
        from {
            opacity: 0;
            transform: translate(-50%, -8px);
        }
        to   {
            opacity: 1;
            transform: translate(-50%, 0);
        }
    }
    @keyframes toastOut {
        to   {
            opacity: 0;
            transform: translate(-50%, -8px);
        }
    }


    @media (max-width:768px){
        .account-shell{
            grid-template-columns:1fr
        }
        .pw-row{
            flex-direction:column;
            align-items:flex-start
        }
        .pw-label{
            width:auto;
            margin-bottom:8px
        }
    }
     body {
        background:#f6f6f6;
        font-family:Arial, sans-serif;
    }
    .account-content {
        background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        box-shadow:0 1px 3px rgba(0,0,0,.05);
        max-width:900px;
        margin:40px auto;
        padding:30px 40px;
    }
    .profile-title {
        font-size:24px;
        font-weight:800;
        margin:0 0 6px;
    }
    .profile-sub {
        color:#6b7280;
        margin-bottom:24px;
    }
    .row {
        display:grid;
        grid-template-columns:200px 1fr 100px;
        align-items:center;
        gap:16px;
        margin-bottom:18px;
    }
    .row label {
        font-weight:600;
        color:#444;
    }
    .inp {
        width:100%;
        padding:10px 12px;
        border:1px solid #ddd;
        border-radius:6px;
        background:#fff;
        font-size:15px;
    }
    .inp[disabled] {
        background:#f9fafb;
        color:#333;
    }
    .action {
        color:#1677ff;
        text-decoration:none;
        cursor:pointer;
        font-weight:600;
    }
    .action:hover {
        text-decoration:underline;
    }
    .save-btn {
        background:#1677ff;
        color:#fff;
        border:0;
        border-radius:8px;
        font-weight:700;
        padding:12px 28px;
        cursor:pointer;
        transition:.2s;
    }
    .save-btn:disabled {
        opacity:.5;
        cursor:not-allowed;
    }
    .profile-right {
        display:flex;
        flex-direction:column;
        align-items:center;
        gap:10px;
    }
    .avatar-img {
        width:140px;
        height:140px;
        border-radius:50%;
        object-fit:cover;
        border:1px solid #e5e7eb;
        background-color:#f9fafb;
    }
    .btn-ghost {
        background:#fff;
        border:1px solid #d1d5db;
        border-radius:10px;
        padding:8px 16px;
        font-weight:700;
        cursor:pointer;
        transition:.2s;
    }
    .btn-ghost:hover {
        background:#f3f4f6;
    }
    .hint {
        color:#6b7280;
        font-size:14px;
        text-align:center;
        line-height:1.5;
    }
    .hint strong {
        color:#111827;
    }
    .profile-card {
        display:grid;
        grid-template-columns:1fr 260px;
        gap:40px;
        align-items:flex-start;
    }
    .account-shell{
        max-width:1200px;
        margin:20px auto;
        padding:0 16px;
        display:grid;
        grid-template-columns:260px 1fr;
        gap:24px;
    }
    .account-sidebar{
        background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        padding:16px;
        position:sticky;
        top:16px;
        height:fit-content;
    }
    .side-head{
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:12px
    }
    .side-avatar{
        width:36px;
        height:36px;
        border-radius:50%;
        object-fit:cover
    }
    .side-username{
        font-weight:700
    }
    .side-edit-hint{
        font-size:12px;
        color:#888
    }

    .side-nav{
        display:flex;
        flex-direction:column;
        gap:8px
    }
    .tab-btn{
        display:flex;
        align-items:center;
        gap:8px;
        padding:10px 12px;
        border-radius:8px;
        text-decoration:none;
        color:#333;
        background:#fff;
        border:1px solid #ececec;
        transition:.15s;
    }
    .tab-btn:hover{
        background:#e9f2ff;
        color:#1677ff;
        border-color:#d6e6ff
    }
    .tab-btn.active{
        background:#e9f2ff;
        color:#1677ff;
        font-weight:700;
        border-color:#1677ff;
        box-shadow:0 0 0 1px #1677ff inset;
    }

    .account-shell > .account-content{
        margin:0;
        max-width:unset
    }
    @media (max-width:768px){
        .account-shell{
            grid-template-columns:1fr
        }
    }
</style>
 <jsp:include page="header.jsp" />
 <c:set var="active" value="${not empty param.tab ? param.tab : (not empty requestScope.active ? requestScope.active : 'profile')}" />
<div class="account-shell">
    <!-- SIDEBAR -->
    <aside class="account-sidebar">
        <div class="side-head">
            <img src="${pageContext.request.contextPath}${ava}?v=${pageContext.session.id}"
                 class="side-avatar" alt="">

            <div>
                <div class="side-username"><c:out value="${nguoiDung.tenDangNhap}" default="Khách"/></div>
                <div class="side-edit-hint">✏️ Sửa Hồ Sơ</div>
            </div>
        </div>

        <nav class="side-nav">
            <a class="tab-btn ${active=='profile' ? 'active' : ''}"
              href="thong_tin_ca_nhan.jsp">👤 Hồ sơ</a>
            
            <a class="tab-btn"
             <a class="tab-btn" href="${ctx}/DonHangServlet?hanhDong=lichsu&tab=orders">🧾 Đơn hàng</a>


            <a class="tab-btn ${active=='tknh' ? 'active' : ''}"
               href="tk_ngan_hang.jsp">🏦 Ngân Hàng</a>

            <a class="tab-btn ${active=='address' ? 'active' : ''}"
               href="tk_dia_chi.jsp">📮 Địa chỉ</a>

            <a class="tab-btn ${active=='password' ? 'active' : ''}"
               href="tk_doi_mat_khau.jsp">🔒 Đổi mật khẩu</a>
        </nav>


    </aside>

<div class="account-content">
    <h2 class="page-title">Đổi mật khẩu</h2>
    <p class="page-sub">Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác.</p>

    <div class="pw-card">
        <c:if test="${not empty err}">
            <div class="alert alert-error">${err}</div>
        </c:if>
        <c:if test="${not empty sessionScope.pw_ok}">
            <div id="pwToast" class="toast">Đổi mật khẩu thành công.</div>
            <script>
                window.addEventListener('DOMContentLoaded', function () {
                    const t = document.getElementById('pwToast');
                    if (t) {
                        t.classList.add('show');
                        setTimeout(() => t.remove(), 3200);
                    }
                });
            </script>
            <c:remove var="pw_ok" scope="session"/>
        </c:if>



        <form method="post"
              action="${pageContext.request.contextPath}/nguoidung?hanhDong=doimatkhau&tab=password"
              id="pwForm" autocomplete="off">

            <div class="pw-row">
                <div class="pw-label">Mật khẩu mới</div>
                <div class="pw-field">
                    <input type="password" id="pw" name="pw" class="pw-input" placeholder="Nhập mật khẩu mới" required>
                    <span class="pw-eye" data-target="pw">👁️</span>
                    <div id="pwHint" class="pw-help">Tối thiểu 8 ký tự, có <b>ít nhất 1 số</b> và <b>1 ký tự đặc biệt</b>.</div>
                </div>
            </div>

            <div class="pw-row">
                <div class="pw-label">Xác nhận mật khẩu</div>
                <div class="pw-field">
                    <input type="password" id="pw2" name="pw2" class="pw-input" placeholder="Nhập lại mật khẩu" required>
                    <span class="pw-eye" data-target="pw2">👁️</span>
                    <div id="matchHint" class="pw-help"></div>
                </div>
            </div>

            <div class="pw-row">
                <div class="pw-label"></div>
                <button type="submit" class="pw-btn" id="submitBtn" disabled>Xác nhận</button>
            </div>
        </form>
    </div>
</div>
</div>

<script>
    const rule = /^(?=.*[0-9])(?=.*[^A-Za-z0-9\s]).{8,}$/;
    const pw = document.getElementById('pw');
    const pw2 = document.getElementById('pw2');
    const pwHint = document.getElementById('pwHint');
    const matchHint = document.getElementById('matchHint');
    const btn = document.getElementById('submitBtn');

    function validate() {
        const a = pw.value.trim(), b = pw2.value.trim();
        const strong = rule.test(a);
        pwHint.className = strong ? 'pw-ok' : 'pw-error';
        pwHint.textContent = strong ? 'Mật khẩu đủ mạnh.' : 'Mật khẩu chưa đạt yêu cầu (≥8 ký tự, có số & ký tự đặc biệt).';

        if (b) {
            const ok = a === b;
            matchHint.className = ok ? 'pw-ok' : 'pw-error';
            matchHint.textContent = ok ? 'Khớp mật khẩu.' : 'Không khớp. Vui lòng nhập lại.';
        } else {
            matchHint.className = 'pw-help';
            matchHint.textContent = '';
        }
        btn.disabled = !(strong && a === b);
    }

    pw.addEventListener('input', validate);
    pw2.addEventListener('input', validate);
    document.querySelectorAll('.pw-eye').forEach(icon => {
        icon.addEventListener('click', () => {
            const id = icon.dataset.target;
            const input = document.getElementById(id);
            input.type = (input.type === 'password') ? 'text' : 'password';
        });
    });
</script>
 <jsp:include page="footer.jsp" />