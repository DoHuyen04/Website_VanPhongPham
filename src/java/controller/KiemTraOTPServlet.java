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
import java.util.Date;

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
        
        HttpSession session = request.getSession();
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

        // ✅ Nếu OTP đúng
        String tenNguoiNhan = (String) session.getAttribute("tenNguoiNhan");
        String diaChi = (String) session.getAttribute("diaChi");
        String sdt = (String) session.getAttribute("sdt");
        String phuongThuc = (String) session.getAttribute("phuongThuc");
        String taiKhoan = (String) session.getAttribute("taiKhoan");
        Double tongTien = (Double) session.getAttribute("tongTien");

        // ✅ Lưu thông tin đơn hàng vào session (giả lập database)
        session.setAttribute("donHangGanNhat", new Date() + " - " + tenNguoiNhan + " - " + tongTien + " VND");

        // ✅ Lưu vào danh sách lịch sử đơn hàng
        java.util.List<String> lichSu = (java.util.List<String>) session.getAttribute("lichSuDonHang");
        if (lichSu == null) lichSu = new java.util.ArrayList<>();
        lichSu.add(new Date() + " | Người nhận: " + tenNguoiNhan + " | Tổng: " + tongTien + " VND | " + phuongThuc);
        session.setAttribute("lichSuDonHang", lichSu);

        // ✅ Chuyển sang trang thanh toán thành công
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
