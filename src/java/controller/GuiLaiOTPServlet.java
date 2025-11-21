/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;
import utils.EmailUtility;

/**
 *
 * @author asus
 */
@WebServlet(name = "GuiLaiOTPServlet", urlPatterns = {"/GuiLaiOTPServlet"})
public class GuiLaiOTPServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GuiLaiOTPServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GuiLaiOTPServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    HttpSession session = request.getSession();

    // ✅ LẤY USER TỪ PHIÊN (tài khoản đã đăng ký/đăng nhập)
    // Lưu ý: cần import model.NguoiDung;
    model.NguoiDung nd = (model.NguoiDung) session.getAttribute("nguoiDung");
    if (nd == null || nd.getEmail() == null || nd.getEmail().isBlank()) {
        // Chưa đăng nhập hoặc tài khoản không có email -> yêu cầu đăng nhập lại
        request.setAttribute("thongBao", "Vui lòng đăng nhập lại để nhận OTP qua email đã đăng ký.");
        request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
        return;
    }

    // ✅ Email người nhận = email đã ĐĂNG KÝ của user
    String email = nd.getEmail().trim();

    // Tên hiển thị (không bắt buộc), lấy từ họ tên user nếu có
    String tenNguoiNhan = (nd.getHoTen() != null && !nd.getHoTen().isBlank())
            ? nd.getHoTen().trim()
            : "bạn";

    // 🔐 Tạo OTP mới + hạn sử dụng
    String newOtp = String.format("%06d", new java.util.Random().nextInt(1_000_000));
    long newExpire = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút

    session.setAttribute("otp", newOtp);
    session.setAttribute("otp_expire", newExpire);

    // Nội dung email
    String subject = "Mã OTP mới để xác nhận thanh toán";
    String message =
        "<html>" +
        "<body style='font-family:Arial,sans-serif; line-height:1.6; background-color:#f7f8fa; padding:20px;'>" +
            "<div style='max-width:600px; margin:auto; background-color:#ffffff; border-radius:10px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.1);'>" +
                "<h2 style='color:#4A90E2; text-align:center;'>Xác nhận thanh toán đơn hàng</h2>" +
                "<p>Xin chào <b>" + tenNguoiNhan + "</b>,</p>" +
                "<p>Cảm ơn bạn đã mua sắm tại <b>WEB Văn Phòng Phẩm</b>!<br>" +
                "Dưới đây là mã xác nhận (OTP) để hoàn tất thanh toán đơn hàng của bạn:</p>" +
                "<div style='text-align:center; margin:25px 0;'>" +
                    "<span style='font-size:26px; font-weight:bold; color:#ffffff; background:linear-gradient(135deg, #74ABE2, #5563DE); padding:12px 30px; border-radius:8px; letter-spacing:3px;'>" + newOtp + "</span>" +
                "</div>" +
                "<p>Mã OTP có hiệu lực trong <b>5 phút</b>. Vui lòng không chia sẻ mã này với bất kỳ ai.</p>" +
                "<p style='margin-top:25px;'>Trân trọng,<br><b>Đội ngũ hỗ trợ - WEB Văn Phòng Phẩm</b></p>" +
                "<hr style='margin-top:30px; border:none; border-top:1px solid #ddd;'>" +
                "<p style='font-size:12px; color:#777; text-align:center;'>Đây là email tự động, vui lòng không phản hồi lại email này.</p>" +
            "</div>" +
        "</body>" +
        "</html>";

    try {
        // Log để chắc đang gửi đúng email tài khoản
        System.out.println("[OTP] userId=" + nd.getId() + ", sendTo=" + email);

        utils.EmailUtility.sendEmail(email, subject, message);

        request.setAttribute("thongBao", "Đã gửi lại mã OTP mới. Vui lòng kiểm tra email đã đăng ký của bạn.");
        request.getRequestDispatcher("xac_nhan_otp.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("Lỗi gửi email OTP mới: " + e.getMessage());
    }
}

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
