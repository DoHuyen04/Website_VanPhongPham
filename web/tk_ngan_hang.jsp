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
  if (flash != null) session.removeAttribute("msgBank");
%>

<style>
  .bank-header{display:flex;justify-content:space-between;align-items:center;margin:0 0 14px}
  .btn-add{background:#ef4f23;color:#fff;border:0;padding:10px 16px;border-radius:8px;font-weight:700;cursor:pointer}
  .bank-item{display:flex;justify-content:space-between;align-items:center;padding:14px 0;border-top:1px solid #eee}
  .bank-left{display:flex;gap:14px;align-items:center}
  .bank-badge{background:#34d399;color:#fff;font-weight:800;border-radius:6px;padding:2px 8px;font-size:12px;margin-left:8px}
  .bank-actions a, .bank-actions form button{margin-left:12px;color:#2563eb;background:transparent;border:0;cursor:pointer}
  .bank-actions .del{color:#111827;text-decoration:underline}
  .bank-cta{display:none;margin:12px 0 4px}
  .inp{border:1px solid #d1d5db;border-radius:8px;padding:10px 12px;width:100%;background:#fff}
  .grid2{display:grid;grid-template-columns:1fr 1fr;gap:10px}
</style>

<h2>Tài Khoản Ngân Hàng Của Tôi</h2>

<% if (flash != null) { %>
  <div style="background:#e6ffed;border:1px solid #b7eb8f;padding:8px 10px;border-radius:8px;margin:10px 0;"><%= flash %></div>
<% } %>

<div class="bank-header">
  <div></div>
  <button class="btn-add" type="button" onclick="document.getElementById('addBankBox').style.display='block'">＋ Thêm Ngân Hàng Liên Kết</button>
</div>

<!-- Form thêm -->
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
        </div>
        <div>Họ và tên: <b><%= b.getChuTaiKhoan() %></b></div>
        <div>Chi nhánh: <%= b.getChiNhanh()==null?"":b.getChiNhanh() %></div>
      </div>
    </div>
    <div class="bank-actions">
      <div style="font-weight:700">* <%= b.getSoTaiKhoan().length()>=4 ? b.getSoTaiKhoan().substring(b.getSoTaiKhoan().length()-4) : b.getSoTaiKhoan() %></div>

      <% if (!b.isMacDinh()) { %>
        <form method="post" action="bank" style="display:inline">
          <input type="hidden" name="act" value="set_default">
          <input type="hidden" name="id" value="<%= b.getIdNguoiDung()%>">
          <button type="submit" style="opacity:.65;border:1px solid #ddd;border-radius:8px;padding:6px 10px;">Thiết Lập Mặc Định</button>
        </form>
      <% } else { %>
        <button disabled style="opacity:.35;border:1px solid #eee;border-radius:8px;padding:6px 10px;">Thiết Lập Mặc Định</button>
      <% } %>

      <form method="post" action="bank" style="display:inline" onsubmit="return confirm('Xóa thẻ ngân hàng này?');">
        <input type="hidden" name="act" value="delete">
        <input type="hidden" name="id" value="<%= b.getIdTkNganHang()%>">
        <button type="submit" class="del">Xóa</button>
      </form>
    </div>
  </div>
<% } %>

<% if (banks.isEmpty()) { %>
  <div style="color:#6b7280">Bạn chưa liên kết tài khoản ngân hàng nào.</div>
<% } %>

