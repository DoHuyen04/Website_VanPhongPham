package controller;

import dao.DBUtil;
import dao.DonHangDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
import java.time.format.DateTimeFormatter;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@MultipartConfig(maxFileSize = 1024 * 1024) // 1MB
@WebServlet("/nguoidung")
public class NguoiDungServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
    private final DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession ses = req.getSession(false);

        // nhận từ session: ưu tiên userId; fallback tenDangNhap
        Integer userId = (ses != null) ? (Integer) ses.getAttribute("userId") : null;
        String tenDangNhap = (ses != null) ? (String) ses.getAttribute("tenDangNhap") : null;

        String hanhDong = req.getParameter("hanhDong");
        if (!"hoso".equals(hanhDong)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // nếu chưa đăng nhập -> chuyển về login
        if (ses == null || (userId == null && (tenDangNhap == null || tenDangNhap.isBlank()))) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        // lấy hồ sơ
        NguoiDung nd = null;
        if (userId != null) {
            nd = nguoiDungDAO.layTheoIdDayDu(userId);
        } else if (tenDangNhap != null && !tenDangNhap.isBlank()) {
            nd = nguoiDungDAO.layTheoTenDangNhap(tenDangNhap);
        }

        if (nd == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        String ngaySinhText = (nd.getNgaySinh() != null)
                ? nd.getNgaySinh().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                : "";

        req.setAttribute("nguoiDung", nd);
        req.setAttribute("ngaySinhText", ngaySinhText);

        String tab = req.getParameter("tab");
        if ("password".equals(tab)) {
            req.setAttribute("active", "password");
            req.setAttribute("tab", "password");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }
        if ("tknh".equals(tab)) {
            java.util.List<model.TKNganHang> dsTKNH
                    = new dao.TKNganHangDAO().listByUserId(nd.getId());
            req.setAttribute("dsTKNH", dsTKNH);

            req.setAttribute("active", "tknh");
            req.setAttribute("tab", "tknh");

            // ====== THÊM KHỐI NÀY ======
        } else if ("orders".equals(tab)) {
            // sub-tab đơn hàng: all | dadat | dahuy | hoantien
            String otab = req.getParameter("otab");
            String filter = ("dadat".equals(otab) || "dahuy".equals(otab) || "hoantien".equals(otab)) ? otab : null;

            java.util.List<model.DonHang> dsDon
                    = (filter == null)
                            ? donHangDAO.layDonHangTheoNguoiDung(nd.getId())
                            : donHangDAO.layDonHangTheoNguoiDung(nd.getId(), filter);

            req.setAttribute("dsDonHang", dsDon);                 // danh sách đơn
            req.setAttribute("activeOrderTab", (otab == null ? "all" : otab)); // sub-tab đang chọn
            req.setAttribute("active", "orders");                 // để sidebar highlight
            req.setAttribute("tab", "orders");
            // ====== HẾT KHỐI THÊM ======

        } else if ("address".equals(tab)) {
            java.util.List<model.DiaChi> dsDiaChi
                    = new dao.DiaChiDAO().listByUser(nd.getId());
            req.setAttribute("dsDiaChi", dsDiaChi);
            req.setAttribute("active", "address");
            req.setAttribute("tab", "address");

        } else if ("password".equals(tab)) {
            req.setAttribute("active", "password");
            req.setAttribute("tab", "password");

        } else {
            req.setAttribute("active", "profile");
            req.setAttribute("tab", "profile");
        }

        req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String hanhDong = request.getParameter("hanhDong");
        if (hanhDong == null) {
            hanhDong = "";
        }

        switch (hanhDong) {
            case "capnhat_hoso":
                capNhatHoSo(request, response);
                break;

            case "dangky":
                dangKy(request, response);
                break;

            case "dangnhap":
                dangNhap(request, response);
                break;

            case "doimatkhau":
                doiMatKhau(request, response);
                break;

            case "upload_avatar":
                uploadAvatar(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/nguoidung?hanhDong=hoso");
                break;
        }
    }

    // Hàm mã hóa mật khẩu SHA-256
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

    // Xử lý đăng nhập tài khoản
    private void dangNhap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");

        // Mã hóa mật khẩu nhập vào để so sánh với DB
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
//                request.getSession().setAttribute("thongBaoDangNhap", "Đăng nhập thành công!");
//               response.sendRedirect("TrangChuServlet?afterLogin=true");
                session.setAttribute("id_nguoidung", rs.getInt("id_nguoidung"));
                session.setAttribute("userId", rs.getInt("id_nguoidung"));
                request.getSession().setAttribute("thongBaoDangNhap", "Đăng nhập thành công!");
                response.sendRedirect(request.getContextPath() + "/trang_chu.jsp");
                return;

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

    private void doiMatKhau(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ss = req.getSession(false);
        Integer userId = (ss != null) ? (Integer) ss.getAttribute("userId") : null;
        String tenDangNhap = (ss != null) ? (String) ss.getAttribute("tenDangNhap") : null;

        // Chưa đăng nhập → về trang đăng nhập
        if (ss == null || (userId == null && (tenDangNhap == null || tenDangNhap.isBlank()))) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        String pw = req.getParameter("pw");
        String pw2 = req.getParameter("pw2");

        pw = (pw != null) ? pw.trim() : "";
        pw2 = (pw2 != null) ? pw2.trim() : "";

        // 1) Kiểm tra trống
        if (pw.isEmpty() || pw2.isEmpty()) {
            req.setAttribute("err", "Vui lòng nhập đầy đủ thông tin.");
            req.setAttribute("active", "password");
            req.setAttribute("tab", "password");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        // 2) Khớp nhau
        if (!pw.equals(pw2)) {
            req.setAttribute("err", "Mật khẩu xác nhận không khớp.");
            req.setAttribute("active", "password");
            req.setAttribute("tab", "password");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        if (!pw.matches("^(?=.*[0-9])(?=.*[^A-Za-z0-9\\s]).{8,}$")) {
            req.setAttribute("err", "Mật khẩu chưa đạt yêu cầu (≥8 ký tự, có số & ký tự đặc biệt).");
            req.setAttribute("active", "password");
            req.setAttribute("tab", "password");
            req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
            return;
        }

        // 4) Hash & cập nhật DB
        String hashed = hashPassword(pw);

        boolean ok;
        NguoiDungDAO dao = new NguoiDungDAO();
        if (userId != null) {
            ok = dao.updatePassword(userId.intValue(), hashed);
        } else {
            ok = dao.updatePasswordByUsername(tenDangNhap, hashed);
        }

        if (ok) {
            req.setAttribute("ok", "Đổi mật khẩu thành công.");
        } else {
            req.setAttribute("err", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
        }

        req.setAttribute("active", "password");
        req.setAttribute("tab", "password");
        req.getRequestDispatcher("/tk_doi_mat_khau.jsp").forward(req, resp);
    }

    private void hienThiHoSo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("tenDangNhap") == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }
        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        NguoiDung nd = nguoiDungDAO.layTheoTenDangNhap(tenDangNhap);
        req.setAttribute("nguoiDung", nd);
        req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
    }

    private void capNhatHoSo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

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

        java.time.LocalDate ngaySinh = null;

        if (ngaySinhStr != null) {
            String[] patterns = {"dd/MM/yyyy", "d/M/yyyy", "yyyy-MM-dd"};
            for (String p : patterns) {
                try {
                    java.time.format.DateTimeFormatter f
                            = java.time.format.DateTimeFormatter.ofPattern(p);
                    ngaySinh = java.time.LocalDate.parse(ngaySinhStr, f);
                    break; // parse được thì thoát
                } catch (Exception ignore) {
                }
            }
        }

        if (ngaySinh == null) {
            NguoiDung cu = nguoiDungDAO.layTheoIdDayDu(userId);
            if (cu != null) {
                ngaySinh = cu.getNgaySinh();
            }
        }

        // Đóng gói model để update
        NguoiDung nd = new NguoiDung();
        nd.setId(userId);
        nd.setHoTen(hoTen);
        nd.setEmail(email);
        nd.setSoDienThoai(soDienThoai);
        nd.setGioiTinh(gioiTinh);
        nd.setNgaySinh(ngaySinh);

        boolean ok = nguoiDungDAO.capNhatThongTin(nd);

        if (ok) {
            NguoiDung ndMoi = nguoiDungDAO.layTheoIdDayDu(userId);
            ses.setAttribute("nguoiDung", ndMoi);

            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=profile");
        } else {
            req.setAttribute("error", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
        }
    }
// ✨ Hàm xử lý upload avatar

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
        if (ct == null || !(ct.equalsIgnoreCase("image/jpeg") || ct.equalsIgnoreCase("image/png"))) {
            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&err=type");
            return;
        }

        String ext = ct.equalsIgnoreCase("image/png") ? ".png" : ".jpg";
        String fileName = "u" + userId + "-" + System.currentTimeMillis() + ext;

        // Thư mục lưu trong webapp
        String uploadRoot = getServletContext().getRealPath("/uploads/avatars");
        java.io.File dir = new java.io.File(uploadRoot);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        java.io.File saved = new java.io.File(dir, fileName);
        part.write(saved.getAbsolutePath());

        String webPath = "/uploads/avatars/" + fileName;

        // Cập nhật DB
        new NguoiDungDAO().updateAvatar(userId, webPath);

        // Cập nhật session
        NguoiDung nd = (NguoiDung) ses.getAttribute("nguoiDung");
        if (nd == null) {
            nd = new NguoiDungDAO().layTheoIdDayDu(userId);
        }
        nd.setAvatarUrl(webPath);
        ses.setAttribute("nguoiDung", nd);

        // Tránh cache ảnh cũ
        resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&v=" + System.currentTimeMillis());
    }

    private String trimOrNull(String s) {
        if (s == null) {
            return null;
        }
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private static LocalDate parseNgaySinhFlexible(String s) {
        if (s == null) {
            return null;
        }
        s = s.trim();
        if (s.isEmpty()) {
            return null;
        }

        String[] patterns = {"dd/MM/yyyy", "d/M/yyyy", "yyyy-MM-dd"};
        for (String p : patterns) {
            try {
                DateTimeFormatter f = DateTimeFormatter.ofPattern(p);
                return LocalDate.parse(s, f);
            } catch (Exception ignore) {
            }
        }
        return null;
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng ký & đăng nhập người dùng có mã hóa mật khẩu";
    }
}
