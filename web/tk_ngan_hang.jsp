<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.TKNganHangDAO, model.TKNganHang" %>

<%
    HttpSession ss = request.getSession(false);
    String username = ss != null ? (String) ss.getAttribute("tenDangNhap") : null;
    List<TKNganHang> banks = new ArrayList<>();
    if (username != null) {
        banks = new TKNganHangDAO().layDanhSachTheoTenDangNhap(username);
    }
    Integer userId = (ss != null) ? (Integer) ss.getAttribute("userId") : null;
    if (userId != null) {
        banks = new TKNganHangDAO().listByUserId(userId);
    }
%>

<jsp:include page="header.jsp" />
<c:set var="active" value="${not empty param.tab ? param.tab : (not empty requestScope.active ? requestScope.active : 'profile')}" />

<style>
/* ==========================
   Scoped CSS cho main content
=========================== */
 .account-shell, 
    .account-shell * {
        box-sizing:border-box;
    }

    .account-shell {
        max-width:1200px;
        margin:20px auto;
        padding:0 16px;
        display:grid;
        grid-template-columns:260px 1fr;
        gap:24px;
    }

    .account-content {
        background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        box-shadow:0 1px 3px rgba(0,0,0,.05);
        padding:30px 40px;
    }

    .profile-card {
        display:grid;
        grid-template-columns:1fr 260px;
        gap:40px;
        align-items:flex-start;
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

    .account-sidebar {
        background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        padding:16px;
        position:sticky;
        top:16px;
        height:fit-content;
    }

    .side-head {
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:12px;
    }

    .side-avatar {
        width:36px;
        height:36px;
        border-radius:50%;
        object-fit:cover;
    }

    .side-username {
        font-weight:700;
    }

    .side-edit-hint {
        font-size:12px;
        color:#888;
    }

    .side-nav {
        display:flex;
        flex-direction:column;
        gap:8px;
    }

    .tab-btn {
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

    .tab-btn:hover {
        background:#e9f2ff;
        color:#1677ff;
        border-color:#d6e6ff;
    }

    .tab-btn.active {
        background:#e9f2ff;
        color:#1677ff;
        font-weight:700;
        border-color:#1677ff;
        box-shadow:0 0 0 1px #1677ff inset;
    }

    /* Responsive */
    @media (max-width:768px){
        .account-shell{
            grid-template-columns:1fr;
        }
        .profile-card {
            grid-template-columns:1fr;
        }
    }
#tkBankContent {
    max-width: 1100px;
    margin: 30px auto;
    display: grid;
    grid-template-columns: 280px 1fr;
    gap: 24px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Sidebar */
#tkBankContent .account-sidebar {
   
    background:#fff;
        border:1px solid #eee;
        border-radius:10px;
        padding:16px;
        position:sticky;
        top:16px;
        height:fit-content;
}

#tkBankContent .side-head {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

#tkBankContent .side-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    object-fit: cover;
}

#tkBankContent .side-username {
    font-weight: 600;
    font-size: 16px;
}

#tkBankContent .side-edit-hint {
    font-size: 12px;
    color: #6b7280;
}

#tkBankContent .side-nav {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

#tkBankContent .tab-btn {
    padding: 10px 12px;
    border-radius: 8px;
    text-decoration: none;
    color: #111827;
    font-weight: 500;
    transition: 0.15s;
}

#tkBankContent .tab-btn.active, 
#tkBankContent .tab-btn:hover {
    background: #eef2ff;
    color: #4f46e5;
}

/* Nội dung chính */
#tkBankContent .account-content {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.05);
}

/* Header ngân hàng */
#tkBankContent .bank-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

#tkBankContent .btn-add {
    background: #4f46e5;
    color: #fff;
    border: none;
    padding: 8px 16px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    transition: 0.15s;
}
#tkBankContent .btn-add:hover { background: #4338ca; }

/* Form thêm ngân hàng */
#tkBankContent .grid2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    margin-top: 10px;
}

#tkBankContent .inp {
    padding: 8px 12px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    width: 100%;
}

/* Bank card */
#tkBankContent .bank-item {
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 14px;
    padding: 20px;
    margin-top: 16px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.05);
}

#tkBankContent .bank-badge {
    background: #e0f2fe;
    color: #0369a1;
    padding: 4px 8px;
    border-radius: 8px;
    font-size: 12px;
    margin-left: 6px;
    font-weight: 600;
}
#tkBankContent .approved {
    background: #d1fae5 !important;
    color: #065f46 !important;
}

/* Buttons */
#tkBankContent .btn-set-default {
    padding: 8px 12px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    cursor: pointer;
    background: #fff;
    transition: 0.15s;
}
#tkBankContent .btn-set-default:hover:not([disabled]) {
    background: #eef;
    border-color: #4f46e5;
}
#tkBankContent .btn-danger {
    background: #ef4444;
    border: none;
    color: #fff;
    padding: 8px 12px;
    border-radius: 8px;
    cursor: pointer;
    transition: 0.15s;
}
#tkBankContent .btn-danger:hover { background: #dc2626; }

/* Modal */
#tkBankContent #confirmModal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.35);
    align-items: center;
    justify-content: center;
    z-index: 9999;
}
#tkBankContent #confirmModal .modal-box {
    background: #fff;
    border-radius: 12px;
    max-width: 420px;
    width: 92%;
    padding: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}

/* Responsive */
@media (max-width:768px){
    #tkBankContent { grid-template-columns: 1fr; }
    #tkBankContent .grid2 { grid-template-columns: 1fr; }
    #tkBankContent .account-sidebar { margin-bottom: 20px; }
}
</style>

