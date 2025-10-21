<%-- 
    Document   : thong_tin_ca_nhan
    Created on : Oct 15, 2025, 3:12:49 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Kiểm tra đăng nhập
    HttpSession ses2 = request.getSession(false);
    if (ses2 == null || ses2.getAttribute("tenDangNhap") == null) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }

    String username = (String) ses2.getAttribute("tenDangNhap"); // 🔥 chuẩn hoá tên thuộc tính session
    String hoten = "", email = "", sdt = "";

    // Lấy thông tin từ DB
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/vanphongpham?useUnicode=true&characterEncoding=UTF-8",
                "root",
                "123@"
        );
        PreparedStatement ps = conn.prepareStatement(
                "SELECT hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=?"
        );
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            hoten = rs.getString("hoten");
            email = rs.getString("email");
            sdt = rs.getString("sodienthoai");
        }
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<%
    String tab = request.getParameter("tab");
    if (tab == null || tab.isBlank()) {
        tab = "profile"; // mặc định là Hồ sơ
    }%>
<style>
    .account-shell{
        display:grid;
        grid-template-columns:260px 1fr;
        gap:24px;
        max-width:1200px;
        margin:0 auto;
        padding:16px;
    }
    .account-sidebar{
        border-right:1px solid #eee;
        padding-right:16px;
    }
    .side-head{
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:12px;
    }
    .side-username{
        font-weight:700
    }
    .side-nav a{
        display:block;
        padding:10px 8px;
        border-radius:8px;
        color:#111;
        text-decoration:none;
        margin:2px 0;
    }
    .side-nav a.active{
        color:#ef4f23;
        font-weight:700;
        background:#fff4ef;
    }
    .account-content{
        padding-left:8px;
    }
</style>

<style>
    .profile-wrap{
        max-width:1100px;
        margin:0 auto;
        padding:24px 16px;
        font-family:system-ui,Segoe UI,Arial
    }
    .profile-title{
        font-size:28px;
        font-weight:800;
        margin:0 0 6px
    }
    .profile-sub{
        color:#6b7280;
        margin-bottom:22px
    }
    .profile-card{
        display:grid;
        grid-template-columns:1.3fr .7fr;
        gap:40px;
        align-items:start
    }
    .profile-left{
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:10px;
        padding:24px
    }
    .profile-right{
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:10px;
        padding:24px;
        text-align:center
    }

    .row{
        display:grid;
        grid-template-columns:220px 1fr;
        align-items:center;
        gap:18px;
        margin-bottom:18px
    }
    .row label{
        color:#374151
    }
    .row .static{
        font-weight:600
    }
    .inp, .sel{
        width:100%;
        padding:12px 14px;
        border:1px solid #d1d5db;
        border-radius:8px;
        font-size:15px;
        background:#f9fafb
    }
    .inp[disabled]{
        background:#f3f4f6;
        color:#6b7280
    }
    .action{
        color:#ef4f23;
        font-weight:600;
        text-decoration:none;
        margin-left:10px;
        cursor:pointer
    }
    .hint{
        color:#6b7280;
        font-size:12px
    }
    .save-btn{
        background:#ef4f23;
        border:none;
        color:#fff;
        font-weight:700;
        padding:12px 28px;
        border-radius:10px;
        cursor:pointer
    }
    .save-btn:disabled{
        opacity:.5;
        cursor:not-allowed
    }

    .avatar{
        width:120px;
        height:120px;
        border-radius:50%;
        object-fit:cover;
        display:block;
        margin:0 auto 14px;
        border:1px solid #e5e7eb
    }
    .btn-ghost{
        display:inline-block;
        border:1px solid #e5e7eb;
        border-radius:10px;
        padding:10px 18px;
        font-weight:700;
        background:#fff;
        cursor:pointer
    }
    .divider{
        height:1px;
        background:#e5e7eb;
        margin:18px 0
    }
