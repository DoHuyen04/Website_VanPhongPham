package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.NguoiDung;
import util.MailUtil;
import java.security.SecureRandom;


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
        String confirm = request.getParameter("xacNhanMatKhau");
        String hoten = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String sdt = request.getParameter("soDienThoai");

        // ⚠️ Kiểm tra nhập thiếu
        if (username.isEmpty() || password.isEmpty() || confirm.isEmpty()
                || hoten.isEmpty() || email.isEmpty() || sdt.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // ⚠️ Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // ⚠️ Kiểm tra trùng username/email/sdt
        NguoiDungDAO dao = new NguoiDungDAO();
        if (dao.isExist(username, email, sdt)) {
            request.setAttribute("error", "Tên đăng nhập, email hoặc SĐT đã tồn tại!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // ✅ Sinh mã xác nhận 6 chữ số (ngẫu nhiên, luôn 6 ký tự)
        String otp = String.format("%06d", (int)(Math.random() * 1000000));

        // ✅ Gửi email xác nhận OTP bằng MailUtil HTML đẹp
        boolean sent = MailUtil.sendOTP(email, hoten, otp);

        if (!sent) {
            request.setAttribute("error", "Không gửi được email xác nhận. Vui lòng kiểm tra lại địa chỉ Gmail hoặc cấu hình!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        // ✅ Lưu thông tin người dùng tạm + mã OTP vào session
        NguoiDung nd = new NguoiDung(username, password, hoten, email, sdt);
        HttpSession session = request.getSession();
        session.setAttribute("verifyCode", otp);
        session.setAttribute("otpTime", System.currentTimeMillis()); // thời gian gửi OTP
        session.setAttribute("pendingUser", nd);

        System.out.println(" [DangKyServlet] OTP đã gửi tới: " + email + " | Mã: " + otp);

        // ✅ Chuyển hướng sang trang nhập mã OTP
        request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
    }
}
