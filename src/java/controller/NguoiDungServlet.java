package controller;

import dao.DBUtil;
import dao.DonHangDAO;
import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.NguoiDung;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@MultipartConfig(maxFileSize = 1024 * 1024) // 1MB
@WebServlet("/nguoidung")
public class NguoiDungServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    private final DonHangDAO donHangDAO = new DonHangDAO();
    private static final String REGEX_GMAIL = "^[a-z0-9._%+-]+@gmail\\.com$";

    private boolean isGmail(String email) {
        return email != null && email.trim().toLowerCase().matches(REGEX_GMAIL);
    }

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

        String tab = Optional.ofNullable(req.getParameter("tab")).orElse("profile");

        String ngaySinhText = nd.getNgaySinh() != null
                ? nd.getNgaySinh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                : "";

        req.setAttribute("nguoiDung", nd);
        req.setAttribute("ngaySinhText", ngaySinhText);

        switch (tab) {
            case "tknh" -> req.setAttribute("active", "tknh");
            case "orders" -> req.setAttribute("active", "orders");
            case "address" -> req.setAttribute("active", "address");
            case "password" -> req.setAttribute("active", "password");
            default -> req.setAttribute("active", "profile");
        }

        req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String hanhDong = Optional.ofNullable(req.getParameter("hanhDong")).orElse("");
        switch (hanhDong) {
            case "capnhat_hoso" -> capNhatHoSo(req, resp);
            case "dangky" -> dangKy(req, resp);
            case "dangnhap" -> dangNhap(req, resp);
            case "doimatkhau" -> doiMatKhau(req, resp);
            case "upload_avatar" -> uploadAvatar(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso");
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi mã hóa mật khẩu!", e);
        }
    }

    private void dangKy(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String tenDangNhap = req.getParameter("tenDangNhap");
        String matKhau = req.getParameter("matKhau");
        String hoTen = req.getParameter("hoTen");
        String email = req.getParameter("email");
        String soDienThoai = req.getParameter("soDienThoai");
        String gioiTinh = req.getParameter("gioiTinh");
        String ngaySinhStr = req.getParameter("ngaySinh");
        String role = Optional.ofNullable(req.getParameter("role")).orElse("USER");

        LocalDate ngaySinh = parseNgaySinhFlexible(ngaySinhStr);
        String matKhauMaHoa = hashPassword(matKhau);

        if (nguoiDungDAO.kiemTraTonTai(tenDangNhap, email)) {
            req.setAttribute("thongBao", "Tên đăng nhập hoặc email đã tồn tại!");
            req.getRequestDispatcher("dang_ky.jsp").forward(req, resp);
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
        nd.setRole(role);

        boolean ok = nguoiDungDAO.dangKy(nd);
        if (ok) {
            resp.sendRedirect("dang_nhap.jsp?thongbao=dk_thanhcong");
        } else {
            req.setAttribute("thongBao", "Đăng ký thất bại!");
            req.getRequestDispatcher("dang_ky.jsp").forward(req, resp);
        }
    }

    private void dangNhap(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    String tenDangNhap = req.getParameter("tenDangNhap");
    String matKhau = hashPassword(req.getParameter("matKhau")); // Hàm hash mật khẩu
    String roleForm = req.getParameter("role"); // Role người dùng chọn trên form

    if (roleForm == null || roleForm.isEmpty()) {
        req.setAttribute("error", "Vui lòng chọn vai trò!");
        req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
        return;
    }

    try (Connection conn = DBUtil.getConnection()) {
        String sql = "SELECT * FROM nguoidung WHERE tenDangNhap=? AND matKhau=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, tenDangNhap);
        ps.setString(2, matKhau);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String roleDB = rs.getString("role");

            // Kiểm tra role chọn trên form có trùng role thực tế trong database không
            if (!roleDB.equalsIgnoreCase(roleForm)) {
                req.setAttribute("error", "Bạn đã chọn vai trò không đúng!");
                req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
                return;
            }

            // Nếu role đúng, tạo session
            HttpSession session = req.getSession(true);
            session.setMaxInactiveInterval(60 * 60); // 1 giờ

            NguoiDung nd = new NguoiDung();
            nd.setId(rs.getInt("id_nguoidung"));
            nd.setTenDangNhap(rs.getString("tenDangNhap"));
            nd.setHoTen(rs.getString("hoTen"));
            nd.setEmail(rs.getString("email"));
            nd.setSoDienThoai(rs.getString("soDienThoai"));
            nd.setGioiTinh(rs.getString("gioiTinh"));
            nd.setRole(roleDB);

            session.setAttribute("nguoiDung", nd);
            session.setAttribute("role", nd.getRole());
            session.setAttribute("userId", nd.getId());
            session.setAttribute("tenDangNhap", nd.getTenDangNhap());

            // Chuyển hướng theo role
            switch (roleDB.toUpperCase()) {
                
                case "SHIPPER" -> resp.sendRedirect(req.getContextPath() + "/shipper_dashboard.jsp");
                default -> resp.sendRedirect(req.getContextPath() + "/trang_chu.jsp");
            }
            return;
        } else {
            // Sai username hoặc password
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
        }

    } catch (Exception e) {
        e.printStackTrace();
        req.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại sau!");
        req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
    }
}

    private void doiMatKhau(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession ss = req.getSession(false);
        if (ss == null || ss.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        int userId = (Integer) ss.getAttribute("userId");

        String oldPw = Optional.ofNullable(req.getParameter("oldPw")).orElse("").trim();
        String pw = Optional.ofNullable(req.getParameter("pw")).orElse("").trim();
        String pw2 = Optional.ofNullable(req.getParameter("pw2")).orElse("").trim();

        if (oldPw.isEmpty() || pw.isEmpty() || pw2.isEmpty() || !pw.equals(pw2)) {
            req.setAttribute("err", "Thông tin mật khẩu không hợp lệ hoặc xác nhận không khớp.");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        NguoiDung nd = nguoiDungDAO.layTheoIdDayDu(userId);
        if (!hashPassword(oldPw).equals(nd.getMatKhau())) {
            req.setAttribute("err", "Mật khẩu cũ không chính xác.");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        boolean ok = nguoiDungDAO.updatePassword(userId, hashPassword(pw));
        if (ok) {
            ss.setAttribute("pw_ok", "Đổi mật khẩu thành công.");
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=password");
        } else {
            req.setAttribute("err", "Đổi mật khẩu thất bại.");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
        }
    }

    private void capNhatHoSo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ss = req.getSession(false);
        if (ss == null || ss.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        int userId = (Integer) ss.getAttribute("userId");

        String hoTen = trimOrNull(req.getParameter("hoTen"));
        String email = trimOrNull(req.getParameter("email"));
        String soDienThoai = trimOrNull(req.getParameter("soDienThoai"));
        String gioiTinh = trimOrNull(req.getParameter("gioiTinh"));
        LocalDate ngaySinh = parseNgaySinhFlexible(req.getParameter("ngaySinh"));

        if (!isGmail(email)) {
            req.setAttribute("loiEmail", "Email phải kết thúc bằng @gmail.com");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp?tab=profile").forward(req, resp);
            return;
        }

        if (soDienThoai == null || !soDienThoai.matches("^[0-9]{9,11}$")) {
            req.setAttribute("loiSoDienThoai", "Số điện thoại 9–11 chữ số.");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp?tab=profile").forward(req, resp);
            return;
        }

        NguoiDung nd = new NguoiDung();
        nd.setId(userId);
        nd.setHoTen(hoTen);
        nd.setEmail(email);
        nd.setSoDienThoai(soDienThoai);
        nd.setGioiTinh(gioiTinh);
        nd.setNgaySinh(ngaySinh);

        boolean ok = nguoiDungDAO.capNhatThongTin(nd);
        if (ok) {
            ss.setAttribute("nguoiDung", nguoiDungDAO.layTheoIdDayDu(userId));
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=profile");
        } else {
            req.setAttribute("error", "Cập nhật hồ sơ thất bại.");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
        }
    }

    private void uploadAvatar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ss = req.getSession(false);
        if (ss == null || ss.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        int userId = (Integer) ss.getAttribute("userId");
        Part part = req.getPart("avatar");

        if (part == null || part.getSize() == 0) {
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&err=no_file");
            return;
        }

        String ct = part.getContentType();
        if (ct == null || !(ct.equalsIgnoreCase("image/jpeg") || ct.equalsIgnoreCase("image/png"))) {
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

        NguoiDung nd = nguoiDungDAO.layTheoIdDayDu(userId);
        ss.setAttribute("nguoiDung", nd);
        resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&v=" + System.currentTimeMillis());
    }

    private String trimOrNull(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    private static LocalDate parseNgaySinhFlexible(String s) {
        if (s == null || s.isBlank()) return null;
        String[] patterns = {"dd/MM/yyyy", "d/M/yyyy", "yyyy-MM-dd"};
        for (String p : patterns) {
            try {
                return LocalDate.parse(s, DateTimeFormatter.ofPattern(p));
            } catch (Exception ignored) {
            }
        }
        return null;
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng ký, đăng nhập, phân quyền USER, ADMIN, SHIPPER, cập nhật hồ sơ, đổi mật khẩu, upload avatar";
    }
}