</style>
<style>
    .row{
        display:grid;
        grid-template-columns: 220px minmax(360px,1fr) 110px; 
        align-items:center;
        gap:16px;
        margin-bottom:18px;
    }
    .row label{
        color:#666;
        font-weight:600;
    }

    .inp{
        width:100%;
        padding:10px 12px;
        border:1px solid #dcdfe6;
        border-radius:6px;
        background:#fff;
        font-size:15px;
    }
    .inp[disabled]{
        background:#f6f7f9;
        color:#6b7280;
    }

    .action{
        justify-self:start;      
        font-size:14px;
        color:#1677ff;
        text-decoration:none;
        cursor:pointer;
    }
    .action:hover{
        text-decoration:underline;
    }

    .hint{
        grid-column: 2 / 4;
        font-size:13px;
        color:#8b8f94;
        margin-top:-6px;
    }

    .row.editing .inp{
        background:#fff;
    }
    .row.editing .action{
        color:#ef4f23;
    } /* đổi màu khi ở trạng thái Huỷ */

    /* Nút Lưu */
    .save-btn{
        background:#ef4f23;
        color:#fff;
        border:0;
        border-radius:8px;
        font-weight:700;
        padding:12px 28px;
        cursor:pointer;
    }
    .save-btn:disabled{
        opacity:.5;
        cursor:not-allowed;
    }
</style>

<div class="account-shell">
    <!-- SIDEBAR -->
    <aside class="account-sidebar">
        <div class="side-head">
            <img src="hinh_anh/avatar-default.png" style="width:36px;height:36px;border-radius:50%;object-fit:cover">
            <div>
                <div class="side-username"><%= username%></div>
                <div style="color:#888;font-size:12px">✏️ Sửa Hồ Sơ</div>
            </div>
        </div>

        <nav class="side-nav">
            <a href="thong_tin_ca_nhan.jsp?tab=profile"  class="<%= "profile".equals(tab) ? "active" : ""%>">Hồ Sơ</a>
            <a href="thong_tin_ca_nhan.jsp?tab=bank"     class="<%= "bank".equals(tab) ? "active" : ""%>">Ngân Hàng</a>
            <a href="thong_tin_ca_nhan.jsp?tab=address"  class="<%= "address".equals(tab) ? "active" : ""%>">Địa Chỉ</a>
            <a href="thong_tin_ca_nhan.jsp?tab=password" class="<%= "password".equals(tab) ? "active" : ""%>">Đổi Mật Khẩu</a>
            <a href="thong_tin_ca_nhan.jsp?tab=privacy"  class="<%= "privacy".equals(tab) ? "active" : ""%>">Những Thiết Lập Riêng Tư</a>
            <a href="thong_tin_ca_nhan.jsp?tab=personal" class="<%= "personal".equals(tab) ? "active" : ""%>">Thông Tin Cá Nhân</a>
        </nav>
    </aside>

    <!-- CONTENT -->
    <section class="account-content">
        <%
            switch (tab) {
                case "profile":
        %>
        <div class="profile-wrap">
            <h1 class="profile-title">Hồ Sơ Của Tôi</h1>
            <div class="profile-sub">Quản lý thông tin hồ sơ để bảo mật tài khoản</div>

            <div class="profile-card">
                <!-- LEFT: FORM -->
                <div class="profile-left">
                    <form id="profileForm" action="CapNhatThongTinServlet" method="post">
                        <!-- Tên đăng nhập (static) -->
                        <div class="row">
                            <label>Tên đăng nhập</label>
                            <div class="static"><%= username%></div>
                        </div>

                        <div class="row">
                            <label>Tên</label>
                            <div>
                                <input class="inp" type="text" name="hoten" value="<%= hoten%>" required>
                            </div>
                        </div>

                        <div class="row" id="row-email">
                            <label>Email</label>
                            <div><input class="inp" type="email" id="emailInput" name="email" value="<%= email%>" disabled></div>
                            <a class="action" onclick="toggleEdit('emailInput', 'row-email', this)">Thay Đổi</a>
                        </div>


                        <div class="row" id="row-phone">
                            <label>Số điện thoại</label>
                            <div><input class="inp" type="text" id="phoneInput" name="sodienthoai" value="<%= sdt%>" disabled></div>
                            <a class="action" onclick="toggleEdit('phoneInput', 'row-phone', this)">Thay Đổi</a>
                        </div>

                        <div class="row">
                            <label>Giới tính <span class="hint"></span></label>
                            <div>
                                <label><input type="radio" name="gioitinh" value="Nam" disabled> Nam</label>
                                <label style="margin-left:14px"><input type="radio" name="gioitinh" value="Nữ" disabled> Nữ</label>
                                <label style="margin-left:14px"><input type="radio" name="gioitinh" value="Khác" disabled> Khác</label>
                            </div>
                        </div>

                        <div class="row" id="row-birth">
                            <label>Ngày sinh </label>
                            <div><input class="inp" type="date" id="birthInput" name="ngaysinh" disabled></div>
                            <a class="action" onclick="toggleEdit('birthInput', 'row-birth', this)">Thay Đổi</a>
                        </div>

                        <div class="row">
                            <label></label>
                            <div>
                                <button id="saveBtn" class="save-btn" type="submit" disabled>Lưu</button>
                            </div>
                        </div>

                        <!-- để servlet biết user nào (như bạn đã làm) -->
                        <input type="hidden" name="tenDangNhap" value="<%= username%>">
                    </form>
                </div>

                <div class="profile-right">
                    <img id="avatarPreview" class="avatar"
                         src="hinh_anh/avatar-default.png" alt="avatar">
                    <label class="btn-ghost" for="avatarFile">Chọn Ảnh</label>
                    <input id="avatarFile" type="file" accept=".jpg,.jpeg,.png" style="display:none">
                    <div class="divider"></div>
                    <div class="hint">Dung lượng file tối đa 1 MB<br>Định dạng: .JPEG, .PNG</div>
                </div>
            </div>
        </div>
    </section>

    <%
            break;
        case "bank":
    %>
    <jsp:include page="tk_ngan_hang.jsp"/>
    <%
            break;
        case "address":
    %>
    <jsp:include page="tk_dia_chi.jsp"/>
    <%
            break;
        case "password":
    %>
    <jsp:include page="tk_doi_mat_khau.jsp"/>
    <%
            break;
        case "privacy":
    %>
    <jsp:include page="tk_rieng_tu.jsp"/>
    <%
            break;
        case "personal":
    %>
    <jsp:include page="tk_thong_tin_ca_nhan.jsp"/>
    <%
                break;
        }
    %>
