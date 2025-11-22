<%-- 
    Document   : tk_ngan_hang
    Created on : 17 thg 10, 2025, 23:12:52
    Author     : daumai
--%>

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
    String flash = (String) session.getAttribute("msgBank");

    Integer userId = (ss != null) ? (Integer) ss.getAttribute("userId") : null;
    if (userId != null) {
        banks = new TKNganHangDAO().listByUserId(userId);
    }
    if (flash != null) {
        session.removeAttribute("msgBank");
    }
%>
<style>
    :root{
        --brand:#7295E3;
        --text:#111827;
        --muted:#6b7280;
        --line:#e5e7eb;
        --ok:#10b981;
        --blue:#2563eb;
        --danger:#ef4444;
        --card:#ffffff;
        --bg:#f6f6f6;
    }

    body{
        background:var(--bg);
        font-family:Arial,system-ui,sans-serif;
        margin:0;
    }

    .account-content{
        background:var(--card);
        border:1px solid #eee;
        border-radius:16px;
        box-shadow:0 1px 3px rgba(15,23,42,.06);
        padding:28px 34px 32px;
    }

    .bank-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:16px;
        margin:0 0 12px;
        padding-bottom:6px;
        border-bottom:1px solid #f1f5f9;
    }
    .bank-header h1,
    .bank-header h2,
    h2{
        margin:0;
        font-size:24px;
        font-weight:800;
        color:var(--text);
    }

    .btn-add{
        background:linear-gradient(180deg,#7aa3ff,#7295E3);
        color:#fff;
        border:0;
        padding:10px 18px;
        border-radius:10px;
        font-weight:700;
        cursor:pointer;
        box-shadow:0 6px 18px rgba(114,149,227,.28);
        transition:transform .1s ease, box-shadow .15s ease, opacity .15s ease;
        font-size:14px;
    }
    .btn-add:hover{
        transform:translateY(-1px);
        box-shadow:0 10px 24px rgba(114,149,227,.35);
    }
    .btn-add:active{
        transform:translateY(0);
        opacity:.92;
    }

    .bank-cta{
        display:none;
        margin:12px 0 4px;
        padding:14px 16px 16px;
        border-radius:12px;
        background:#f9fafb;
        border:1px dashed #cbd5f5;
    }

    .bank-item{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:18px;
        padding:18px 20px;
        margin:12px 0 0;
        background:var(--card);
        border:1px solid var(--line);
        border-radius:14px;
        box-shadow:0 1px 0 var(--line), 0 8px 24px rgba(2,6,23,.04);
    }

    .bank-left{
        display:flex;
        gap:14px;
        align-items:flex-start;
        min-width:0;
        width:100%;
    }

    .bank-left .bank-name{
        font-weight:800;
        color:var(--text);
        letter-spacing:.2px;
    }
    .bank-left .sub{
        margin-top:4px;
        color:var(--muted);
        font-size:14px;
        line-height:1.45;
    }
    .bank-left .sub b{
        color:var(--text);
    }

    .bank-badge{
        background:rgba(16,185,129,.12);
        color:var(--ok);
        font-weight:800;
        border-radius:999px;
        padding:5px 10px;
        font-size:12px;
        margin-left:8px;
        display:inline-flex;
        align-items:center;
    }
    .bank-badge.approved{
        background:rgba(52,211,153,.14);
        color:#16a34a;
    }

    .bank-number{
        font-size:22px;
        font-weight:800;
        letter-spacing:.8px;
        color:var(--text);
    }

    .bank-actions{
        display:flex;
        flex-wrap:wrap;
        align-items:center;
        gap:12px;
        margin-top:10px;
    }

    .action-btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        height:40px;
        padding:0 16px;
        border-radius:10px;
        font-weight:700;
        cursor:pointer;
        border:0;
        font-size:13px;
    }

    .btn-set-default[disabled]{
        background:#f3f4f6;
        color:#9ca3af;
        cursor:not-allowed;
        box-shadow:none;
    }
    .btn-set-default:not([disabled]){
        background:#e8f1ff;
        color:#0b3cff;
        box-shadow:0 2px 10px rgba(43,108,255,.15);
    }
    .btn-set-default:not([disabled]):hover{
        filter:brightness(1.03);
    }

    .btn-danger{
        background:var(--danger);
        color:#fff;
        box-shadow:0 2px 10px rgba(239,68,68,.18);
    }
    .btn-danger:hover{
        filter:brightness(1.03);
    }

    .inp{
        border:1px solid #d1d5db;
        border-radius:10px;
        padding:10px 12px;
        width:100%;
        background:#fff;
        font-size:14px;
        transition:border-color .15s ease, box-shadow .15s ease;
        box-sizing:border-box;
    }
    .inp:focus{
        outline:none;
        border-color:#93c5fd;
        box-shadow:0 0 0 3px rgba(59,130,246,.18);
    }

    .grid2{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:12px;
    }

    .field-group{
        display:flex;
        flex-direction:column;
        gap:4px;
    }
    .err-msg{
        color:#dc2626;
        font-size:12px;
        min-height:16px;
    }

    /* Modal xoá thẻ */
    #confirmModal{
        font-family:inherit;
    }

    @media (max-width:768px){
        .account-content{
            padding:22px 14px;
        }
        .bank-item{
            flex-direction:column;
            align-items:flex-start;
        }
        .grid2{
            grid-template-columns:1fr;
        }
        .bank-actions{
            gap:8px;
        }
    }
