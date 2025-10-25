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
        --card:#ffffff;
        --bg:#f8fafc;
    }

    .bank-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:16px;
        margin:0 0 16px;
        padding-bottom:6px;
    }
    .bank-header h1{
        margin:0;
        font-size:28px;
        font-weight:800;
        color:var(--text);
    }

    .btn-add{
        background:var(--brand);
        color:#fff;
        border:0;
        padding:12px 18px;
        border-radius:10px;
        font-weight:800;
        cursor:pointer;
        box-shadow:0 6px 16px rgba(238,77,45,.25);
        transition:transform .15s ease, box-shadow .15s ease, opacity .15s ease;
    }
    .btn-add:hover{
        transform:translateY(-1px);
        box-shadow:0 8px 22px rgba(238,77,45,.35);
    }
    .btn-add:active{
        transform:translateY(0);
        opacity:.9;
    }

    .bank-item{
        display:flex;
        justify-content:space-between;
        align-items:center;
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
        align-items:center;
        min-width:0;
    }
    .bank-left .logo{
        width:44px;
        height:44px;
        object-fit:cover;
        border-radius:10px;
        background:#f1f5f9;
        border:1px solid var(--line);
    }
    .bank-left .bank-name{
        font-weight:800;
        color:var(--text);
        letter-spacing:.2px;
    }
    .bank-left .sub{
        margin-top:4px;
        color:var(--muted);
        font-size:14.5px;
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
        padding:6px 10px;
        font-size:13px;
        margin-left:8px;
        display:inline-flex;
        align-items:center;
    }
    .bank-badge.approved{
        background:rgba(52,211,153,.14);
        color:#16a34a;
    }
    .bank-badge.default{
        background:rgba(16,185,129,.14);
        color:var(--ok);
    }

    .bank-number{
        font-size:22px;
        font-weight:800;
        letter-spacing:.8px;
        color:var(--text);
    }
    .bank-actions{
        display:flex;
        align-items:center;
        gap:16px;
    }
    .bank-actions a,
    .bank-actions form button{
        margin-left:0;
        color:var(--blue);
        background:transparent;
        border:0;
        cursor:pointer;
        font-weight:700;
        text-decoration:none;
        border-bottom:2px solid transparent;
        padding:0;
    }
    .bank-actions a:hover,
    .bank-actions form button:hover{
        border-bottom-color:var(--blue);
    }

    .bank-actions .del{
        color:var(--text);
        text-decoration:none;
        border-bottom:2px solid transparent;
    }
    .bank-actions .del:hover{
        border-bottom-color:var(--text);
    }

    .bank-actions .btn-set-default[disabled],
    .bank-actions .btn-set-default.disabled{
        background:#f3f4f6;
        color:#9ca3af;
        border:0;
        padding:10px 14px;
        border-radius:12px;
        font-weight:800;
        cursor:not-allowed;
    }
    .bank-actions .btn-set-default:not([disabled]):not(.disabled){
        background:#e8f1ff;
        color:#0b3cff;
        border:0;
        padding:10px 14px;
        border-radius:12px;
        font-weight:800;
        cursor:pointer;
        box-shadow:0 2px 10px rgba(43,108,255,.15);
    }
    .bank-actions .btn-set-default:not([disabled]):not(.disabled):hover{
        filter:brightness(1.03);
    }

    .bank-cta{
        display:none;
        margin:12px 0 4px;
    }
    .inp{
        border:1px solid #d1d5db;
        border-radius:10px;
        padding:10px 12px;
        width:100%;
        background:#fff;
        transition:border-color .15s ease, box-shadow .15s ease;
    }
    .inp:focus{
        outline:none;
        border-color:#93c5fd;
        box-shadow:0 0 0 4px rgba(59,130,246,.15);
    }

    .grid2{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:12px;
    }
    @media (max-width:768px){
        .bank-item{
            flex-wrap:wrap;
        }
        .bank-number{
            font-size:20px;
        }
        .grid2{
            grid-template-columns:1fr;
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
  <form method="post" action="bank">
    <input type="hidden" name="act" value="add">
    <div class="grid2">
      <input class="inp" name="tennganhang" placeholder="Tên ngân hàng (VD: BIDV)" required>
      <input class="inp" name="chinhanh" placeholder="Chi nhánh (VD: CN Nghệ An)">
      <input class="inp" name="chutaikhoan" placeholder="Chủ tài khoản" required>
      <input class="inp" name="sotaikhoan" placeholder="Số tài khoản" required>
    </div>
    <label style="display:inline-flex;align-items:center;gap:6px;margin-top:10px">
      <input type="checkbox" name="macdinh" value="1"> Đặt làm mặc định
    </label>
    <div style="margin-top:10px">
      <button class="btn-add" type="submit">Lưu thẻ</button>
      <button type="button" onclick="document.getElementById('addBankBox').style.display='none'">Hủy</button>
    </div>
  </form>
</div>

<!-- Danh sách -->
<% for (TKNganHang b : banks) { %>
  <div class="bank-item">
    <div class="bank-left">
      <img src="hinh_anh/bank.png" style="width:44px;height:44px;border-radius:8px;border:1px solid #eee">
      <div>
        <div style="font-weight:700">
          <%= b.getTenNganHang() %>
          <% if ("approved".equals(b.getTrangThai())) { %>
            <span style="color:#10b981;margin-left:10px">Đã duyệt</span>
          <% } %>
          <% if (b.isMacDinh()) { %>
            <span class="bank-badge">MẶC ĐỊNH</span>
          <% } %>
    <form method="post" action="${pageContext.request.contextPath}/TKNganHangServlet">
        <input type="hidden" name="action" value="add">
        <div class="grid2">
            <input class="inp" name="tenNganHang" placeholder="Tên ngân hàng (VD: BIDV)" required>
            <input class="inp" name="chiNhanh" placeholder="Chi nhánh (VD: CN Nghệ An)">
            <input class="inp" name="chuTaiKhoan" placeholder="Chủ tài khoản" required>
            <input class="inp" name="soTaiKhoan" placeholder="Số tài khoản" required>
        </div>
        <label style="display:inline-flex;align-items:center;gap:6px;margin-top:10px">
            <input type="checkbox" name="macDinh"> Đặt làm mặc định
        </label>
        <div style="margin-top:10px">
            <button class="btn-add" type="submit">Lưu thẻ</button>
            <button type="button" onclick="document.getElementById('addBankBox').style.display = 'none'">Hủy</button>
        </div>
    </form>
</div>
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