<div id="tkBankContent">
    <!-- Sidebar -->
    <aside class="account-sidebar">
        <div class="side-head">
            <img src="${pageContext.request.contextPath}${ava}?v=${pageContext.session.id}" class="side-avatar" alt="">
            <div>
                <div class="side-username"><c:out value="${nguoiDung.tenDangNhap}" default="Khách"/></div>
                <div class="side-edit-hint">✏️ Sửa Hồ Sơ</div>
            </div>
        </div>
        <nav class="side-nav">
            <a class="tab-btn ${active=='profile' ? 'active' : ''}" href="thong_tin_ca_nhan.jsp">👤 Hồ sơ</a>
            <a class="tab-btn" href="${ctx}/DonHangServlet?hanhDong=lichsu&tab=orders">🧾 Đơn hàng</a>
            <a class="tab-btn ${active=='tknh' ? 'active' : ''}" href="tk_ngan_hang.jsp">🏦 Ngân Hàng</a>
            <a class="tab-btn ${active=='address' ? 'active' : ''}" href="tk_dia_chi.jsp">📮 Địa chỉ</a>
            <a class="tab-btn ${active=='password' ? 'active' : ''}" href="tk_doi_mat_khau.jsp">🔒 Đổi mật khẩu</a>
        </nav>
    </aside>

    <!-- Main content -->
    <div class="account-content">
        <h2>Tài Khoản Ngân Hàng Của Tôi</h2>
        <div class="bank-header">
            <div></div>
            <button class="btn-add" type="button" onclick="document.getElementById('addBankBox').style.display='block'">＋ Thêm Ngân Hàng Liên Kết</button>
        </div>

        <!-- Add Bank Form -->
        <div id="addBankBox" style="display:none">
            <form method="post" action="${pageContext.request.contextPath}/TKNganHangServlet">
                <input type="hidden" name="action" value="add">
                <div class="grid2">
                    <input class="inp" name="tenNganHang" placeholder="Tên ngân hàng" required>
                    <input class="inp" name="chiNhanh" placeholder="Chi nhánh">
                    <input class="inp" name="chuTaiKhoan" placeholder="Chủ tài khoản" required>
                    <input class="inp" name="soTaiKhoan" placeholder="Số tài khoản" required>
                </div>
                <label style="display:inline-flex;align-items:center;gap:6px;margin-top:10px">
                    <input type="checkbox" name="macDinh" value="1"> Đặt làm mặc định
                </label>
                <div style="margin-top:10px">
                    <button class="btn-add" type="submit">Lưu thẻ</button>
                    <button type="button" onclick="document.getElementById('addBankBox').style.display='none'">Hủy</button>
                </div>
            </form>
        </div>

        <!-- Bank List -->
        <% for(TKNganHang b : banks){ %>
        <div class="bank-item">
            <div>
                <div style="font-weight:700">
                    <%= b.getTenNganHang() %>
                    <% if("daduyet".equalsIgnoreCase(b.getTrangThai())){ %>
                        <span class="bank-badge approved">ĐÃ DUYỆT</span>
                    <% } %>
                    <% if(b.isMacDinh()){ %>
                        <span class="bank-badge">MẶC ĐỊNH</span>
                    <% } %>
                </div>
                <div class="grid2" style="margin-top:10px">
                    <input class="inp" value="<%= b.getTenNganHang() %>" readonly>
                    <input class="inp" value="<%= b.getChiNhanh() %>" readonly>
                    <input class="inp" value="<%= b.getChuTaiKhoan() %>" readonly>
                    <input class="inp bank-number" value="<%= b.getSoTaiKhoan() %>" readonly>
                </div>
                <div class="bank-actions" style="margin-top:10px">
                    <form method="post" action="${pageContext.request.contextPath}/TKNganHangServlet">
                        <input type="hidden" name="action" value="setDefault">
                        <input type="hidden" name="id" value="<%= b.getIdTkNganHang() %>">
                        <button class="btn-set-default" <%= b.isMacDinh()?"disabled":""%>>
                            <%= b.isMacDinh()?"Đang là mặc định":"Đặt làm mặc định"%>
                        </button>
                    </form>
                    <button type="button" class="btn-danger btn-delete-bank" data-id="<%= b.getIdTkNganHang() %>">Xoá</button>
                </div>
            </div>
        </div>
        <% } %>
        <% if(banks.isEmpty()){ %>
            <div style="color:#6b7280">Bạn chưa liên kết tài khoản ngân hàng nào.</div>
        <% } %>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
(function(){
    const modal = document.getElementById('confirmModal');
    const btnCancel = document.getElementById('btnCancel');
    const btnConfirm = document.getElementById('btnConfirm');
    const deleteForm = document.getElementById('deleteForm');
    const deleteIdInput = document.getElementById('deleteId');
    const confirmText = document.getElementById('confirmText');
    let pendingId = null;

    document.addEventListener('click', function(e){
        const btn = e.target.closest('.btn-delete-bank');
        if(!btn) return;
        e.preventDefault();
        pendingId = btn.dataset.id;
        modal.style.display='flex';
    });

    btnCancel.addEventListener('click', ()=>{pendingId=null; modal.style.display='none';});
    btnConfirm.addEventListener('click', ()=>{
        if(!pendingId) return;
        deleteIdInput.value=pendingId;
        modal.style.display='none';
        deleteForm.submit();
    });
    modal.addEventListener('click', e=>{if(e.target===modal){pendingId=null; modal.style.display='none';}});
})();
</script>