</section>
</div>
<script>
  // GÁN trực tiếp giá trị từ server vào input (không che)
  (function(){
    const emailInput = document.getElementById('emailInput');
    const phoneInput = document.getElementById('phoneInput');
    if (emailInput) emailInput.value = "<%= email == null ? "" : email %>";
    if (phoneInput) phoneInput.value = "<%= sdt   == null ? "" : sdt   %>";
  })();

  // Toggle enable/disable & đổi "Thay Đổi" <-> "Huỷ"
  function toggleEdit(inputId, rowId, anchor){
    const inp  = document.getElementById(inputId);
    const row  = document.getElementById(rowId);
    const save = document.getElementById('saveBtn');
    if(!inp || !row || !save) return;

    const enable = inp.hasAttribute('disabled');
    if (enable){
      inp.removeAttribute('disabled'); row.classList.add('editing');  anchor.textContent = "Huỷ";  inp.focus();
    } else {
      inp.setAttribute('disabled','disabled'); row.classList.remove('editing'); anchor.textContent = "Thay Đổi";
    }
    save.disabled = false;
  }

  // Avatar preview (chỉ chạy ở tab Hồ sơ)
  (function(){
    const file = document.getElementById('avatarFile');
    if(!file) return;
    file.addEventListener('change', e=>{
      const f = e.target.files[0]; if(!f) return;
      if(f.size > 1024*1024){ alert("File tối đa 1MB"); e.target.value=""; return; }
      document.getElementById('avatarPreview').src = URL.createObjectURL(f);
    });
  })();
</script>