</style>

<h2>Tài Khoản Ngân Hàng Của Tôi</h2>
<div class="bank-header">
    <div></div>
    <button class="btn-add" type="button" onclick="document.getElementById('addBankBox').style.display = 'block'">
        ＋ Thêm Ngân Hàng Liên Kết
    </button>
</div>
<div id="addBankBox" class="bank-cta">
    <form method="post" action="${pageContext.request.contextPath}/TKNganHangServlet">
        <input type="hidden" name="action" value="add">

        <div class="grid2">
            <!-- TÊN NGÂN HÀNG -->
            <div class="field-group">
                <input class="inp"
                       id="tenNganHang"
                       name="tenNganHang"
                       placeholder="Tên ngân hàng (VD: BIDV)"
                       required
                       data-validate="text"
                       data-error-id="errTenNganHang">
                <div class="err-msg" id="errTenNganHang"></div>
            </div>

            <!-- CHI NHÁNH -->
            <div class="field-group">
                <input class="inp"
                       id="chiNhanh"
                       name="chiNhanh"
                       placeholder="Chi nhánh (VD: CN Nghệ An)"
                       required
                       data-validate="text"
                       data-error-id="errChiNhanh">
                <div class="err-msg" id="errChiNhanh"></div>
            </div>

            <!-- CHỦ TÀI KHOẢN -->
            <div class="field-group">
                <input class="inp"
                       name="chuTaiKhoan"
                       placeholder="Chủ tài khoản"
                       required>
                <div class="err-msg"></div>
            </div>

            <!-- SỐ TÀI KHOẢN -->
            <div class="field-group">
                <input class="inp"
                       id="soTaiKhoan"
                       name="soTaiKhoan"
                       placeholder="Số tài khoản"
                       required
                       data-validate="number"
                       data-error-id="errSoTaiKhoan"
                       inputmode="numeric">
                <div class="err-msg" id="errSoTaiKhoan"></div>
            </div>
        </div>

        <label style="display:inline-flex;align-items:center;gap:6px;margin-top:10px">
            <input type="checkbox" name="macDinh" value="1"> Đặt làm mặc định
        </label>

        <div style="margin-top:10px">
            <button class="btn-add" type="submit">Lưu thẻ</button>
            <button type="button"
                    onclick="document.getElementById('addBankBox').style.display = 'none'">
                Hủy
            </button>
        </div>
    </form>
