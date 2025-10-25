<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Địa chỉ của tôi</title>
        <style>
            body {
                background:#f6f6f6;
                font-family:Arial, sans-serif;
            }
            .account-content{
                background:#fff;
                border:1px solid #eee;
                border-radius:10px;
                padding:20px;
                margin:30px auto;
                max-width:900px
            }
            .row-between{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:10px
            }
            .addr-item{
                display:flex;
                justify-content:space-between;
                gap:16px;
                padding:16px 0;
                border-bottom:1px solid #eee
            }
            .addr-left .name{
                font-weight:bold;
                font-size:15px
            }
            .muted{
                color:#6b7280;
                font-size:13px
            }
            .badge{
                border:1px solid #ef4444;
                color:#ef4444;
                padding:2px 8px;
                border-radius:6px;
                font-size:12px;
                margin-left:8px
            }
            .addr-actions form{
                display:inline
            }
            .btn,.link{
                padding:6px 10px;
                border-radius:6px;
                border:1px solid #ddd;
                background:#fff;
                cursor:pointer
            }
            .btn-primary{
                background:#ef4444;
                color:#fff;
                border-color:#ef4444
            }
            .btn[disabled]{
                opacity:.6;
                cursor:not-allowed
            }
            .link.danger{
                color:#ef4444;
                border:none
            }
            .modal{
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.35);
                display:flex;
                align-items:center;
                justify-content:center
            }
            .modal.hidden{
                display:none
            }
            .modal-body{
                background:#fff;
                width:min(720px,92vw);
                border-radius:12px;
                padding:20px
            }
            .modal-title{
                font-size:20px;
                font-weight:600;
                margin-bottom:12px
            }
            .grid2{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:12px
            }
            .grid3{
                display:grid;
                grid-template-columns:1fr 1fr 1fr;
                gap:12px;
                margin:12px 0
            }
            input,select{
                padding:10px;
                border:1px solid #e5e7eb;
                border-radius:8px
            }
            .mapbox{
                background:#f9fafb;
                border:1px dashed #e5e7eb;
                border-radius:10px;
                padding:12px;
                margin:12px 0
            }
            .row-end{
                display:flex;
                justify-content:flex-end;
                gap:12px;
                margin-top:8px
            }
        </style>
    </head>
    <body>

        <div class="account-content">
            <div class="row-between">
                <h2>Địa chỉ của tôi</h2>
                <button class="btn btn-primary" id="btnAdd">+ Thêm địa chỉ mới</button>
            </div>

            <!-- DANH SÁCH ĐỊA CHỈ -->
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
                        <!-- Nút đặt mặc định -->
                        <form method="post" action="${pageContext.request.contextPath}/DiaChiServlet">
                            <input type="hidden" name="action" value="setDefault">
                            <input type="hidden" name="id" value="${d.id}">
                            <input type="hidden" name="backTo"
                                   value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">
                            <button class="btn" ${d.macDinh ? "disabled" : ""}>Thiết lập mặc định</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/DiaChiServlet" onsubmit="return false;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${d.id}">
                            <input type="hidden" name="backTo"
                                   value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">

                            <!-- Nút bấm hiển thị modal xác nhận -->
                            <button type="button"
                                    class="link danger btn-delete-addr"
                                    data-id="${d.id}"
                                    data-label="${d.hoTen} - ${d.diaChiDuong}, ${d.xaPhuong}, ${d.quanHuyen}, ${d.tinhThanh}">
                                Xoá
                            </button>
                        </form>


                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- ===== MODAL THÊM ĐỊA CHỈ ===== -->
        <div id="modalAddr" class="modal hidden">
            <div class="modal-body">
                <div class="modal-title">Thêm địa chỉ mới</div>
                <form id="formAddr" method="post" action="${pageContext.request.contextPath}/DiaChiServlet">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="backTo"
                           value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">
                    <div class="grid2">
                        <input name="hoTen" placeholder="Họ và tên" required>
                        <input name="soDienThoai" placeholder="Số điện thoại" required>
                    </div>

                    <div class="grid3">
                        <select id="selTinh" name="tinhThanh" required>
                            <option value="">Tỉnh/Thành phố</option>
                        </select>
                        <select id="selHuyen" name="quanHuyen" required disabled>
                            <option value="">Quận/Huyện</option>
                        </select>
                        <select id="selXa" name="xaPhuong" required disabled>
                            <option value="">Phường/Xã</option>
                        </select>
                    </div>

                    <input name="diaChiDuong" placeholder="Địa chỉ cụ thể (số nhà, đường...)" required>

                    <div class="mapbox">
                        <input type="hidden" name="mapUrl" id="mapUrl">
                        <div id="mapPreviewBox" style="margin-top:8px"></div>
                    </div>


                    <label><input type="checkbox" name="macDinh"> Đặt làm địa chỉ mặc định</label>

                    <div class="row-end">
                        <button type="button" class="btn" id="btnClose">Trở lại</button>
                        <button class="btn btn-primary">Hoàn thành</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            const DEFAULT_MAP_URL = 'https://www.google.com/maps/@21.0015,105.8157,16z';

            function extractLatLng(url) {
                let m = url.match(/@(-?\d+\.?\d*),\s*(-?\d+\.?\d*),\s*\d+(\.\d+)?z/);
                if (m)
                    return {lat: parseFloat(m[1]), lng: parseFloat(m[2])};
                m = url.match(/[?&](q|ll)=(-?\d+\.?\d*),\s*(-?\d+\.?\d*)/);
                if (m)
                    return {lat: parseFloat(m[2]), lng: parseFloat(m[3])};
                return null;
            }

            function renderFixedMap(url) {
                const hidden = document.getElementById('mapUrl');
                const box = document.getElementById('mapPreviewBox');
                hidden.value = url;           
                box.innerHTML = '';

                const ll = extractLatLng(url);
                if (ll) {
                    const iframe = document.createElement('iframe');
                    iframe.src = `https://maps.google.com/maps?q=${ll.lat},${ll.lng}&z=16&output=embed`;
                    iframe.width = '100%';
                    iframe.height = '220';
                    iframe.style.border = '0';
                    iframe.loading = 'lazy';
                    box.appendChild(iframe);
                } else {
                    const a = document.createElement('a');
                    a.href = url;
                    a.target = '_blank';
                    a.rel = 'noopener';
                    a.textContent = 'Mở trên Google Maps';
                    a.className = 'btn';
                    box.appendChild(a);
                }
            }
            document.getElementById('btnAddAddr')?.addEventListener('click', () => {
                renderFixedMap(DEFAULT_MAP_URL);
            });

            document.addEventListener('DOMContentLoaded', () => {
                if (document.getElementById('mapPreviewBox')) {
                    renderFixedMap(DEFAULT_MAP_URL);
                }
            });
        </script>

        <script>
            const modal = document.getElementById('modalAddr');
            document.getElementById('btnAdd').onclick = () => modal.classList.remove('hidden');
            document.getElementById('btnClose').onclick = () => modal.classList.add('hidden');

            const selTinh = document.getElementById('selTinh');
            const selHuyen = document.getElementById('selHuyen');
            const selXa = document.getElementById('selXa');

            let HC = null;
            (async function () {
                const res = await fetch('js/data/hanhChinhVN.json');
                HC = await res.json();
                HC.tinh.forEach(t => {
                    const op = document.createElement('option');
                    op.value = t.name;
                    op.textContent = t.name;
                    op.dataset.code = t.code;
                    selTinh.appendChild(op);
                });
            })();

            selTinh.addEventListener('change', () => {
                selHuyen.innerHTML = '<option value="">Quận/Huyện</option>';
                selXa.innerHTML = '<option value="">Phường/Xã</option>';
                selHuyen.disabled = true;
                selXa.disabled = true;
                const t = HC?.tinh.find(x => x.name === selTinh.value);
                if (!t)
                    return;
                t.huyen.forEach(h => {
                    const op = document.createElement('option');
                    op.value = h.name;
                    op.textContent = h.name;
                    selHuyen.appendChild(op);
                });
                selHuyen.disabled = false;
            });

            selHuyen.addEventListener('change', () => {
                selXa.innerHTML = '<option value="">Phường/Xã</option>';
                selXa.disabled = true;
                const t = HC?.tinh.find(x => x.name === selTinh.value);
                const h = t?.huyen.find(x => x.name === selHuyen.value);
                if (!h)
                    return;
                h.xa.forEach(x => {
                    const op = document.createElement('option');
                    op.value = x.name;
                    op.textContent = x.name;
                    selXa.appendChild(op);
                });
                selXa.disabled = false;
            });

        // Thêm vị trí: dán link Google Maps
            const btnAddMap = document.getElementById('btnAddMap');
            const mapPreview = document.getElementById('mapPreview');
            btnAddMap.addEventListener('click', () => {
                const link = prompt("https://www.google.com/maps/?hl=vi");
                if (link && /^https?:\/\//i.test(link)) {
                    mapPreview.innerHTML = `Đã gắn: <a href="${link}" target="_blank">Xem vị trí</a>`;
                } else if (link !== null) {
                    alert("Link không hợp lệ. Hãy dán URL Google Maps.");
                }
            });
        </script>
        <!-- MODAL XÁC NHẬN XOÁ ĐỊA CHỈ -->
        <div id="addrConfirmModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.35);align-items:center;justify-content:center;z-index:9999">
            <div style="background:#fff;border-radius:12px;max-width:420px;width:92%;padding:16px;box-shadow:0 10px 30px rgba(0,0,0,.2)">
                <h3 style="margin:0 0 8px;font-size:18px">Xác nhận xoá địa chỉ</h3>
                <p id="addrConfirmText" style="margin:0 0 16px;color:#6b7280">
                    Bạn có chắc chắn muốn xoá địa chỉ này không?
                </p>
                <div style="display:flex;gap:8px;justify-content:flex-end">
                    <button type="button" id="addrBtnCancel" style="padding:8px 12px;border:1px solid #e5e7eb;background:#fff;border-radius:8px;cursor:pointer">Huỷ</button>
                    <button type="button" id="addrBtnConfirm" style="padding:8px 12px;border:0;background:#ef4444;color:#fff;border-radius:8px;cursor:pointer">Xác nhận</button>
                </div>
            </div>
        </div>

        <form id="addrDeleteForm" method="post" action="${pageContext.request.contextPath}/DiaChiServlet" style="display:none">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="addrDeleteId">
            <input type="hidden" name="backTo" value="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=address">
        </form>
        <script>
            (function () {
                const modal = document.getElementById('addrConfirmModal');
                const txt = document.getElementById('addrConfirmText');
                const btnOk = document.getElementById('addrBtnConfirm');
                const btnCan = document.getElementById('addrBtnCancel');
                const formDel = document.getElementById('addrDeleteForm');
                const hidId = document.getElementById('addrDeleteId');

                let pendingId = null;
                document.addEventListener('click', function (e) {
                    const btn = e.target.closest('.btn-delete-addr');
                    if (!btn)
                        return;

                    e.preventDefault(); 
                    pendingId = btn.dataset.id;

                    const label = btn.dataset.label || '';
                    if (label) {
                        txt.textContent = 'Bạn có chắc chắn muốn xoá địa chỉ: ' + label + ' ?';
                    } else {
                        txt.textContent = 'Bạn có chắc chắn muốn xoá địa chỉ này không?';
                    }

                    modal.style.display = 'flex';
                });

                // Huỷ
                btnCan.addEventListener('click', function () {
                    pendingId = null;
                    modal.style.display = 'none';
                });

                // Xác nhận
                btnOk.addEventListener('click', function () {
                    if (!pendingId)
                        return;
                    hidId.value = pendingId;
                    modal.style.display = 'none';
                    formDel.submit(); // gửi POST đến DiaChiServlet
                });

                // Click ra ngoài để đóng
                modal.addEventListener('click', function (e) {
                    if (e.target === modal) {
                        pendingId = null;
                        modal.style.display = 'none';
                    }
                });
            })();
        </script>

    </body>
</html>
