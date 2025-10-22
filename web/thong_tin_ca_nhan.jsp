<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Hồ sơ người dùng, kiểu Shopee --%>
<c:set var="nguoiDung" value="${not empty requestScope.nguoiDung ? requestScope.nguoiDung : sessionScope.nguoiDung}" />
<c:if test="${empty nguoiDung}">
  <c:redirect url="${pageContext.request.contextPath}/nguoidung">
    <c:param name="hanhDong" value="hoso"/>
  </c:redirect>
</c:if>

<style>
body { background:#f6f6f6; font-family:Arial, sans-serif; }
.account-content {
  background:#fff; border:1px solid #eee; border-radius:10px;
  box-shadow:0 1px 3px rgba(0,0,0,.05);
  max-width:900px; margin:40px auto; padding:30px 40px;
}
.profile-title {
  font-size:24px; font-weight:800; margin:0 0 6px;
}
.profile-sub {
  color:#6b7280; margin-bottom:24px;
}
.row {
  display:grid; grid-template-columns:200px 1fr 100px;
  align-items:center; gap:16px; margin-bottom:18px;
}
.row label { font-weight:600; color:#444; }
.inp {
  width:100%; padding:10px 12px; border:1px solid #ddd;
  border-radius:6px; background:#fff; font-size:15px;
}
.inp[disabled] {
  background:#f9fafb; color:#333;
}
.action {
  color:#1677ff; text-decoration:none; cursor:pointer;
  font-weight:600;
}
.action:hover { text-decoration:underline; }
.save-btn {
  background:#1677ff; color:#fff; border:0;
  border-radius:8px; font-weight:700;
  padding:12px 28px; cursor:pointer; transition:.2s;
}
.save-btn:disabled {
  opacity:.5; cursor:not-allowed;
}
.profile-right {
  display:flex; flex-direction:column; align-items:center; gap:10px;
}
.avatar-img {
  width:140px; height:140px; border-radius:50%;
  object-fit:cover; border:1px solid #e5e7eb; background-color:#f9fafb;
}
.btn-ghost {
  background:#fff; border:1px solid #d1d5db;
  border-radius:10px; padding:8px 16px; font-weight:700;
  cursor:pointer; transition:.2s;
}
.btn-ghost:hover { background:#f3f4f6; }
.hint {
  color:#6b7280; font-size:14px; text-align:center; line-height:1.5;
}
.hint strong { color:#111827; }
.profile-card {
  display:grid; grid-template-columns:1fr 260px;
  gap:40px; align-items:flex-start;
}
/* === SIDEBAR LAYOUT (add-on) === */
.account-shell{
  max-width:1200px;margin:20px auto;padding:0 16px;
  display:grid;grid-template-columns:260px 1fr;gap:24px;
}
.account-sidebar{
  background:#fff;border:1px solid #eee;border-radius:10px;padding:16px;
  position:sticky;top:16px;height:fit-content;
}
.side-head{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.side-avatar{width:36px;height:36px;border-radius:50%;object-fit:cover}
.side-username{font-weight:700}
.side-edit-hint{font-size:12px;color:#888}

.side-nav{display:flex;flex-direction:column;gap:8px}
.tab-btn{
  display:flex;align-items:center;gap:8px;
  padding:10px 12px;border-radius:8px;
  text-decoration:none;color:#333;background:#fff;
  border:1px solid #ececec;transition:.15s;
}
.tab-btn:hover{background:#e9f2ff;color:#1677ff;border-color:#d6e6ff}
.tab-btn.active{
  background:#e9f2ff;color:#1677ff;font-weight:700;
  border-color:#1677ff;box-shadow:0 0 0 1px #1677ff inset;
}

/* để card của bạn tự đóng vai trò cột phải */
.account-shell > .account-content{margin:0;max-width:unset}
@media (max-width:768px){.account-shell{grid-template-columns:1fr}}

</style>
<c:set var="active" value="${empty requestScope.active ? (empty param.tab ? 'profile' : param.tab) : requestScope.active}" />

<div class="account-shell">
  <!-- SIDEBAR -->
  <aside class="account-sidebar">
    <div class="side-head">
      <img src="hinh_anh/avatar-default.png" class="side-avatar" alt="">
      <div>
        <div class="side-username"><c:out value="${nguoiDung.tenDangNhap}" default="Khách"/></div>
        <div class="side-edit-hint">✏️ Sửa Hồ Sơ</div>
      </div>
    </div>

    <nav class="side-nav">
      <a class="tab-btn ${active=='profile' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/nguoidung?hanhDong=hoso&tab=profile">👤 Hồ sơ</a>

      <a class="tab-btn ${active=='bank' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/TKNganHangServlet?tab=bank">🏦 Ngân Hàng</a>

      <a class="tab-btn ${active=='address' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/DiaChiServlet?tab=address">📮 Địa chỉ</a>

      <a class="tab-btn ${active=='password' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/DoiMatKhauServlet?tab=password">🔒 Đổi mật khẩu</a>
    </nav>
  </aside>
  <!-- HẾT SIDEBAR — KHÔNG ĐỤNG GÌ TỚI block account-content bên dưới -->

<div class="account-content">
  <h2 class="profile-title">Hồ Sơ Của Tôi</h2>
  <div class="profile-sub">Quản lý thông tin hồ sơ để bảo mật tài khoản</div>

  <form action="${pageContext.request.contextPath}/NguoiDungServlet" method="post">
    <input type="hidden" name="hanhDong" value="capnhat_hoso"/>

    <div class="profile-card">
      <!-- Cột trái: thông tin -->
      <div class="profile-left">
        <div class="row" id="rowTenDangNhap">
          <label>Tên đăng nhập</label>
          <input id="inpTenDangNhap" name="tenDangNhap" class="inp"
                 value="${nguoiDung.tenDangNhap}" disabled/>
          <span></span>
        </div>

        <div class="row" id="rowHoTen">
          <label>Họ và Tên</label>
          <input id="inpHoTen" name="hoTen" class="inp"
                 value="${nguoiDung.hoTen}" disabled/>
          <a href="#" class="action"
             onclick="toggleEdit('inpHoTen','rowHoTen',this);return false;">Thay đổi</a>
        </div>

        <div class="row" id="rowEmail">
          <label>E-mail</label>
          <input id="inpEmail" name="email" class="inp"
                 value="${nguoiDung.email}" disabled/>
          <a href="#" class="action"
             onclick="toggleEdit('inpEmail','rowEmail',this);return false;">Thay đổi</a>
        </div>

        <div class="row" id="rowSDT">
          <label>Số điện thoại</label>
          <input id="inpSDT" name="soDienThoai" class="inp"
                 value="${nguoiDung.soDienThoai}" disabled/>
          <a href="#" class="action"
             onclick="toggleEdit('inpSDT','rowSDT',this);return false;">Thay đổi</a>
        </div>

        <div class="row" id="rowGioiTinh">
          <label>Giới tính</label>
          <input id="inpGioiTinh" name="gioiTinh" class="inp"
                 value="${nguoiDung.gioiTinh}" disabled/>
          <a href="#" class="action"
             onclick="toggleEdit('inpGioiTinh','rowGioiTinh',this);return false;">Thay đổi</a>
        </div>

        <div class="row" id="rowNgaySinh">
          <label>Ngày sinh</label>
          <input id="inpNgaySinh" name="ngaySinh" class="inp"
                 value="${ngaySinhText}" disabled/>
          <a href="#" class="action"
             onclick="toggleEdit('inpNgaySinh','rowNgaySinh',this);return false;">Thay đổi</a>
        </div>

        <div class="row">
          <label></label>
          <button id="saveBtn" class="save-btn" type="submit" disabled>Lưu</button>
        </div>
      </div>

      <!-- Cột phải: ảnh đại diện -->
      <div class="profile-right">
        <img src="hinh_anh/avatar-default.png" alt="avatar" class="avatar-img" id="avatarPreview"/>
        <input type="file" id="avatarFile" name="avatar" accept="image/png,image/jpeg" style="display:none"/>
        <button type="button" id="btnChooseAvatar" class="btn-ghost">Chọn Ảnh</button>
        <div class="hint">
          Dung lượng file tối đa <strong>1 MB</strong><br/>
          Định dạng: <strong>JPEG, PNG</strong>
        </div>
      </div>
    </div>
  </form>
</div>
<script>
// BẬT TẤT CẢ INPUT TRƯỚC KHI SUBMIT để gửi đủ dữ liệu
document.querySelector('form[action$="/NguoiDungServlet"]').addEventListener('submit', function(e){
  // Nếu nút Lưu đang disabled thì chặn
  const save = document.getElementById('saveBtn');
  if (save && save.disabled) { e.preventDefault(); return; }

  // Bật tất cả input .inp để chúng được submit
  document.querySelectorAll('.inp[disabled]').forEach(inp => inp.disabled = false);
});
</script>

<script>
function toggleEdit(inputId, rowId, anchor){
  const inp = document.getElementById(inputId);
  const row = document.getElementById(rowId);
  const save = document.getElementById('saveBtn');
  if(!inp || !row || !save) return;

  const isDisabled = inp.disabled;
  if(isDisabled){
    inp.disabled = false;
    row.classList.add('editing');
    anchor.textContent = "Huỷ";
  }else{
    inp.disabled = true;
    row.classList.remove('editing');
    anchor.textContent = "Thay đổi";
  }
  save.disabled = false;
}

// chọn ảnh preview
document.getElementById('btnChooseAvatar').addEventListener('click', () => {
  document.getElementById('avatarFile').click();
});
document.getElementById('avatarFile').addEventListener('change', e => {
  const f = e.target.files[0];
  if(!f) return;
  if(f.size > 1024*1024){ alert("File vượt quá 1MB!"); e.target.value=""; return; }
  if(!/^image\/(jpe?g|png)$/i.test(f.type)){ alert("Chỉ nhận JPEG hoặc PNG!"); e.target.value=""; return; }
  document.getElementById('avatarPreview').src = URL.createObjectURL(f);
});
</script>
