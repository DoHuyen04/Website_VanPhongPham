<%-- 
    Document   : thong_tin_ca_nhan
    Created on : Oct 15, 2025, 3:12:49 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.*" %>
<%
    HttpSession ses2 = request.getSession(false);
    String username = (String) ses2.getAttribute("tendangnhap");

    String hoten = "", email = "", sdt = "";

    if (username != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ten_csdl", "root", "matkhau");
            PreparedStatement ps = conn.prepareStatement("SELECT hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                hoten = rs.getString("hoten");
                email = rs.getString("email");
                sdt = rs.getString("sodienthoai");
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<h2>Thông tin cá nhân</h2>
<form action="CapNhatThongTinServlet" method="post">
  <label>Họ tên:</label>
  <input type="text" name="hoten" value="<%= hoten %>" required><br>

  <label>Email:</label>
  <input type="email" name="email" value="<%= email %>" required><br>

  <label>Số điện thoại:</label>
  <input type="text" name="sodienthoai" value="<%= sdt %>"><br>

  <button type="submit">Cập nhật</button>
</form>