</div>



<!-- Danh sách -->
<% for (TKNganHang b : banks) {%>
<div class="bank-item">
    <div class="bank-left">
        <div>
            <div style="font-weight:700">
                <%= b.getTenNganHang()%>
                <% if ("daduyet".equalsIgnoreCase(b.getTrangThai())) { %>
                <span class="bank-badge approved">ĐÃ DUYỆT</span>
                <% } %>
                <% if (b.isMacDinh()) { %>
                <span class="bank-badge">MẶC ĐỊNH</span>
                <% }%>
            </div>

            <!-- Hiển thị thông tin đã lưu -->
            <div class="grid2" style="margin-top:10px">
                <input class="inp" value="<%= b.getTenNganHang()%>"  placeholder="Tên ngân hàng"   readonly>
                <input class="inp" value="<%= b.getChiNhanh()%>"     placeholder="Chi nhánh"       readonly>
                <input class="inp" value="<%= b.getChuTaiKhoan()%>"  placeholder="Chủ tài khoản"   readonly>
                <input class="inp" value="<%= b.getSoTaiKhoan()%>"   placeholder="Số tài khoản"    readonly>
            </div>

            <div class="bank-actions" style="margin-top:10px">

                <!-- Đặt mặc định -->
                <form method="post" action="${pageContext.request.contextPath}/TKNganHangServlet">
                    <input type="hidden" name="action" value="setDefault">
                    <input type="hidden" name="id" value="<%= b.getIdTkNganHang()%>">

                    <button class="btn-set-default action-btn"
                            <%= b.isMacDinh() ? "disabled" : ""%>>
                        <%= b.isMacDinh() ? "Đang là mặc định" : "Đặt làm mặc định"%>
                    </button>
                </form>

                <!-- Xoá -->
                <button type="button"
                        class="btn-danger action-btn btn-delete-bank"
                        data-id="<%= b.getIdTkNganHang()%>">
                    Xoá
                </button>

            </div>

        </div>
    </div>
</div>
<% } %>

<% if (banks.isEmpty()) { %>
<div style="color:#6b7280">Bạn chưa liên kết tài khoản ngân hàng nào.</div>
<% }%>

<div id="confirmModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.35);align-items:center;justify-content:center;z-index:9999">
    <div style="background:#fff;border-radius:12px;max-width:420px;width:92%;padding:16px;box-shadow:0 10px 30px rgba(0,0,0,.2)">
        <h3 style="margin:0 0 8px;font-size:18px">Xác nhận xoá thẻ</h3>
        <p id="confirmText" style="margin:0 0 16px;color:#6b7280">
            Bạn có chắc chắn muốn xoá thẻ ngân hàng này không?
        </p>
        <div style="display:flex;gap:8px;justify-content:flex-end">
            <button type="button" id="btnCancel" style="padding:8px 12px;border:1px solid #e5e7eb;background:#fff;border-radius:8px;cursor:pointer">Huỷ</button>
            <button type="button" id="btnConfirm" style="padding:8px 12px;border:0;background:#ef4444;color:#fff;border-radius:8px;cursor:pointer">Xác nhận</button>
        </div>
    </div>
</div>

