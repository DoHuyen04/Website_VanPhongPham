<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="model.DiaChi" %>
<%
    HttpSession ss = request.getSession(false);
    String username = ss != null ? (String) ss.getAttribute("tenDangNhap") : null;
    List<DiaChi> dsDiaChi = (List<DiaChi>) request.getAttribute("dsDiaChi");
%>

<jsp:include page="header.jsp" />

<div class="account-content-page">
    <c:set var="active" value="${not empty param.tab ? param.tab : (not empty requestScope.active ? requestScope.active : 'address')}" />

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
                <a class="tab-btn ${active=='profile' ? 'active' : ''}" href="thong_tin_ca_nhan.jsp">👤 Hồ sơ</a>
                 <a class="tab-btn" href="${ctx}/DonHangServlet?hanhDong=lichsu&tab=orders">🧾 Đơn hàng</a>
                <a class="tab-btn ${active=='tknh' ? 'active' : ''}" href="tk_ngan_hang.jsp">🏦 Ngân Hàng</a>
                <a class="tab-btn ${active=='address' ? 'active' : ''}" href="tk_dia_chi.jsp">📮 Địa chỉ</a>
                <a class="tab-btn ${active=='password' ? 'active' : ''}" href="tk_doi_mat_khau.jsp">🔒 Đổi mật khẩu</a>
            </nav>
        </aside>

        <!-- NỘI DUNG CHÍNH -->
        <div class="account-content">
            <div class="row-between">
                <h2>Địa chỉ của tôi</h2>
                <button class="btn btn-primary" id="btnAdd">+ Thêm địa chỉ mới</button>
            </div>

            <!-- DANH SÁCH ĐỊA CHỈ -->
            <c:if test="${not empty dsDiaChi}">
                <c:forEach var="d" items="${dsDiaChi}">
                    <div class="addr-item">
                        <div class="addr-left">
                            <div class="name">
                                ${d.hoTen} <span class="muted">(${d.soDienThoai})</span>
                                <c:if test="${d.macDinh}">
                                    <span class="badge">Mặc định</span>
                                </c:if>
                            </div>
                            <div class="muted">
                                ${d.diaChiDuong}, ${d.xaPhuong}, ${d.quanHuyen}, ${d.tinhThanh}
                            </div>
                        </div>
                        <div class="addr-actions">
                            <!-- Đặt mặc định -->
                            <form method="post" action="${pageContext.request.contextPath}/DiaChiServlet">
                                <input type="hidden" name="action" value="setDefault">
                                <input type="hidden" name="id" value="${d.id}">
                                <input type="hidden" name="backTo" value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">
                                <button class="btn" ${d.macDinh ? "disabled" : ""}>Thiết lập mặc định</button>
                            </form>

                            <!-- Xóa -->
                            <button type="button" class="link danger btn-delete-addr"
                                    data-id="${d.id}"
                                    data-label="${d.hoTen} - ${d.diaChiDuong}, ${d.xaPhuong}, ${d.quanHuyen}, ${d.tinhThanh}">
                                Xoá
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty dsDiaChi}">
                <div class="no-address">Bạn chưa thêm địa chỉ nào.</div>
            </c:if>
        </div>
    </div>

    <!-- MODAL THÊM ĐỊA CHỈ -->
    <div id="modalAddr" class="modal hidden">
        <div class="modal-body">
            <div class="modal-title">Thêm địa chỉ mới</div>
            <form id="formAddr" method="post" action="${pageContext.request.contextPath}/DiaChiServlet">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="backTo" value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">
                <div class="grid2">
                    <input name="hoTen" placeholder="Họ và tên" required>
                    <input name="soDienThoai" placeholder="Số điện thoại" required>
                </div>
                <div class="grid3">
                    <select id="selTinh" required>
                        <option value="">Tỉnh/Thành phố</option>
                    </select>
                    <select id="selHuyen" required disabled>
                        <option value="">Quận/Huyện</option>
                    </select>
                    <select id="selXa" required disabled>
                        <option value="">Phường/Xã</option>
                    </select>
                    <input type="hidden" name="tinhThanh" id="hidTinh">
                    <input type="hidden" name="quanHuyen" id="hidHuyen">
                    <input type="hidden" name="xaPhuong" id="hidXa">
                </div>
                <input name="diaChiDuong" placeholder="Địa chỉ cụ thể (số nhà, đường...)" required>
                <label><input type="checkbox" name="macDinh"> Đặt làm địa chỉ mặc định</label>
                <div class="row-end">
                    <button type="button" class="btn" id="btnClose">Trở lại</button>
                    <button class="btn btn-primary">Hoàn thành</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL XÓA ĐỊA CHỈ -->
    <div id="addrConfirmModal" class="modal hidden">
        <div class="modal-body">
            <h3>Xác nhận xoá địa chỉ</h3>
            <p id="addrConfirmText"></p>
            <div class="row-end">
                <button type="button" class="btn" id="addrBtnCancel">Huỷ</button>
                <button type="button" class="btn btn-primary" id="addrBtnConfirm">Xác nhận</button>
            </div>
        </div>
    </div>

    <form id="addrDeleteForm" method="post" action="${pageContext.request.contextPath}/DiaChiServlet" style="display:none">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="id" id="addrDeleteId">
        <input type="hidden" name="backTo" value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">
    </form>

