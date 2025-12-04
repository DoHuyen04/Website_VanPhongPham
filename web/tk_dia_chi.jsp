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
                    <div class="side-username">
                        <c:out value="${nguoiDung.tenDangNhap}" default="Khách"/>
                    </div>
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


        <!-- MAIN CONTENT -->
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
                                ${d.hoTen}
                                <span class="muted">(${d.soDienThoai})</span>

                                <c:if test="${d.macDinh}">
                                    <span class="badge">Mặc định</span>
                                </c:if>
                            </div>

                            <div class="muted">
                                ${d.diaChiDuong}, ${d.xaPhuong}, ${d.quanHuyen}, ${d.tinhThanh}
                            </div>
                        </div>

                        <div class="addr-actions">
                            <form method="post" action="${pageContext.request.contextPath}/DiaChiServlet">
                                <input type="hidden" name="action" value="setDefault">
                                <input type="hidden" name="id" value="${d.id}">
                                <button class="btn" ${d.macDinh ? "disabled" : ""}>
                                    Thiết lập mặc định
                                </button>
                            </form>

                            <button type="button"
                                    class="link danger btn-delete-addr"
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


    <!-- MODAL XÓA -->
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
    </form>

</div>


<!-- ================== CSS ================== -->
<style>
.account-content-page { font-family: Arial; color:#111827; }
.account-shell {
    display:grid; grid-template-columns:260px 1fr; gap:24px;
    max-width:1200px; margin:20px auto; padding:0 16px;
}
.account-sidebar {
    background:#fff; border:1px solid #eee; border-radius:10px;
    padding:16px; position:sticky; top:16px;
}
.side-head{display:flex;align-items:center;gap:10px;margin-bottom:12px;}
.side-avatar{width:36px;height:36px;border-radius:50%;object-fit:cover;}
.side-nav{display:flex;flex-direction:column;gap:8px;}
.tab-btn{padding:10px;border-radius:8px;border:1px solid #ddd;text-decoration:none;color:#333;}
.tab-btn.active, .tab-btn:hover{background:#e9f2ff;color:#1677ff;border-color:#1677ff;}

.account-content{
    background:#fff;padding:20px;border-radius:10px;
    box-shadow:0 1px 3px rgba(0,0,0,.05);
}
.row-between{display:flex;justify-content:space-between;align-items:center;}

.btn{padding:6px 12px;border-radius:6px;border:1px solid #ddd;background:#fff;}
.btn-primary{background:#ef4444;color:#fff;border-color:#ef4444;}

.addr-item{display:flex;justify-content:space-between;padding:16px 0;border-bottom:1px solid #eee;}
.muted{color:#6b7280;font-size:13px;}
.badge{border:1px solid #ef4444;color:#ef4444;padding:2px 8px;border-radius:6px;font-size:12px;}

.modal{position:fixed;inset:0;background:rgba(0,0,0,.4);display:flex;align-items:center;justify-content:center;}
.modal.hidden{display:none;}
.modal-body{background:#fff;padding:20px;border-radius:12px;width:min(720px,92vw);}

.grid2{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.grid3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;}

@media(max-width:768px){
    .account-shell{grid-template-columns:1fr;}
}
/* ===== MODAL OVERLAY ===== */
.modal {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,.45);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
    transition: .2s ease;
}

.modal.hidden {
    visibility: hidden;
    opacity: 0;
}

/* ===== MODAL BODY ===== */
.modal-body {
    background: #fff;
    width: 95%;
    max-width: 520px;
    padding: 24px 26px;
    border-radius: 14px;
    box-shadow: 0 10px 30px rgba(0,0,0,.18);
    animation: zoomIn .25s ease;
}

@keyframes zoomIn {
    from { transform: scale(.85); opacity: .5; }
    to   { transform: scale(1); opacity: 1; }
}

/* ===== TIÊU ĐỀ ===== */
.modal-title {
    font-size: 20px;
    font-weight: 700;
    margin-bottom: 14px;
    color: #2c3e50;
}

/* ===== INPUT & SELECT ===== */
.modal-body input,
.modal-body select {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    outline: none;
    transition: .15s ease;
    font-size: 14px;
}

.modal-body input:focus,
.modal-body select:focus {
    border-color: #3498db;
    box-shadow: 0 0 0 3px rgba(52,152,219,.25);
}

/* ===== GRID ===== */
.grid2 {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
    margin-bottom: 12px;
}

.grid3 {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    margin-bottom: 12px;
}

/* ===== BUTTONS ===== */
.btn {
    padding: 8px 16px;
    border-radius: 8px;
    cursor: pointer;
    background: #e5e7eb;
    border: 1px solid #d1d5db;
    transition: .15s ease;
}

.btn:hover {
    background: #d1d5db;
}

.btn-primary {
    background: #3498db;
    color: #fff;
    border: none;
}

.btn-primary:hover {
    background: #2980b9;
}

/* ===== ROW END ===== */
.row-end {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 14px;
}

/* ===== MOBILE ===== */
@media (max-width: 600px) {
    .grid2,
    .grid3 {
        grid-template-columns: 1fr;
    }
}

</style>
<script>
const tinhSel = document.getElementById("selTinh");
const huyenSel = document.getElementById("selHuyen");
const xaSel = document.getElementById("selXa");

async function loadData() {

    let data = await fetch("${pageContext.request.contextPath}/data/hanhchinhvn.json")
        .then(res => res.json());

    // Load Tỉnh/TP
    data.forEach(t => {
        let op = document.createElement("option");
        op.value = t.name;
        op.textContent = t.name;
        tinhSel.appendChild(op);
    });

    // Chọn tỉnh
    tinhSel.onchange = () => {
        huyenSel.innerHTML = "<option value=''>Quận/Huyện</option>";
        xaSel.innerHTML = "<option value=''>Phường/Xã</option>";
        huyenSel.disabled = true;
        xaSel.disabled = true;

        let t = data.find(item => item.name === tinhSel.value);
        if (!t) return;

        huyenSel.disabled = false;

        t.huyen.forEach(h => {
            let op = document.createElement("option");
            op.value = h.name;
            op.textContent = h.name;
            huyenSel.appendChild(op);
        });

        document.getElementById("hidTinh").value = tinhSel.value;
    };

    // Chọn huyện
    huyenSel.onchange = () => {
        xaSel.innerHTML = "<option value=''>Phường/Xã</option>";
        let t = data.find(item => item.name === tinhSel.value);
        let h = t.huyen.find(item => item.name === huyenSel.value);

        if (!h) return;
        xaSel.disabled = false;

        h.xa.forEach(x => {
            let op = document.createElement("option");
            op.value = x.name;
            op.textContent = x.name;
            xaSel.appendChild(op);
        });

        document.getElementById("hidHuyen").value = huyenSel.value;
    };

    // Chọn xã
    xaSel.onchange = () => {
        document.getElementById("hidXa").value = xaSel.value;
    };
}

loadData();


// ====================== MODAL THÊM ĐỊA CHỈ ======================
document.getElementById("btnAdd").onclick = () => {
    document.getElementById("modalAddr").classList.remove("hidden");
};
document.getElementById("btnClose").onclick = () => {
    document.getElementById("modalAddr").classList.add("hidden");
};

// ======================= MODAL XÓA ============================
const modalDel = document.getElementById("addrConfirmModal");

document.addEventListener("click", e => {
    const btn = e.target.closest(".btn-delete-addr");
    if (!btn) return;

    modalDel.classList.remove("hidden");

    document.getElementById("addrConfirmText").textContent = btn.dataset.label;
    document.getElementById("addrDeleteId").value = btn.dataset.id;
});

document.getElementById("addrBtnCancel").onclick = () =>
    modalDel.classList.add("hidden");

document.getElementById("addrBtnConfirm").onclick = () =>
    document.getElementById("addrDeleteForm").submit();
</script>

<jsp:include page="footer.jsp" />
