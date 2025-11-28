package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.NguoiDung;
import utils.MailUtil;
import java.security.SecureRandom;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "DangKyServlet", urlPatterns = {"/DangKyServlet"})
public class DangKyServlet extends HttpServlet {

    private static final SecureRandom random = new SecureRandom();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("tenDangNhap");
        String password = request.getParameter("matKhau");
        String confirm  = request.getParameter("xacNhanMatKhau");
        String hoten    = request.getParameter("hoTen");
        String email    = request.getParameter("email");
        String sdt      = request.getParameter("soDienThoai");
        String gioiTinh = request.getParameter("gioiTinh");
        String ngaySinh = request.getParameter("ngaySinh");

        // --- Validate rỗng ---
        if (isEmpty(username, password, confirm, hoten, email, sdt)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // --- Validate mật khẩu ---
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // --- Kiểm tra tồn tại ---
        NguoiDungDAO dao = new NguoiDungDAO();
        if (dao.isExist(username, email, sdt)) {
            request.setAttribute("error", "Tên đăng nhập, email hoặc SĐT đã tồn tại!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // --- HASH mật khẩu ---
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // --- Tạo OTP ---
        String otp = String.format("%06d", random.nextInt(1000000));

        // --- Gửi OTP ---
        boolean sent = MailUtil.sendOTP(email, hoten, otp);
        if (!sent) {
            request.setAttribute("error", "Không gửi được email xác nhận!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // --- Lưu tạm user vào session ---
        NguoiDung nd = new NguoiDung();
        nd.setTenDangNhap(username);
        nd.setMatKhau(hashedPassword);
        nd.setHoTen(hoten);
        nd.setEmail(email);
        nd.setSoDienThoai(sdt);
        nd.setGioiTinh(gioiTinh);
        nd.setNgaySinh(ngaySinh);  // String

        HttpSession session = request.getSession();
        session.setAttribute("pendingUser", nd);
        session.setAttribute("verifyCode", otp);
        session.setAttribute("otpTime", System.currentTimeMillis());

        // --- Sang trang nhập OTP ---
        request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
    }

    private boolean isEmpty(String... arr) {
        for (String s : arr) {
            if (s == null || s.trim().isEmpty()) return true;
        }
        return false;
    }
}
