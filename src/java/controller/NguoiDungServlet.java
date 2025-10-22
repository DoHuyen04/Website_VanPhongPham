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
import java.time.format.DateTimeFormatter;

@WebServlet("/nguoidung")
public class NguoiDungServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        // (tuỳ chọn) đảm bảo response UTF-8
        resp.setCharacterEncoding("UTF-8");

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
            // Không tìm thấy trong DB → bắt đăng nhập lại
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        // format ngày sinh để JSP hiển thị
        String ngaySinhText = (nd.getNgaySinh() != null)
                ? nd.getNgaySinh().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                : "";

        // --- set attribute cho JSP ---
        req.setAttribute("nguoiDung", nd);
        req.setAttribute("ngaySinhText", ngaySinhText);

        // Sidebar kiểu Shopee đang dùng 'active'
        req.setAttribute("active", "profile");

        // (tuỳ chọn) vẫn set 'tab' để tương thích chéo nếu nơi khác còn đọc 'tab'
        req.setAttribute("tab", "profile");

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

            default:
                // Không rõ action → đưa về hồ sơ (hoặc trang đăng nhập tùy ý bạn)
                response.sendRedirect(request.getContextPath() + "/nguoidung?hanhDong=hoso");
                break;
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
                session.setAttribute("id_nguoidung", rs.getInt("id_nguoidung"));
                session.setAttribute("userId", rs.getInt("id_nguoidung"));  // <--- thêm dòng này
                response.sendRedirect(request.getContextPath() + "/trang_chu.jsp");

//                response.sendRedirect("trang_chu.jsp");
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

        // Lấy input (chỉ các trường được phép cập nhật)
        String hoTen = trimOrNull(req.getParameter("hoTen"));
        String email = trimOrNull(req.getParameter("email"));
        String soDienThoai = trimOrNull(req.getParameter("soDienThoai"));
        String gioiTinh = trimOrNull(req.getParameter("gioiTinh"));
        String ngaySinhStr = trimOrNull(req.getParameter("ngaySinh")); // dd/MM/yyyy

        java.time.LocalDate ngaySinh = null;

    // thử parse với nhiều định dạng
    if (ngaySinhStr != null) {
        String[] patterns = { "dd/MM/yyyy", "d/M/yyyy", "yyyy-MM-dd" };
        for (String p : patterns) {
            try {
                java.time.format.DateTimeFormatter f =
                        java.time.format.DateTimeFormatter.ofPattern(p);
                ngaySinh = java.time.LocalDate.parse(ngaySinhStr, f);
                break; // parse được thì thoát
            } catch (Exception ignore) { /* thử pattern tiếp theo */ }
        }
    }

    // nếu vẫn không parse được (hoặc để trống) -> GIỮ NGÀY CŨ, không ghi NULL
    if (ngaySinh == null) {
        NguoiDung cu = nguoiDungDAO.layTheoIdDayDu(userId);
        if (cu != null) ngaySinh = cu.getNgaySinh();
    }

        // Đóng gói model để update
        NguoiDung nd = new NguoiDung();
        nd.setId(userId);                 // mapping tới id_nguoidung (DB)
        nd.setHoTen(hoTen);
        nd.setEmail(email);
        nd.setSoDienThoai(soDienThoai);
        nd.setGioiTinh(gioiTinh);
        nd.setNgaySinh(ngaySinh);

        boolean ok = nguoiDungDAO.capNhatThongTin(nd);

        if (ok) {
            // Làm mới dữ liệu phiên (nếu bạn có dùng trong JSP)
            NguoiDung ndMoi = nguoiDungDAO.layTheoIdDayDu(userId);
            ses.setAttribute("nguoiDung", ndMoi);

            resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=profile");
        } else {
            req.setAttribute("error", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
        }
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
        return null; // không parse được
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng ký & đăng nhập người dùng có mã hóa mật khẩu";
    }
}
