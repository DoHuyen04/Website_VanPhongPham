package controller;

import dao.DBUtil;
import java.io.IOException;
import java.io.PrintWriter;
import dao.SanPhamDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import model.SanPham;

import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import dao.NguoiDungDAO;
import jakarta.servlet.http.HttpSession;
import model.NguoiDung;
import java.time.LocalDate;

@WebServlet("/nguoidung")
public class NguoiDungServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("hoso".equals(req.getParameter("hanhDong"))) {
            hienThiHoSo(req, resp);
            return;
        }
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
        if ("capnhat_hoso".equals(request.getParameter("hanhDong"))) {
            capNhatHoSo(request, response);
            return;
        }

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
    request.setCharacterEncoding("UTF-8");

    String tenDangNhap = request.getParameter("tenDangNhap");
    String matKhau = request.getParameter("matKhau");
    String hoTen = request.getParameter("hoTen");
    String email = request.getParameter("email");
    String soDienThoai = request.getParameter("soDienThoai");
    String gioiTinh = request.getParameter("gioiTinh");
    String ngaySinhStr = request.getParameter("ngaySinh");

    LocalDate ngaySinh = null;
    if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
        ngaySinh = LocalDate.parse(ngaySinhStr);
    }

    // 👉 Mã hóa mật khẩu trước khi lưu
    String matKhauMaHoa = hashPassword(matKhau);

    // ✅ Kiểm tra tên đăng nhập hoặc email đã tồn tại
    if (nguoiDungDAO.kiemTraTonTai(tenDangNhap, email)) {
        request.setAttribute("thongBao", "Tên đăng nhập hoặc email đã tồn tại!");
        request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
        return;
    }

    // ✅ Tạo đối tượng người dùng
    NguoiDung nd = new NguoiDung();
    nd.setTenDangNhap(tenDangNhap);
    nd.setMatKhau(matKhauMaHoa);
    nd.setHoTen(hoTen);
    nd.setEmail(email);
    nd.setSoDienThoai(soDienThoai);
    nd.setGioiTinh(gioiTinh);
    nd.setNgaySinh(ngaySinh);

    // ✅ Gọi DAO để lưu vào DB
    boolean thanhCong = nguoiDungDAO.dangKy(nd);

    if (thanhCong) {
        response.sendRedirect("dang_nhap.jsp?thongbao=dk_thanhcong");
    } else {
        request.setAttribute("thongBao", "Đăng ký thất bại, vui lòng thử lại!");
        request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
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
               response.sendRedirect("TrangChuServlet?afterLogin=true");
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

    private void hienThiHoSo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("tenDangNhap") == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }
        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        NguoiDung nd = nguoiDungDAO.layDayDuTheoTenDangNhap(tenDangNhap);
        req.setAttribute("nguoidung", nd);
        req.getRequestDispatcher("hoso.jsp").forward(req, resp);
    }

    private void capNhatHoSo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("tenDangNhap") == null) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        String hoTen = request.getParameter("hoten");
        String soDienThoai = request.getParameter("sodienthoai");
        String gioiTinh = request.getParameter("gioitinh");
        String ngaySinhStr = request.getParameter("ngaysinh");

        NguoiDung nd = nguoiDungDAO.layDayDuTheoTenDangNhap(tenDangNhap);
        if (nd == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        nd.setHoTen(hoTen);
        nd.setSoDienThoai(soDienThoai);
        nd.setGioiTinh((gioiTinh != null && !gioiTinh.isBlank()) ? gioiTinh : null);
        if (ngaySinhStr != null && !ngaySinhStr.isBlank()) {
            nd.setNgaySinh(LocalDate.parse(ngaySinhStr));
        } else {
            nd.setNgaySinh(null);
        }

        boolean ok = nguoiDungDAO.capNhatHoSo(nd);
        request.setAttribute("thongbao", ok ? "Cập nhật hồ sơ thành công!" : "Cập nhật không thành công!");
        request.setAttribute("nguoidung", nd);
        request.getRequestDispatcher("hoso.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng ký & đăng nhập người dùng có mã hóa mật khẩu";
    }
}
