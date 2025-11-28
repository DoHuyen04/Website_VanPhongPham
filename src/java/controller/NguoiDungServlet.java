package controller;

import dao.DBUtil;
import dao.DonHangDAO;
import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.*;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import dao.NguoiDungDAO;
import model.NguoiDung;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@MultipartConfig(maxFileSize = 1024 * 1024) // 1MB
@WebServlet("/nguoidung")
public class NguoiDungServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    private final DonHangDAO donHangDAO = new DonHangDAO();

    private static final String REGEX_GMAIL = "^[a-z0-9._%+-]+@gmail\\.com$";

    private boolean isGmail(String email) {
        if (email == null) return false;
        return email.trim().toLowerCase().matches(REGEX_GMAIL);
    }

    // =============== HIỂN THỊ TRANG THÔNG TIN USER =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        NguoiDung ndSession = (NguoiDung) session.getAttribute("nguoiDung");
        NguoiDung nd = nguoiDungDAO.layTheoIdDayDu(ndSession.getId());
        if (nd == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        // CHUYỂN LocalDate → String (ĐÃ CHUYỂN MODEL SANG STRING)
        String ngaySinhText = (nd.getNgaySinh() != null) ? nd.getNgaySinh() : "";
        req.setAttribute("nguoiDung", nd);
        req.setAttribute("ngaySinhText", ngaySinhText);

        String tab = Optional.ofNullable(req.getParameter("tab")).orElse("profile");

        switch (tab) {
            case "tknh" -> {
                var dsTKNH = new dao.TKNganHangDAO().listByUserId(nd.getId());
                req.setAttribute("dsTKNH", dsTKNH);
                req.setAttribute("active", "tknh");
            }
            case "orders" -> {
                var dsDon = donHangDAO.layDonHangTheoNguoiDung(nd.getId());
                req.setAttribute("dsDonHang", dsDon);
                req.setAttribute("active", "orders");
            }
            case "address" -> {
                var dsDiaChi = new dao.DiaChiDAO().listByUser(nd.getId());
                req.setAttribute("dsDiaChi", dsDiaChi);
                req.setAttribute("active", "address");
            }
            case "password" -> req.setAttribute("active", "password");
            default -> req.setAttribute("active", "profile");
        }

        req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
    }

    // ================== XỬ LÝ POST ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String hanhDong = Optional.ofNullable(request.getParameter("hanhDong")).orElse("");

        switch (hanhDong) {
            case "capnhat_hoso" -> capNhatHoSo(request, response);
            case "dangky" -> dangKy(request, response);
            case "dangnhap" -> dangNhap(request, response);
            case "doimatkhau" -> doiMatKhau(request, response);
            case "upload_avatar" -> uploadAvatar(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/nguoidung?hanhDong=hoso");
        }
    }

    // ========== Mã hoá mật khẩu ==========
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashed = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashed) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi mã hóa!", e);
        }
    }

    // ========== ĐĂNG KÝ ==========
    private void dangKy(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");
        String gioiTinh = request.getParameter("gioiTinh");
        String ngaySinhStr = request.getParameter("ngaySinh");

        // NGÀY SINH DÙNG STRING
        String ngaySinh = (ngaySinhStr != null && !ngaySinhStr.isEmpty()) ? ngaySinhStr : null;

        String matKhauMaHoa = hashPassword(matKhau);

        if (nguoiDungDAO.kiemTraTonTai(tenDangNhap, email)) {
            request.setAttribute("thongBao", "Tên đăng nhập hoặc email đã tồn tại!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        NguoiDung nd = new NguoiDung();
        nd.setTenDangNhap(tenDangNhap);
        nd.setMatKhau(matKhauMaHoa);
        nd.setHoTen(hoTen);
        nd.setEmail(email);
        nd.setSoDienThoai(soDienThoai);
        nd.setGioiTinh(gioiTinh);
        nd.setNgaySinh(ngaySinh);

        boolean thanhCong = nguoiDungDAO.dangKy(nd);

        if (thanhCong)
            response.sendRedirect("dang_nhap.jsp?thongbao=dk_thanhcong");
        else {
            request.setAttribute("thongBao", "Đăng ký thất bại!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
        }
    }

    // ========== ĐĂNG NHẬP ==========
    private void dangNhap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        String matKhauMaHoa = hashPassword(matKhau);

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM nguoidung WHERE tenDangNhap = ? AND matKhau = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhauMaHoa);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession(true);
                session.setMaxInactiveInterval(3600);

                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id_nguoidung"));
                nd.setTenDangNhap(rs.getString("tenDangNhap"));
                nd.setHoTen(rs.getString("hoTen"));
                nd.setEmail(rs.getString("email"));
                nd.setSoDienThoai(rs.getString("soDienThoai"));
                nd.setGioiTinh(rs.getString("gioiTinh"));
                nd.setNgaySinh(rs.getString("ngaySinh")); // CHUYỂN SANG STRING

                session.setAttribute("nguoiDung", nd);
                session.setAttribute("userId", nd.getId());
                session.setAttribute("tenDangNhap", nd.getTenDangNhap());

                response.sendRedirect(request.getContextPath() + "/trang_chu.jsp");
                return;

            } else {
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
                request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống!");
            request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
        }
    }

    // ========== ĐỔI MẬT KHẨU ==========
    private void doiMatKhau(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ss = req.getSession(false);
        Integer userId = (ss != null) ? (Integer) ss.getAttribute("userId") : null;

        if (ss == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        String pw = req.getParameter("pw");
        String pw2 = req.getParameter("pw2");

        if (pw == null || pw2 == null || pw.isBlank() || pw2.isBlank()) {
            req.setAttribute("err", "Vui lòng nhập đầy đủ thông tin.");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        if (!pw.equals(pw2)) {
            req.setAttribute("err", "Mật khẩu xác nhận không khớp.");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        String hashed = hashPassword(pw);

        boolean ok = nguoiDungDAO.updatePassword(userId, hashed);

        if (ok) {
            req.getSession().setAttribute("pw_ok", "Đổi mật khẩu thành công.");
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=password");
        } else {
            req.setAttribute("err", "Đổi mật khẩu thất bại.");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
        }
    }

    // ========== CẬP NHẬT HỒ SƠ ==========
    private void capNhatHoSo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ses = req.getSession(false);

        if (ses == null || ses.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        int userId = (Integer) ses.getAttribute("userId");

        String hoTen = trimOrNull(req.getParameter("hoTen"));
        String email = trimOrNull(req.getParameter("email"));
        String soDienThoai = trimOrNull(req.getParameter("soDienThoai"));
        String gioiTinh = trimOrNull(req.getParameter("gioiTinh"));
        String ngaySinhStr = trimOrNull(req.getParameter("ngaySinh"));

        // NGÀY SINH DÙNG STRING
        String ngaySinh = null;

        if (ngaySinhStr != null && !ngaySinhStr.isBlank()) {
            ngaySinh = ngaySinhStr;
        } else {
            NguoiDung cu = nguoiDungDAO.layTheoIdDayDu(userId);
            if (cu != null) ngaySinh = cu.getNgaySinh();
        }

        if (email == null || !isGmail(email)) {
            req.setAttribute("loiEmail", "E-mail phải kết thúc bằng @gmail.com");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp?tab=profile").forward(req, resp);
            return;
        }

        if (soDienThoai == null || !soDienThoai.matches("^[0-9]{9,11}$")) {
            req.setAttribute("loiSoDienThoai", "Số điện thoại không hợp lệ.");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp?tab=profile").forward(req, resp);
            return;
        }

        if (gioiTinh == null) gioiTinh = "";

        NguoiDung nd = new NguoiDung();
        nd.setId(userId);
        nd.setHoTen(hoTen);
        nd.setEmail(email.trim().toLowerCase());
        nd.setSoDienThoai(soDienThoai);
        nd.setGioiTinh(gioiTinh);
        nd.setNgaySinh(ngaySinh);

        boolean ok = nguoiDungDAO.capNhatThongTin(nd);

        if (ok) {
            NguoiDung updated = nguoiDungDAO.layTheoIdDayDu(userId);
            ses.setAttribute("nguoiDung", updated);
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=profile");
        } else {
            req.setAttribute("error", "Cập nhật hồ sơ thất bại!");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
        }
    }

    private void uploadAvatar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ses = req.getSession(false);
        if (ses == null || ses.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        int userId = (Integer) ses.getAttribute("userId");

        Part part = req.getPart("avatar");
        if (part == null || part.getSize() == 0) {
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&err=no_file");
            return;
        }

        String ct = part.getContentType();
        if (!(ct.equalsIgnoreCase("image/png") || ct.equalsIgnoreCase("image/jpeg"))) {
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&err=type");
            return;
        }

        String ext = ct.equalsIgnoreCase("image/png") ? ".png" : ".jpg";
        String fileName = "u" + userId + "-" + System.currentTimeMillis() + ext;

        String uploadRoot = getServletContext().getRealPath("/uploads/avatars");
        java.io.File dir = new java.io.File(uploadRoot);
        if (!dir.exists()) dir.mkdirs();

        java.io.File saved = new java.io.File(dir, fileName);
        part.write(saved.getAbsolutePath());

        String webPath = "/uploads/avatars/" + fileName;
        nguoiDungDAO.updateAvatar(userId, webPath);

        NguoiDung nd = (NguoiDung) ses.getAttribute("nguoiDung");
        if (nd != null) nd.setAvatarUrl(webPath);

        resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&v=" + System.currentTimeMillis());
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    @Override
    public String getServletInfo() {
        return "Servlet Người Dùng (ngày sinh kiểu String)";
    }
}