</div>

<style>
/* Scoped CSS chỉ trong account-content-page */
.account-content-page {
    font-family: Arial, sans-serif;
    color: #111827;
}
.account-content-page .account-shell {
    display: grid;
    grid-template-columns: 260px 1fr;
    gap: 24px;
    max-width: 1200px;
    margin: 20px auto;
    padding: 0 16px;
}
.account-content-page .account-sidebar {
    background: #fff;
    border: 1px solid #eee;
    border-radius: 10px;
    padding: 16px;
    position: sticky;
    top: 16px;
}
.account-content-page .side-head {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
}
.account-content-page .side-avatar { width: 36px; height: 36px; border-radius:50%; object-fit:cover; }
.account-content-page .side-username { font-weight:700; }
.account-content-page .side-edit-hint { font-size:12px; color:#888; }
.account-content-page .side-nav { display:flex; flex-direction:column; gap:8px; }
.account-content-page .tab-btn {
    display:flex; align-items:center; gap:8px;
    padding:10px 12px; border-radius:8px;
    text-decoration:none; color:#333; background:#fff;
    border:1px solid #ececec; transition:.15s;
}
.account-content-page .tab-btn:hover { background:#e9f2ff; color:#1677ff; border-color:#d6e6ff; }
.account-content-page .tab-btn.active { background:#e9f2ff; color:#1677ff; font-weight:700; border-color:#1677ff; box-shadow:0 0 0 1px #1677ff inset; }

.account-content-page .account-content {
    background: #fff;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 1px 3px rgba(0,0,0,.05);
}
.account-content-page .row-between {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:16px;
}
.account-content-page .btn { padding:6px 12px; border-radius:6px; border:1px solid #ddd; background:#fff; cursor:pointer; }
.account-content-page .btn-primary { background:#ef4444; color:#fff; border-color:#ef4444; }
.account-content-page .btn[disabled] { opacity:.6; cursor:not-allowed; }
.account-content-page .link { text-decoration:none; cursor:pointer; }
.account-content-page .link.danger { color:#ef4444; border:none; }

.account-content-page .addr-item {
    display:flex;
    justify-content:space-between;
    gap:16px;
    padding:16px 0;
    border-bottom:1px solid #eee;
}
.account-content-page .addr-left .name { font-weight:bold; font-size:15px; }
.account-content-page .muted { color:#6b7280; font-size:13px; }
.account-content-page .badge { border:1px solid #ef4444; color:#ef4444; padding:2px 8px; border-radius:6px; font-size:12px; margin-left:8px; }

.account-content-page .row-end { display:flex; justify-content:flex-end; gap:12px; margin-top:8px; }

/* MODAL */
.account-content-page .modal {
    position: fixed; inset:0; background: rgba(0,0,0,.35);
    display: flex; align-items:center; justify-content:center;
    z-index: 9999;
}
.account-content-page .modal.hidden { display:none; }
.account-content-page .modal-body { background:#fff; width:min(720px,92vw); border-radius:12px; padding:20px; }
.account-content-page .modal-body .modal-title { font-size:20px; font-weight:600; margin-bottom:12px; }

@media (max-width: 768px) {
    .account-content-page .account-shell { grid-template-columns:1fr; }
    .account-content-page .account-sidebar { position: relative; top:0; }
} 
/* ============================
   MODAL THÊM ĐỊA CHỈ
============================ */

#modalAddr {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.4);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 999;
}

/* Ẩn mặc định */
#modalAddr.hidden {
    display: none;
}

/* Khung trắng */
#modalAddr .modal-body {
    background: #fff;
    width: 95%;
    max-width: 520px;
    padding: 28px 30px;
    border-radius: 16px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.2);
    animation: modalIn .25s ease;
}

@keyframes modalIn {
    from { transform: scale(0.88); opacity: 0; }
    to   { transform: scale(1); opacity: 1; }
}

/* Tiêu đề */
#modalAddr .modal-title {
    font-size: 22px;
    font-weight: 700;
    color: #111827;
    margin-bottom: 18px;
}

/* GRID 2 cột */
#modalAddr .grid2 {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 14px;
    margin-bottom: 14px;
}

/* GRID 3 cột */
#modalAddr .grid3 {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 14px;
    margin-bottom: 14px;
}

/* Input + Select */
#modalAddr input,
#modalAddr select {
    width: 100%;
    padding: 10px 12px;
    font-size: 14px;
    border: 1px solid #d1d5db;
    border-radius: 10px;
    background: #fafafa;
    transition: .2s;
}

/* Hover – Focus */
#modalAddr input:focus,
#modalAddr select:focus {
    border-color: #2563eb;
    background: #fff;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.25);
    outline: none;
}

/* Checkbox label */
#modalAddr label {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 10px 0 16px;
    font-size: 14px;
    color: #374151;
}

