package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.NguoiDung;

@WebServlet(name = "XacThucMaServlet", urlPatterns = {"/XacThucMaServlet"})
public class XacThucMaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng đăng ký lại!");
            request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
            return;
        }

        // Lấy dữ liệu từ session
        String codeNhap = request.getParameter("code");
        String codeGui = (String) session.getAttribute("verifyCode");
        Long otpTime = (Long) session.getAttribute("otpTime");
        NguoiDung pendingUser = (NguoiDung) session.getAttribute("pendingUser");

        // Debug log để xem giá trị thực tế
        System.out.println("========== [DEBUG OTP VERIFY] ==========");
        System.out.println("Client nhập: " + codeNhap);
        System.out.println("Server gửi: " + codeGui);
        System.out.println("OTP Time: " + otpTime);
        System.out.println("PendingUser: " + pendingUser);
        System.out.println("========================================");

        if (codeGui == null || otpTime == null || pendingUser == null) {
            request.setAttribute("error", "Mã xác nhận không hợp lệ hoặc đã hết hạn!");
            request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
            return;
        }

        // Kiểm tra hết hạn (5 phút)
        long now = System.currentTimeMillis();
        if (now - otpTime > 5 * 60 * 1000) {
            request.setAttribute("error", "⏰ Mã xác nhận đã hết hạn! Vui lòng gửi lại mã mới.");
            request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
            return;
        }

        // Kiểm tra trùng khớp mã
        if (codeNhap == null || !codeGui.equals(codeNhap.trim())) {
            request.setAttribute("error", "Mã xác nhận không đúng!");
            request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
            return;
        }

        // ✅ Nếu đến đây thì mã đúng — tiến hành lưu vào DB
        NguoiDungDAO dao = new NguoiDungDAO();
        boolean kq = dao.dangKy(pendingUser);

        System.out.println(">>> Kết quả lưu vào DB: " + kq);

        if (kq) {
            // Xoá session tạm sau khi đăng ký thành công
            session.removeAttribute("verifyCode");
            session.removeAttribute("otpTime");
            session.removeAttribute("pendingUser");

            response.sendRedirect("dang_nhap.jsp?msg=success");
        } else {
            request.setAttribute("error", "Đăng ký thất bại (có thể do lỗi SQL hoặc trùng dữ liệu)!");
            request.getRequestDispatcher("xac_thuc_ma.jsp").forward(request, response);
        }
    }
}
