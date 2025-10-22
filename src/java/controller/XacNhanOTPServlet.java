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
import javax.mail.MessagingException;
import utils.EmailUtility;

/**
 *
 * @author asus
 */
@WebServlet(name = "XacNhanOTPServlet", urlPatterns = {"/XacNhanOTPServlet"})
public class XacNhanOTPServlet extends HttpServlet {

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
            out.println("<title>Servlet XacNhanOTPServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet XacNhanOTPServlet at " + request.getContextPath() + "</h1>");
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
       
        HttpSession session = request.getSession();

        // Lấy thông tin người dùng từ form thanh toán
        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        String diaChi = request.getParameter("diaChi");
        String sdt = request.getParameter("sdt");
        String email = (String) session.getAttribute("email"); // email đã đăng ký
        if (email == null) {
            email = "dohuyen34204@gmail.com"; // test mặc định nếu chưa đăng nhập
        }

        // 🔹 Lấy tổng tiền từ session
        double tongTien = 0;
        if (session.getAttribute("tongTien") != null) {
            tongTien = (double) session.getAttribute("tongTien");
        }

        // 🔹 Tạo mã OTP ngẫu nhiên
        String otp = String.format("%06d", new Random().nextInt(999999));
        long thoiGianHetHan = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút

        // 🔹 Lưu vào session để kiểm tra sau
        session.setAttribute("otp", otp);
        session.setAttribute("otp_expire", thoiGianHetHan);
        session.setAttribute("tenNguoiNhan", tenNguoiNhan);
        session.setAttribute("diaChi", diaChi);
        session.setAttribute("sdt", sdt);
       

        // Gửi mail OTP
        String subject = "Mã xác nhận thanh toán đơn hàng của bạn";
        String message = 
    "<html>" +
    "<body style='font-family:Arial,sans-serif; line-height:1.6; background-color:#f7f8fa; padding:20px;'>" +
        "<div style='max-width:600px; margin:auto; background-color:#ffffff; border-radius:10px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.1);'>" +
            "<h2 style='color:#4A90E2; text-align:center;'>Xác nhận thanh toán đơn hàng</h2>" +
            "<p>Xin chào <b>" + tenNguoiNhan + "</b>,</p>" +
            "<p>Cảm ơn bạn đã mua sắm tại <b>WEB Văn Phòng Phẩm</b>! <br>" +
            "Dưới đây là mã xác nhận (OTP) để hoàn tất thanh toán đơn hàng của bạn:</p>" +
            "<div style='text-align:center; margin:25px 0;'>" +
                "<span style='font-size:26px; font-weight:bold; color:#ffffff; background:linear-gradient(135deg, #74ABE2, #5563DE); padding:12px 30px; border-radius:8px; letter-spacing:3px;'>" + otp + "</span>" +
            "</div>" +
            "<p>Mã OTP có hiệu lực trong <b>5 phút</b>. Vui lòng không chia sẻ mã này với bất kỳ ai để đảm bảo an toàn tài khoản của bạn.</p>" +
            "<p style='margin-top:25px;'>Trân trọng,<br>" +
            "<b>Đội ngũ hỗ trợ - WEB Văn Phòng Phẩm</b></p>" +
            "<hr style='margin-top:30px; border:none; border-top:1px solid #ddd;'>" +
            "<p style='font-size:12px; color:#777; text-align:center;'>Đây là email tự động, vui lòng không phản hồi lại email này.</p>" +
        "</div>" +
    "</body>" +
    "</html>";
        try {
            EmailUtility.sendEmail(email, subject, message);
            request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
        } catch (MessagingException e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi gửi email: " + e.getMessage());
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
