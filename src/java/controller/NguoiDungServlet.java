package controller;

import dao.DBUtil;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

@WebServlet("/nguoidung")
public class NguoiDungServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String hanhDong = req.getParameter("hanhDong");
        if ("dang_xuat".equals(hanhDong)) {
            req.getSession().invalidate();
            resp.sendRedirect("trang_chu.jsp");
            return;
        }
        req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String hanhDong = request.getParameter("hanhDong");

        if ("dangky".equals(hanhDong)) {
            dangKy(request, response);
        } else if ("dangnhap".equals(hanhDong)) {
            dangNhap(request, response);
        }
    }

    // ✅ Hàm mã hóa mật khẩu SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi mã hóa mật khẩu!", e);
        }
    }

    // ✅ Xử lý đăng ký tài khoản
    private void dangKy(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");

        // 👉 Mã hóa mật khẩu trước khi lưu
        String matKhauMaHoa = hashPassword(matKhau);

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO nguoidung (tenDangNhap, matKhau, hoTen, email, soDienThoai) VALUES (?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhauMaHoa);
            ps.setString(3, hoTen);
            ps.setString(4, email);
            ps.setString(5, soDienThoai);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("dang_nhap.jsp?dangky=thanhcong");
            } else {
                response.sendRedirect("dang_ky.jsp?error=thatbai");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dang_ky.jsp?error=loi");
        }
    }

    // ✅ Xử lý đăng nhập tài khoản
    private void dangNhap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");

        // 👉 Mã hóa mật khẩu nhập vào để so sánh với DB
        String matKhauMaHoa = hashPassword(matKhau);

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM nguoidung WHERE tenDangNhap = ? AND matKhau = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhauMaHoa);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("tenDangNhap", rs.getString("tenDangNhap"));
                session.setAttribute("hoTen", rs.getString("hoTen"));
                request.getSession().setAttribute("thongBaoDangNhap", "Đăng nhập thành công!");
                response.sendRedirect("trang_chu.jsp");
            } else {
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau!");
            request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng ký & đăng nhập người dùng có mã hóa mật khẩu";
    }
}
