<%-- 
    Document   : tk_dia_chi
    Created on : 17 thg 10, 2025, 23:37:58
    Author     : daumai
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .address-container{
        width:80%;
        margin:20px auto;
        font-family:Arial, sans-serif
    }
    .address-header{
        display:flex;
        align-items:center;
        justify-content:space-between;
        margin:10px 0 6px
    }
    .address-header h2{
        font-size:28px;
        font-weight:800;
        margin:0
    }
    .add-address-btn{
        background:#1677ff;
        color:#fff;
        border:none;
        padding:10px 16px;
        border-radius:6px;
        cursor:pointer;
        text-decoration:none;
        display:inline-block
    }
    .address-list{
        margin-top:10px
    }
    .address-item{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        border-top:1px solid #eee;
        padding:22px 0
    }
    .address-info h3{
        margin:0 0 6px 0;
        font-size:20px;
        font-weight:800
    }
    .address-info h3 span{
        font-weight:500;
        color:#666;
        margin-left:10px
    }
    .address-info p{
        margin:0 0 10px 0;
        color:#666;
        font-size:16px;
        line-height:1.5
    }
    .default-tag{
        display:inline-block;
        border:1px solid #ee4d2d;
        color:#ee4d2d;
        font-size:13px;
        padding:3px 6px;
        border-radius:6px
    }
    .address-actions{
        text-align:right;
        min-width:260px
    }
    .link-action{
        color:#1677ff;
        margin-right:10px;
        text-decoration:none;
        font-size:15px
    }
    .link-danger{
        color:#ee4d2d;
        background:none;
        border:none;
        cursor:pointer;
        font-size:15px;
        margin-right:10px
    }
    .set-default-btn{
        border:1px solid #dcdcdc;
        background:#fff;
        padding:6px 12px;
        border-radius:6px;
        cursor:pointer;
        font-size:15px
    }
    .btn-disabled{
        opacity:.5;
        cursor:not-allowed
    }

    /* Form */
    .form-card{
        border:1px solid #eee;
        border-radius:8px;
        padding:16px;
        margin-top:12px;
        background:#fafafa
    }
    .form-row{
        display:flex;
        gap:12px;
        margin-bottom:12px
    }
    .form-col{
        flex:1;
        min-width:0
    }
    .form-col label{
        display:block;
        font-weight:600;
        margin-bottom:6px
    }
    .form-col input{
        width:100%;
        padding:9px 10px;
        border:1px solid #ddd;
        border-radius:6px;
        font-size:14px
    }
    .form-actions{
        display:flex;
        gap:10px;
        margin-top:8px
    }
    .btn-primary{
        background:#1677ff;
        color:#fff;
        border:none;
        padding:9px 14px;
        border-radius:6px;
        cursor:pointer
    }
    .btn-light{
        background:#f5f5f5;
        color:#333;
        border:1px solid #ddd;
        padding:9px 14px;
        border-radius:6px;
        cursor:pointer
    }
    /* ===== Confirm Modal ===== */
    .m-confirm{
        display:none;
        position:fixed;
        inset:0;
        z-index:9999
    }
    .m-confirm.open{
        display:block
    }
    .m-backdrop{
        position:absolute;
        inset:0;
        background:rgba(0,0,0,.45)
    }
    .m-dialog{
        position:absolute;
        left:50%;
        top:50%;
        transform:translate(-50%,-50%);
        width:min(520px,92%);
        background:#fff;
        border-radius:10px;
        box-shadow:0 10px 30px rgba(0,0,0,.2);
        padding:24px
    }
    .m-title{
        font-size:20px;
        text-align:center;
        margin-bottom:18px
    }
    .m-actions{
        display:flex;
        gap:12px;
        justify-content:center
    }
    .m-btn{
        min-width:120px;
        padding:10px 18px;
        border-radius:6px;
        border:1px solid #ddd;
        background:#f6f6f6;
        cursor:pointer
    }
    .m-danger{
        background:#e4573d;
        color:#fff;
        border-color:#e4573d
    }
    .m-btn:disabled{
        opacity:.6;
        cursor:not-allowed
    }
    .m-modal[hidden]{
        display:none
    }
    .m-modal .m-backdrop{
        position:fixed;
        inset:0;
        background:rgba(0,0,0,.35)
    }
    .m-modal .m-dialog{
        position:fixed;
        left:50%;
        top:50%;
        transform:translate(-50%,-50%);
        width:720px;
        max-width:92vw;
        background:#fff;
        border-radius:12px;
        padding:20px
    }
    .m-title{
        font-size:20px;
        font-weight:700;
        margin-bottom:12px
    }
    .m-row{
        display:flex;
        flex-direction:column;
        gap:6px;
        margin-bottom:12px
    }
    .m-row input{
        height:44px;
        border:1px solid #ddd;
        border-radius:8px;
        padding:0 12px
    }
    .m-chipgroup{
        display:flex;
        gap:12px
    }
    .chip{
        border:1px solid #ddd;
        border-radius:8px;
        padding:8px 12px;
        background:#fff;
        cursor:pointer
    }
    .chip.active{
        border-color:#e65b3f;
        background:#fde8e2
    }
    .m-actions.between{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-top:6px
    }
    .m-btn{
        border:none;
        border-radius:8px;
        height:44px;
        padding:0 18px;
        cursor:pointer
    }
    .m-btn.m-primary{
        background:#e65b3f;
        color:#fff
    }
    .m-btn.m-ghost{
        background:#f3f4f6
    }
    .chk{
        display:flex;
        align-items:center;
        gap:8px
    }
