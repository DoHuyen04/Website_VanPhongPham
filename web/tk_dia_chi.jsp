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
                        <input type="hidden" name="xaPhuong"  id="hidXa">
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

            // Tự render map mặc định khi trang sẵn sàng
            document.addEventListener('DOMContentLoaded', () => {
                if (document.getElementById('mapPreviewBox')) {
                    renderFixedMap(DEFAULT_MAP_URL);
                }
            });
        </script>
        <script>
            const modal = document.getElementById('modalAddr');
            document.getElementById('btnAdd').onclick = () => {
                modal.classList.remove('hidden');
                renderFixedMap(DEFAULT_MAP_URL);
            };
            document.getElementById('btnClose').onclick = () => modal.classList.add('hidden');
        </script>
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

                btnCan.addEventListener('click', function () {
                    pendingId = null;
                    modal.style.display = 'none';
                });

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

        <script>
            (function () {
                const CONTEXT = '/' + window.location.pathname.split('/')[1];
                const DATA_URL = CONTEXT + '/data/hanhchinhvn.json';
                console.log('Đang nạp:', DATA_URL);

                const selProv = document.getElementById('selTinh');
                const selDist = document.getElementById('selHuyen');
                const selWard = document.getElementById('selXa');

                if (!selProv || !selDist || !selWard)
                    return;

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
                        const opt = document.createElement('option');
                        opt.value = code;
                        opt.textContent = p.name;
                        selProv.appendChild(opt);
                    });
                    selProv.disabled = false;
                };

                const fillDistricts = (provCode) => {
                    reset(selDist, 'Quận/Huyện');
                    reset(selWard, 'Phường/Xã');
                    selDist.disabled = true;
                    selWard.disabled = true;

                    if (!provCode || !HC[provCode]) {
                        return;
                    }

                    const p = HC[provCode];
                    const districts = p['quan-huyen'] || p.districts || p.huyen || {};
                    const list = Array.isArray(districts)
                            ? districts
                            : Object.entries(districts).map(([code, d]) => ({code, name: d.name, wards: d.wards || d.xa}));

                    list.forEach(d => {
                        const code = d.code || d.ma || d.id;
                        const name = d.name;
                        if (code && name)
                            selDist.add(new Option(name, String(code)));
                    });

                    selDist.disabled = false;
                };

                const fillWards = (provCode, distCode) => {
                    reset(selWard, 'Phường/Xã');
                    selWard.disabled = true;
                    if (!provCode || !distCode)
                        return;

                    const p = HC[provCode];
                    if (!p)
                        return;

                    // 1) Lấy danh sách quận/huyện đúng khóa 'quan-huyen'
                    const dists = p['quan-huyen'] || p.districts || p.huyen || {};

                    let distObj = null;
                    if (Array.isArray(dists)) {
                        distObj = dists.find(d => String(d.code || d.ma || d.id) === String(distCode));
                    } else {
                        distObj = dists[distCode];
                    }
                    if (!distObj)
                        return;

                    // 2) Lấy phường/xã đúng khóa 'xa-phuong'
                    const wards = distObj['xa-phuong'] || distObj.wards || distObj.xa || {};
                    const list = Array.isArray(wards)
                            ? wards
                            : Object.entries(wards).map(([code, w]) => ({code, name: w.name}));

                    list.forEach(w => {
                        const code = w.code || w.ma || w.id;
                        const name = w.name;
                        if (code && name)
                            selWard.add(new Option(name, String(code)));
                    });

                    selWard.disabled = (selWard.options.length <= 1);
                };

                // events
                selProv.addEventListener('change', () => {
                    const pCode = selProv.value || '';
                    fillDistricts(pCode);
                    reset(selWard, 'Phường/Xã');
                    selWard.disabled = true;
                });

                selDist.addEventListener('change', () => {
                    const pCode = selProv.value || '';
                    const dCode = selDist.value || '';
                    fillWards(pCode, dCode);
                });

                // load json
                fetch(DATA_URL, {cache: 'no-store'})
                        .then(r => {
                            console.log('Fetch status:', r.status, r.headers.get('content-type'));
                            if (!r.ok)
                                throw new Error('Không tải được hanhchinhvn.json');
                            return r.json();
                        })
                        .then(json => {
                            HC = json;
                            fillProvinces();
                        })
                        .catch(err => {
                            console.error(err);
                            reset(selProv, 'Không tải được dữ liệu');
                            selProv.disabled = true;
                            selDist.disabled = true;
                            selWard.disabled = true;
                        });
            })();
            document.getElementById('formAddr').addEventListener('submit', function () {
                const getText = (sel) => sel.options[sel.selectedIndex]?.text?.trim() || '';
                document.getElementById('hidTinh').value = getText(document.getElementById('selTinh'));
                document.getElementById('hidHuyen').value = getText(document.getElementById('selHuyen'));
                document.getElementById('hidXa').value = getText(document.getElementById('selXa'));
            });
        </script>
    </body>
</html>
