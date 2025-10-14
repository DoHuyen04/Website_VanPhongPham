/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.NguoiDungDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.NguoiDung;

/**
 *
 * @author asus
 */
public class NguoiDungServlet extends HttpServlet {
private NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();
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
            out.println("<title>Servlet NguoiDungServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NguoiDungServlet at " + request.getContextPath() + "</h1>");
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
     protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String hanhDong = req.getParameter("hanhDong");
        if ("dangxuat".equals(hanhDong)) {
            req.getSession().invalidate();
            resp.sendRedirect("trangchu");
            return;
        }
        req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String hanhDong = req.getParameter("hanhDong");
        if ("dangnhap".equals(hanhDong)) {
            String ten = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            NguoiDung nd = nguoiDungDAO.dangNhap(ten, matKhau);
            if (nd != null) {
                req.getSession().setAttribute("nguoiDung", nd);
                resp.sendRedirect("trangchu");
            } else {
                req.setAttribute("loi", "Tên đăng nhập hoặc mật khẩu không đúng");
                req.getRequestDispatcher("dang_nhap.jsp").forward(req, resp);
            }
        } else if ("dangky".equals(hanhDong)) {
            NguoiDung nd = new NguoiDung();
            nd.setTenDangNhap(req.getParameter("tenDangNhap"));
            nd.setMatKhau(req.getParameter("matKhau"));
            nd.setHoTen(req.getParameter("hoTen"));
            nd.setEmail(req.getParameter("email"));
            nd.setSoDienThoai(req.getParameter("soDienThoai"));
            boolean ok = nguoiDungDAO.dangKy(nd);
            if (ok) {
                resp.sendRedirect("dang_nhap.jsp");
            } else {
                req.setAttribute("loi", "Đăng ký thất bại");
                req.getRequestDispatcher("dang_ky.jsp").forward(req, resp);
            }
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