<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/TKNganHangServlet" style="display:none">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" id="deleteId">
</form>
<script>
    (function () {
        const modal = document.getElementById('confirmModal');
        const btnCancel = document.getElementById('btnCancel');
        const btnConfirm = document.getElementById('btnConfirm');
        const deleteForm = document.getElementById('deleteForm');
        const deleteIdInput = document.getElementById('deleteId');
        const confirmText = document.getElementById('confirmText');

        let pendingId = null;
        let pendingLabel = '';

        // Khi bấm nút Xoá
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.btn-delete-bank');
            if (!btn)
                return;

            e.preventDefault();
            pendingId = btn.dataset.id;

            // Hiện số tài khoản (4 số cuối) trong hộp thoại
            const row = btn.closest('.bank-item');
            const num = row ? row.querySelector('.bank-number') : null;
            pendingLabel = num ? num.textContent.trim() : '';

            if (confirmText && pendingLabel) {
                confirmText.textContent = 'Bạn có chắc chắn muốn xoá thẻ ' + pendingLabel + ' không?';
            }

            // Mở modal
            modal.style.display = 'flex';
        });

        // Nút Huỷ
        btnCancel.addEventListener('click', function () {
            pendingId = null;
            modal.style.display = 'none';
        });

        // Nút Xác nhận
        btnConfirm.addEventListener('click', function () {
            if (!pendingId)
                return;
            deleteIdInput.value = pendingId;
            modal.style.display = 'none';
            deleteForm.submit(); // gửi request xoá đến servlet
        });

        // Click ra nền ngoài để đóng modal
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
        const nameRegex = /^[A-Za-zÀ-ỹ\s]+$/;  // chữ + khoảng trắng (có tiếng Việt)
        const numberRegex = /^\d+$/;            // chỉ số

        function showError(input, message) {
            const errId = input.dataset.errorId;
            if (!errId)
                return;
            const el = document.getElementById(errId);
            if (el)
                el.textContent = message || "";
        }

        // validate 1 ô, đồng thời update lỗi text
        function validateInput(input) {
            const type = input.dataset.validate;
            const value = input.value.trim();
            let ok = true;

            if (!value) {
                // required mà trống -> coi là chưa hợp lệ để chặn ô dưới
                if (input.required)
                    ok = false;
                showError(input, "");
            } else if (type === "text") {
                if (!nameRegex.test(value)) {
                    showError(input, "Chỉ được nhập chữ và khoảng trắng, không được nhập số hoặc ký tự đặc biệt.");
                    ok = false;
                } else {
                    showError(input, "");
                }
            } else if (type === "number") {
                if (!numberRegex.test(value)) {
                    showError(input, "Chỉ được nhập số.");
                    ok = false;
                } else {
                    showError(input, "");
                }
            } else {
                showError(input, "");
            }

            updateLocking();
            return ok;
        }

        // thứ tự các ô từ trên xuống
        const orderedIds = ["tenNganHang", "chiNhanh", "chuTaiKhoan", "soTaiKhoan"];
        const orderedInputs = orderedIds.map(id => document.getElementById(id));

        // Hàm khoá/mở các ô bên dưới
        function updateLocking() {
            let previousValid = true;

            orderedInputs.forEach((input, idx) => {
                if (!input)
                    return;

                if (idx === 0) {
                    // ô đầu luôn đc nhập
                    input.disabled = false;
                } else {
                    input.disabled = !previousValid;
                    if (input.disabled) {
                        input.value = "";
                        showError(input, "");
                    }
                }

                // xác định xem ô hiện tại có "hợp lệ" để quyết định cho ô sau
                if (previousValid) {
                    const type = input.dataset.validate;
                    const value = input.value.trim();
                    let ok = true;

                    if (!value) {
                        if (input.required)
                            ok = false;
                    } else if (type === "text") {
                        ok = nameRegex.test(value);
                    } else if (type === "number") {
                        ok = numberRegex.test(value);
                    }

                    previousValid = ok;
                }
            });
        }

        // gắn event realtime
        document.querySelectorAll(".inp[data-validate]").forEach(function (inp) {
            inp.addEventListener("input", function () {
                validateInput(inp);
            });
            inp.addEventListener("blur", function () {
                validateInput(inp);
            });
        });

        // chặn submit nếu còn ô sai
        const form = document.querySelector("#addBankBox form");
        if (form) {
            form.addEventListener("submit", function (e) {
                let okAll = true;
                orderedInputs.forEach(function (inp) {
                    if (!inp)
                        return;
                    if (!validateInput(inp))
                        okAll = false;
                });
                if (!okAll)
                    e.preventDefault();
            });
        }
        updateLocking();
    })();
</script>
