<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="active" value="password"/>
<c:set var="nguoiDung"
       value="${not empty requestScope.nguoiDung ? requestScope.nguoiDung : sessionScope.nguoiDung}" />

<style>
    :root{
        --brand:#7295E3;
        --text:#111827;
        --muted:#6b7280;
        --line:#e5e7eb;
        --danger:#ef4444;
        --bg:#f6f6f6;
        --card:#ffffff;
    }

    body{
        background:var(--bg);
        font-family:Arial,system-ui,sans-serif;
        margin:0;
    }

    .account-shell{
        max-width:1200px;
        margin:20px auto 40px;
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
        margin-bottom:12px;
    }
    .side-avatar{
        width:36px;
        height:36px;
        border-radius:50%;
        object-fit:cover;
    }
    .side-username{
        font-weight:700;
    }
    .side-edit-hint{
        font-size:12px;
        color:#9ca3af;
    }

    .side-nav{
        display:flex;
        flex-direction:column;
        gap:8px;
        margin-top:4px;
    }
    .tab-btn{
        display:flex;
        align-items:center;
        gap:8px;
        padding:10px 12px;
        border-radius:8px;
        text-decoration:none;
        color:#374151;
        background:#fff;
        border:1px solid #ececec;
        transition:.15s;
        font-size:14px;
    }
    .tab-btn:hover{
        background:#e9f2ff;
        color:#2563eb;
        border-color:#d6e6ff;
    }
    .tab-btn.active{
        background:#e9f2ff;
        color:#2563eb;
        font-weight:700;
        border-color:#2563eb;
        box-shadow:0 0 0 1px #2563eb inset;
    }

    .account-content{
        background:var(--card);
        border:1px solid #eee;
        border-radius:16px;
        box-shadow:0 1px 3px rgba(15,23,42,.06);
        padding:30px 40px;
    }
    .page-title{
        font-size:24px;
        font-weight:800;
        margin:0 0 6px;
        color:var(--text);
    }
    .page-sub{
        color:var(--muted);
        margin:0 0 20px;
        font-size:14px;
    }

    .pw-card{
        border:1px solid #eef2f7;
        border-radius:16px;
        padding:24px 28px;
        box-shadow:0 1px 0 #eef2f7 inset;
        background:#f9fafb;
    }
    .pw-row{
        display:flex;
        align-items:flex-start;
        margin:18px 0;
        gap:16px;
    }
    .pw-label{
        width:200px;
        color:#374151;
        font-weight:600;
        padding-top:10px;
    }
    .pw-field{
        flex:1;
        position:relative;
    }

    .pw-input{
        width:100%;
        height:44px;
        border:1px solid #e5e7eb;
        border-radius:8px;
        padding:0 44px 0 14px;
        font-size:15px;
        outline:none;
        background:#fff;
    }
    .pw-input:focus{
        border-color:#93c5fd;
        box-shadow:0 0 0 3px rgba(59,130,246,.18);
    }

    .pw-eye{
        position:absolute;
        right:12px;
        top:50%;
        transform:translateY(-50%);
        cursor:pointer;
        user-select:none;
        font-size:16px;
    }

    .pw-help{
        font-size:13px;
        color:var(--muted);
        margin-top:6px;
    }
    .pw-error{
        font-size:13px;
        color:#dc2626;
        margin-top:6px;
    }
    .pw-ok{
        font-size:13px;
        color:#059669;
        margin-top:6px;
    }

    .pw-btn{
        border:0;
        border-radius:10px;
        padding:10px 22px;
        font-weight:700;
        color:#fff;
        background:linear-gradient(180deg,#7aa3ff,#7295E3);
        box-shadow:0 6px 18px rgba(114,149,227,.25),0 2px 6px rgba(114,149,227,.18);
        transition:transform .05s ease, box-shadow .2s ease, opacity .2s ease;
        cursor:pointer;
    }
    .pw-btn:hover{
        transform:translateY(-1px);
        box-shadow:0 10px 24px rgba(114,149,227,.28);
    }
    .pw-btn:active{
        transform:translateY(0);
    }
    .pw-btn[disabled]{
        opacity:.55;
        cursor:not-allowed;
        box-shadow:none;
        background:#9bb4f0;
    }

    .alert{
        margin:0 0 14px;
        padding:10px 12px;
        border-radius:8px;
        font-size:14px;
    }
    .alert-error{
        background:#fee2e2;
        color:#991b1b;
    }
    .alert-success{
        background:#dcfce7;
        color:#166534;
    }

    /* Toast */
    .toast{
        position:fixed;
        top:24px;
        left:50%;
        transform:translateX(-50%);
        background:#dcfce7;
        color:#166534;
        border:1px solid #86efac;
        padding:10px 14px;
        border-radius:10px;
        box-shadow:0 10px 30px rgba(0,0,0,.12);
        z-index:10000;
        display:none;
        font-weight:600;
    }
    .toast.show{
        display:block;
        animation:toastIn .18s ease, toastOut .2s ease 2.8s forwards;
    }
    @keyframes toastIn{
        from{opacity:0;transform:translate(-50%,-8px);}
        to{opacity:1;transform:translate(-50%,0);}
    }
    @keyframes toastOut{
        to{opacity:0;transform:translate(-50%,-8px);}
    }

    @media (max-width:768px){
        .account-shell{
            grid-template-columns:1fr;
            padding:0 10px;
        }
        .account-content{
            padding:22px 16px;
        }
        .pw-row{
            flex-direction:column;
        }
        .pw-label{
            width:auto;
            margin-bottom:6px;
        }
    }
</style>

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