</style>
<div class="address-container">
    <div class="address-header">
        <h2>Địa chỉ của tôi</h2>
        <button id="btnShowAdd" class="add-address-btn">+ Thêm địa chỉ mới</button>
    </div>
    <div id="addFormBox" class="form-card" style="display: ${mode == 'add' ? 'block' : 'none'};">
        <form id="addForm">
            <input type="hidden" name="action" value="add"/>
            <input type="hidden" name="ajax" value="1"/>

            <div class="form-row">
                <div class="form-col">
                    <label>Họ và tên</label>
                    <input name="hoTen" required/>
                </div>
                <div class="form-col">
                    <label>Số điện thoại</label>
                    <input name="soDienThoai" required/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-col">
                    <label>Số nhà, đường</label>
                    <input name="diaChiDuong" required/>
                </div>
            </div>

            <div class="form-row">
                <div class="form-col">
                    <label>Xã/Phường</label>
                    <input name="xaPhuong" required/>
                </div>
                <div class="form-col">
                    <label>Quận/Huyện</label>
                    <input name="quanHuyen" required/>
                </div>
                <div class="form-col">
                    <label>Tỉnh/Thành</label>
                    <input name="tinhThanh" required/>
                </div>
            </div>

            <div class="form-row">
                <label><input type="checkbox" name="macDinh"/> Đặt làm mặc định</label>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-primary">Lưu</button>
                <button type="button" id="btnCancelAdd" class="btn-light">Hủy</button>
            </div>
        </form>
    </div>

    <!-- DANH SÁCH ĐỊA CHỈ -->
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

    <div class="address-list" id="addressList">

        <!-- Nếu chưa có địa chỉ -->
        <c:if test="${empty dsDiaChi}">
            <div style="color:#999">[Không có địa chỉ để hiển thị hoặc chưa đi qua Servlet]</div>
        </c:if>

        <!-- Lặp qua danh sách địa chỉ -->
        <c:forEach var="dc" items="${dsDiaChi}">
            <div class="address-item" id="addr-${dc.id}">
                <div class="address-info">
                    <h3>
                        <span class="js-name"><c:out value="${dc.hoTen}"/></span>
                        <span class="js-phone">(+84) <c:out value="${dc.soDienThoai}"/></span>
                    </h3>
                    <p>
                        <span class="js-detail"><c:out value="${dc.diaChiDuong}"/></span><br/>
                        <span class="js-kv">
                            <c:out value="${dc.xaPhuong}"/>, 
                            <c:out value="${dc.quanHuyen}"/>, 
                            <c:out value="${dc.tinhThanh}"/>
                        </span>
                    </p>
                    <c:if test="${dc.macDinh}">
                        <span class="default-tag">Mặc định</span>
                    </c:if>
                </div>

                <div class="address-actions">
                    <!-- ✅ Nút chỉnh sửa (mở modal cập nhật địa chỉ) -->
                    <button type="button" class="link-action js-edit-address"
                            data-id="${dc.id}"
                            data-ten="${fn:escapeXml(dc.hoTen)}"
                            data-sdt="${fn:escapeXml(dc.soDienThoai)}"
                            data-kv="${fn:escapeXml(dc.tinhThanh)}, ${fn:escapeXml(dc.quanHuyen)}, ${fn:escapeXml(dc.xaPhuong)}"
                            data-diachi="${fn:escapeXml(dc.diaChiDuong)}"
                            data-macdinh="${dc.macDinh ? 1 : 0}">
                        Chỉnh sửa
                    </button>

                    <!-- Nút xóa -->
                    <c:if test="${!dc.macDinh}">
                        <button type="button" class="link-danger btn-delete" data-id="${dc.id}">
                            Xóa
                        </button>
                    </c:if>

                    <!-- Nút thiết lập mặc định -->
                    <button
                        class="set-default-btn ${dc.macDinh ? 'btn-disabled' : ''} btn-set-default"
                        data-id="${dc.id}"
                        ${dc.macDinh ? 'disabled' : ''}>
                        Thiết lập mặc định
                    </button>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- CONFIRM MODAL -->
    <div id="confirmModal" class="m-confirm">
        <div class="m-backdrop"></div>
        <div class="m-dialog">
            <div class="m-title">Bạn có chắc muốn xóa địa chỉ này?</div>
            <div class="m-actions">
                <button type="button" class="m-btn m-cancel">HỦY</button>
                <button type="button" class="m-btn m-danger m-ok">XÓA</button>
            </div>
        </div>
    </div>
    <!-- UPDATE ADDRESS MODAL -->
    <div id="addrModal" class="m-modal" hidden>
        <div class="m-backdrop"></div>
        <div class="m-dialog">
            <div class="m-title">Cập nhật địa chỉ</div>

            <form id="addrForm">
                <input type="hidden" name="id" id="ad-id">

                <div class="m-row">
                    <label>Họ và tên</label>
                    <input id="ad-ten" name="ten" type="text" required>
                </div>

                <div class="m-row">
                    <label>Số điện thoại</label>
                    <input id="ad-sdt" name="sdt" type="tel" required>
                </div>

                <div class="m-row">
                    <label>Tỉnh/Thành, Quận/Huyện, Phường/Xã</label>
                    <input id="ad-kv" name="kv" type="text" placeholder="VD: Hà Nội, Quận Hoàng Mai, Phường Định Công" required>
                </div>

                <div class="m-row">
                    <label>Địa chỉ cụ thể</label>
                    <input id="ad-diachi" name="diachi" type="text" required>
                </div>

                <div class="m-row">
                    <label class="chk">
                        <input id="ad-macdinh" name="macdinh" type="checkbox">
                        Đặt làm địa chỉ mặc định
                    </label>
                </div>

                <div class="m-actions between">
                    <button type="button" class="m-btn m-ghost" id="ad-cancel">Trở Lại</button>
                    <button type="submit" class="m-btn m-primary" id="ad-save">Hoàn thành</button>
                </div>
            </form>
        </div>
    </div>

