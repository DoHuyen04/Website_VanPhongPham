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
import java.util.List;
import java.util.Map;
import model.SanPham;

/**
 *
 * @author asus
 */
@WebServlet(name = "ThanhToanServlet", urlPatterns = {"/ThanhToanServlet"})
public class ThanhToanServlet extends HttpServlet {

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
            out.println("<title>Servlet ThanhToanServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ThanhToanServlet at " + request.getContextPath() + "</h1>");
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

    List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
    if (gioHang == null || gioHang.isEmpty()) {
        response.sendRedirect("gio_hang.jsp");
        return;
    }

    String tongTienStr = request.getParameter("tongTien");
    double tongTien = 0;
    if (tongTienStr != null && !tongTienStr.isEmpty()) {
        tongTien = Double.parseDouble(tongTienStr);
    }

    // ✅ Lưu tổng tiền vào session
    session.setAttribute("tongTien", tongTien);

    String[] chonSp = request.getParameterValues("chonSp");
    List<SanPham> dsChon = new ArrayList<>();
    if (chonSp != null) {
        for (String idStr : chonSp) {
            int id = Integer.parseInt(idStr);
            for (Map<String, Object> item : gioHang) {
                SanPham sp = (SanPham) item.get("sanpham");
                if (sp.getId_sanpham() == id) {
                    dsChon.add(sp);
                }
            }
        }
    }

    request.setAttribute("dsChon", dsChon);
    request.setAttribute("tongTienHang", tongTien);

    RequestDispatcher rd = request.getRequestDispatcher("thanh_toan.jsp");
    rd.forward(request, response);
}

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
