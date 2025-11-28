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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author asus
 */
@WebServlet(name = "KiemTraOTPServlet", urlPatterns = {"/KiemTraOTPServlet"})
public class KiemTraOTPServlet extends HttpServlet {

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
            out.println("<title>Servlet KiemTraOTPServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet KiemTraOTPServlet at " + request.getContextPath() + "</h1>");
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
        
       HttpSession session = request.getSession(false);
        String otpNhap = request.getParameter("otp");
        String otpDung = (String) session.getAttribute("otp");
        Long otpExpire = (Long) session.getAttribute("otp_expire");

        if (otpDung == null || otpExpire == null) {
            request.setAttribute("error", "Vui lòng yêu cầu mã OTP mới.");
            request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            return;
        }
        long now = System.currentTimeMillis();
        if (now > otpExpire) {
            request.setAttribute("error", "Mã OTP đã hết hạn, vui lòng yêu cầu mã mới.");
            request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            return;
        }

        if (!otpNhap.equals(otpDung)) {
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại.");
            request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            return;
        }

      
        // ✅ OTP chính xác → tạo đơn hàng
        String tenNguoiNhan = (String) session.getAttribute("tenNguoiNhan");
        String diaChi = (String) session.getAttribute("diaChi");
        String sdt = (String) session.getAttribute("soDienThoai");
        String phuongThuc = (String) session.getAttribute("phuongThuc");
        String taiKhoan = (String) session.getAttribute("taiKhoan");
         String email = (String) session.getAttribute("email");
        Double tongTien = (Double) session.getAttribute("tongTien");

        if (tongTien == null) tongTien = 0.0;

        // ✅ Ghi nhận thời gian tạo đơn
        Date ngayTao = new Date();
        session.setAttribute("donHangGanNhat", ngayTao + " - " + tenNguoiNhan + " - " + tongTien + " VND");

        List<String> lichSu = (List<String>) session.getAttribute("lichSuDonHang");
        if (lichSu == null) lichSu = new ArrayList<>();

        lichSu.add(ngayTao + " | Người nhận: " + tenNguoiNhan
                + " | Tổng: " + tongTien + " VND"
                + " | Phương thức: " + (phuongThuc != null ? phuongThuc : "Không xác định"));

        session.setAttribute("lichSuDonHang", lichSu);

        // ✅ Xóa OTP sau khi dùng
        session.removeAttribute("otp");
        session.removeAttribute("otp_expire");
if (email != null && !email.isEmpty()) {
        try {
            String subject = "Xác nhận đơn hàng từ Cửa hàng Văn Phòng Phẩm";
            String messageText = "<h2>Xin chào " + tenNguoiNhan + ",</h2>"
                    + "<p>Cảm ơn bạn đã đặt hàng tại <b>Cửa hàng Văn Phòng Phẩm</b>.</p>"
                    + "<p><b>Thông tin đơn hàng:</b></p>"
                    + "<ul>"
                    + "<li>Người nhận: " + tenNguoiNhan + "</li>"
                    + "<li>Địa chỉ: " + diaChi + "</li>"
                    + "<li>Số điện thoại: " + sdt + "</li>"
                    + "<li>Phương thức thanh toán: " + phuongThuc + "</li>"
                    + "<li>Tổng tiền: " + tongTien + " VND</li>"
                    + "<li>Thời gian đặt: " + ngayTao + "</li>"
                    + "</ul>"
                    + "<p>Đơn hàng của bạn đang được xử lý. Cảm ơn bạn đã tin tưởng mua sắm cùng chúng tôi!</p>"
                    + "<br><p>Trân trọng,<br><b>Đội ngũ Văn Phòng Phẩm</b></p>";

            utils.EmailUtility.sendEmail(email, subject, messageText);
            System.out.println("📧 Đã gửi email xác nhận đơn hàng tới: " + email);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Gửi email thất bại: " + e.getMessage());
        }
    }
        // ✅ Chuyển đến trang thanh toán thành công
        request.setAttribute("thongBao", "Thanh toán thành công!");
        request.getRequestDispatcher("thanh_toan_thanh_cong.jsp").forward(request, response);
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