</div>
<script>
    (() => {
    const baseUrl = '<c:url value="/DiaChiServlet"/>';
    // ==== Add form ====
    const btnShow = document.getElementById('btnShowAdd');
    const box = document.getElementById('addFormBox');
    const addForm = document.getElementById('addForm');
    const btnCancelAdd = document.getElementById('btnCancelAdd');
    const list = document.getElementById('addressList');
    btnShow?.addEventListener('click', () => box.style.display = 'block');
    btnCancelAdd?.addEventListener('click', () => { box.style.display = 'none'; addForm.reset(); });
    addForm?.addEventListener('submit', async (e) => {
    e.preventDefault();
    const fd = new FormData(addForm);
    try {
    const res = await fetch(baseUrl, {
    method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
            body: new URLSearchParams(fd)
    });
    const json = await res.json();
    if (!json.success) { alert(json.message || 'Lưu thất bại'); return; }

    const d = json.item;
    // Nếu set mặc định -> gỡ badge & bật nút ở item khác
    if (d.macDinh) {
    document.querySelectorAll('.address-item').forEach(item => {
    item.querySelector('.default-tag')?.remove();
    const sdb = item.querySelector('.btn-set-default');
    sdb && (sdb.disabled = false, sdb.classList.remove('btn-disabled'));
    const del = item.querySelector('.btn-delete');
    del && (del.style.display = 'inline-block');
    });
    }

    const html
            < div class = "address-item" id = "addr-\${d.id}" >
            <div class="address-info">
        <h3>
    <span class="js-name">\${d.hoTen}</span>
            <span class="js-phone">(+84) \${d.soDienThoai}</span>
        </h3>
        <p>
            <span class="js-detail">\${d.diaChiDuong}</span><br/>
            <span class="js-kv">\${d.xaPhuong}, \${d.quanHuyen}, \${d.tinhThanh}</span>
    </p>
    \${d.macDinh ? '<span class="default-tag">Mặc định</span>' : ''}
    </div>
    <div class="address-actions">
        <button type="button" class="link-action js-edit-address"
        data-id="\${d.id}"
        data-ten="\${(d.hoTen || '').replace(/\"/g, '&quot;')}"
        data-sdt="\${d.soDienThoai}"
        data-kv="\${d.tinhThanh}, \${d.quanHuyen}, \${d.xaPhuong}"
        data-diachi="\${(d.diaChiDuong || '').replace(/\"/g, '&quot;')}"
        data-macdinh="\${d.macDinh ? 1 : 0}">
            Chỉnh sửa
        </button>
        \${d.macDinh ? '' : `<button type="button" class="link-danger btn-delete" data-id="\${d.id}">Xóa</button>`}
        <button class="set-default-btn \${d.macDinh ? 'btn-disabled' : ''} btn-set-default"
        data-id="\${d.id}" \${d.macDinh ? 'disabled' : ''}>
            Thiết lập mặc định
    </button>
    </div>
</div>;
    list.insertAdjacentHTML('afterbegin', html);
    addForm.reset();
    box.style.display = 'none';
    } catch (err) {
    console.error(err);
    alert('Lỗi mạng. Vui lòng thử lại!');
    }
    });
    // ==== Confirm modal (một nơi duy nhất) ====
    const confirmModal = document.getElementById('confirmModal');
    const confirmCancel = confirmModal?.querySelector('.m-cancel');
    const confirmOk = confirmModal?.querySelector('.m-ok');
    const confirmBackdrop = confirmModal?.querySelector('.m-backdrop');
    let deletingId = null;
    function openConfirm(id) { deletingId = id; confirmModal.classList.add('open'); }
    function closeConfirm()  { deletingId = null; confirmModal.classList.remove('open'); }

    confirmCancel?.addEventListener('click', closeConfirm);
    confirmBackdrop?.addEventListener('click', closeConfirm);
    document.addEventListener('keydown', (ev) => {
    if (ev.key === 'Escape' && confirmModal.classList.contains('open')) closeConfirm();
    });
    confirmOk?.addEventListener('click', async () => {
    if (!deletingId) return;
    confirmOk.disabled = true;
    try {
    const res = await fetch(baseUrl, {
    method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
            body: new URLSearchParams({action:'delete', id: deletingId})
    });
    const json = await res.json();
    if (json.success) {
    document.getElementById('addr-' + deletingId)?.remove();
    closeConfirm();
    } else {
    alert(json.message || 'Xóa thất bại');
    }
    } catch {
    alert('Lỗi mạng. Vui lòng thử lại!');
    } finally {
    confirmOk.disabled = false;
    }
    });
    // ==== Delegation cho Set Default + mở Confirm delete ====
    document.addEventListener('click', async (e) => {
    // Set mặc định
    const setBtn = e.target.closest('.btn-set-default');
    if (setBtn && !setBtn.disabled) {
    const id = setBtn.dataset.id;
    setBtn.disabled = true;
    try {
    const res = await fetch(baseUrl, {
    method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
            body: new URLSearchParams({action:'setDefault', id})
    });
    const json = await res.json();
    if (json.success) {
    document.querySelectorAll('.address-item').forEach(item => {
    item.querySelector('.default-tag')?.remove();
    const sdb = item.querySelector('.btn-set-default');
    sdb && (sdb.disabled = false, sdb.classList.remove('btn-disabled'));
    const del = item.querySelector('.btn-delete');
    del && (del.style.display = 'inline-block');
    });
    const active = document.getElementById('addr-' + id);
    active.querySelector('.address-info').insertAdjacentHTML('beforeend', '<span class="default-tag">Mặc định</span>');
    setBtn.disabled = true; setBtn.classList.add('btn-disabled');
    const delBtn = active.querySelector('.btn-delete'); delBtn && (delBtn.style.display = 'none');
    } else {
    alert(json.message || 'Thiết lập mặc định thất bại');
    setBtn.disabled = false;
    }
    } catch {
    alert('Lỗi mạng. Vui lòng thử lại!');
    setBtn.disabled = false;
    }
    return;
    }

    // Mở confirm delete
    const delBtn = e.target.closest('.btn-delete');
    if (delBtn) {
    e.preventDefault();
    openConfirm(delBtn.dataset.id);
    }
    });
    // ==== Modal SỬA địa chỉ ====
    const editModal = document.getElementById('addrModal');
    const editForm = document.getElementById('addrForm');
    const fId = document.getElementById('ad-id');
    const fTen = document.getElementById('ad-ten');
    const fSdt = document.getElementById('ad-sdt');
    const fKv = document.getElementById('ad-kv');
    const fDiaChi = document.getElementById('ad-diachi');
    const fMDinh = document.getElementById('ad-macdinh');
    const openEdit = () => editModal.hidden = false;
    const closeEdit = () => editModal.hidden = true;
    document.addEventListener('click', (ev) => {
    const btn = ev.target.closest('.js-edit-address');
    if (!btn) return;
    fId.value = btn.dataset.id || '';
    fTen.value = btn.dataset.ten || '';
    fSdt.value = btn.dataset.sdt || '';
    fKv.value = btn.dataset.kv || '';
    fDiaChi.value = btn.dataset.diachi || '';
    fMDinh.checked = btn.dataset.macdinh === '1';
    openEdit();
    });
    editModal.querySelector('.m-backdrop')?.addEventListener('click', closeEdit);
    document.getElementById('ad-cancel')?.addEventListener('click', closeEdit);
    editForm?.addEventListener('submit', async (ev) => {
    ev.preventDefault();
    const sdt = fSdt.value.trim();
    if (!/^\+?\d[\d\s\-()]{6,}$/.test(sdt)) { alert('Số điện thoại không hợp lệ'); return; }
    if (!fTen.value.trim() || !fKv.value.trim() || !fDiaChi.value.trim()) { alert('Vui lòng nhập đủ thông tin'); return; }

    const payload = {
    action:'capnhat_dia_chi',
            id: fId.value,
            ten: fTen.value.trim(),
            sdt,
            kv: fKv.value.trim(),
            diachi: fDiaChi.value.trim(),
            macdinh: fMDinh.checked ? 1 : 0
    };
    try {
    const res = await fetch(baseUrl, {
    method:'POST',
            headers:{'Content-Type':'application/json;charset=UTF-8'},
            body: JSON.stringify(payload)
    });
    const json = await res.json();
    if (!json.ok) { alert(json.message || 'Cập nhật thất bại'); return; }

    const d = json.address;
    const item = document.getElementById(`addr-${d.id}`);
    if (item) {
    item.querySelector('.js-name').textContent = d.hoTen;
    item.querySelector('.js-phone').textContent = `(+84) ${d.soDienThoai}`;
    item.querySelector('.js-detail').textContent = d.diaChiDuong;
    item.querySelector('.js-kv').textContent = `${d.xaPhuong}, ${d.quanHuyen}, ${d.tinhThanh}`;
        const editBtn = item.querySelector('.js-edit-address');
        editBtn.dataset.ten = d.hoTen;
        editBtn.dataset.sdt = d.soDienThoai;
        editBtn.dataset.kv = `${d.tinhThanh}, ${d.quanHuyen}, ${d.xaPhuong}`;
            editBtn.dataset.diachi = d.diaChiDuong;
            editBtn.dataset.macdinh = d.macDinh ? '1' : '0';
            const tag = item.querySelector('.default-tag');
            const btnSet = item.querySelector('.btn-set-default');
            if (d.macDinh) {
            if (!tag) item.querySelector('.address-info').insertAdjacentHTML('beforeend', '<span class="default-tag">Mặc định</span>');
            btnSet && (btnSet.disabled = true, btnSet.classList.add('btn-disabled'));
            } else {
            tag && tag.remove();
            btnSet && (btnSet.disabled = false, btnSet.classList.remove('btn-disabled'));
            }
            }
            closeEdit();
            } catch (e) {
            console.error(e);
            alert('Không thể cập nhật. Vui lòng thử lại.');
            }
            });
            })();
</script>
