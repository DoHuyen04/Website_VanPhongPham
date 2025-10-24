package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.NguoiDung;
import util.MailUtil;

@WebServlet(name = "GuiLaiMaServlet", urlPatterns = {"/GuiLaiMaServlet"})
public class GuiLaiMaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            request.setAttribute("error", "Phiên đã hết hạn, vui lòng đăng ký lại!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        NguoiDung pendingUser = (NguoiDung) session.getAttribute("pendingUser");
        if (pendingUser == null) {
            request.setAttribute("error", "Không tìm thấy thông tin người dùng trong session!");
            request.getRequestDispatcher("dang_ky.jsp").forward(request, response);
            return;
        }

        String email = pendingUser.getEmail();
        String hoten = pendingUser.getHoTen();

        // 🔁 Tạo OTP mới
        String newOTP = String.format("%06d", (int)(Math.random() * 1000000));

        // ✅ Gửi mail mới
        boolean sent = MailUtil.sendOTP(email, hoten, newOTP);
        if (!sent) {
            request.setAttribute("error", "Không thể gửi lại mã OTP. Vui lòng thử lại sau!");
            request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
            return;
        }

        // ✅ Lưu lại vào session
        session.setAttribute("verifyCode", newOTP);
        session.setAttribute("otpTime", System.currentTimeMillis());

        System.out.println(" Mã OTP mới gửi lại: " + newOTP + " -> " + email);

        // ✅ Thông báo người dùng
        request.setAttribute("success", "Mã xác thực mới đã được gửi tới email của bạn!");
        request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
    }
}
                             