/* Checkbox */
#modalAddr input[type="checkbox"] {
    width: 16px;
    height: 16px;
}

/* Hàng nút */
#modalAddr .row-end {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 10px;
}

/* Nút chung */
#modalAddr .btn {
    padding: 10px 18px;
    border-radius: 10px;
    font-size: 14px;
    cursor: pointer;
    transition: .2s;
    border: none;
}

/* Nút trở lại */
#modalAddr #btnClose {
    background: #e5e7eb;
    color: #111;
}
#modalAddr #btnClose:hover {
    background: #d1d5db;
}

/* Nút hoàn thành */
#modalAddr .btn-primary {
    background: #2563eb;
    color: #fff;
}
#modalAddr .btn-primary:hover {
    background: #1d4ed8;
}

/* Mobile */
@media (max-width: 600px) {
    #modalAddr .grid2,
    #modalAddr .grid3 {
        grid-template-columns: 1fr;
    }
}

</style>

<script>
// Modal Thêm địa chỉ
const modal = document.getElementById('modalAddr');
document.getElementById('btnAdd').onclick = () => modal.classList.remove('hidden');
document.getElementById('btnClose').onclick = () => modal.classList.add('hidden');

// Modal Xóa địa chỉ
(function(){
    const modalDel = document.getElementById('addrConfirmModal');
    const txt = document.getElementById('addrConfirmText');
    const btnOk = document.getElementById('addrBtnConfirm');
    const btnCan = document.getElementById('addrBtnCancel');
    const formDel = document.getElementById('addrDeleteForm');
    const hidId = document.getElementById('addrDeleteId');

    let pendingId = null;
    document.addEventListener('click', function(e){
        const btn = e.target.closest('.btn-delete-addr');
        if(!btn) return;
        e.preventDefault();
        pendingId = btn.dataset.id;
        txt.textContent = 'Bạn có chắc chắn muốn xoá địa chỉ: ' + btn.dataset.label + ' ?';
        modalDel.classList.remove('hidden');
    });

    btnCan.addEventListener('click', function(){ pendingId=null; modalDel.classList.add('hidden'); });
    btnOk.addEventListener('click', function(){
        if(!pendingId) return;
        hidId.value = pendingId;
        modalDel.classList.add('hidden');
        formDel.submit();
    });
})();
(function () {
    const CONTEXT = '/' + window.location.pathname.split('/')[1];
    const DATA_URL = CONTEXT + '/data/hanhchinhvn.json';

    const selProv = document.getElementById('selTinh');
    const selDist = document.getElementById('selHuyen');
    const selWard = document.getElementById('selXa');

    if (!selProv || !selDist || !selWard) return;

    let HC = null;

    const reset = (sel, placeholder) => {
        sel.innerHTML = '';
        const opt = document.createElement('option');
        opt.value = '';
        opt.textContent = placeholder;
        sel.appendChild(opt);
    };

    const fillProvinces = () => {
        reset(selProv, 'Tỉnh/Thành phố');
        Object.entries(HC).forEach(([code, p]) => {
            selProv.add(new Option(p.name, code));
        });
        selProv.disabled = false;
    };

    const fillDistricts = (provCode) => {
        reset(selDist, 'Quận/Huyện');
        reset(selWard, 'Phường/Xã');
        selDist.disabled = true;
        selWard.disabled = true;

        if (!provCode || !HC[provCode]) return;

        const p = HC[provCode];
        const districts = p['quan-huyen'] || {};
        Object.entries(districts).forEach(([code, d]) => {
            selDist.add(new Option(d.name, code));
        });

        selDist.disabled = false;
    };

    const fillWards = (provCode, distCode) => {
        reset(selWard, 'Phường/Xã');
        selWard.disabled = true;

        const dist = HC?.[provCode]?.['quan-huyen']?.[distCode];
        if (!dist) return;

        const wards = dist['xa-phuong'] || {};
        Object.entries(wards).forEach(([code, w]) => {
            selWard.add(new Option(w.name, code));
        });

        selWard.disabled = false;
    };

    selProv.addEventListener('change', () => {
        fillDistricts(selProv.value);
    });

    selDist.addEventListener('change', () => {
        fillWards(selProv.value, selDist.value);
    });

    fetch(DATA_URL)
        .then(r => r.json())
        .then(json => {
            HC = json;
            fillProvinces();
        })
        .catch(err => console.error('Lỗi tải hanhchinhvn.json:', err));
})();
</script>

<script>
// ==============================
// GÁN TEXT TỈNH - HUYỆN - XÃ KHI SUBMIT FORM
// ==============================
document.getElementById('formAddr').addEventListener('submit', function () {
    const getText = (sel) => sel.options[sel.selectedIndex]?.text?.trim() || '';
    document.getElementById('hidTinh').value = getText(document.getElementById('selTinh'));
    document.getElementById('hidHuyen').value = getText(document.getElementById('selHuyen'));
    document.getElementById('hidXa').value = getText(document.getElementById('selXa'));
});
</script>

<jsp:include page="footer.jsp" />
