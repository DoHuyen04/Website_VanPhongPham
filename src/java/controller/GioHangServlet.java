/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SanPhamDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.SanPham;

/**
 *
 * @author asus
 */
public class GioHangServlet extends HttpServlet {
 private SanPhamDAO sanPhamDAO = new SanPhamDAO();
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
            out.println("<title>Servlet GioHangServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GioHangServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    public void init() throws ServletException {
        sanPhamDAO = new SanPhamDAO();
    }

    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession phien = req.getSession();
        List<Map<String,Object>> gioHang = (List<Map<String,Object>>) phien.getAttribute("gioHang");
        if (gioHang == null) {
            gioHang = new ArrayList<>();
            phien.setAttribute("gioHang", gioHang);
        }

        String hanhDong = req.getParameter("hanhDong");
        if (hanhDong == null) hanhDong = "xem";

        switch (hanhDong) {
            case "them":
                them(req, gioHang);
                break;
            case "xoa":
                xoa(req, gioHang);
                break;
            case "capnhat":
                capNhat(req, gioHang);
                break;
            default:
                break;
        }
        resp.sendRedirect("gio_hang.jsp");
    }

    private void them(HttpServletRequest req, List<Map<String,Object>> gioHang) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            SanPham sp = sanPhamDAO.layTheoId(id);
            if (sp == null) return;
            for (Map<String,Object> item : gioHang) {
                SanPham s = (SanPham) item.get("sanpham");
                if (s.getId() == id) {
                    int sl = (int) item.get("soluong");
                    item.put("soluong", sl + 1);
                    return;
                }
            }
            Map<String,Object> newItem = new HashMap<>();
            newItem.put("sanpham", sp);
            newItem.put("soluong", 1);
            gioHang.add(newItem);
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void xoa(HttpServletRequest req, List<Map<String,Object>> gioHang) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            gioHang.removeIf(item -> ((SanPham)item.get("sanpham")).getId() == id);
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void capNhat(HttpServletRequest req, List<Map<String,Object>> gioHang) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int slMoi = Integer.parseInt(req.getParameter("soLuong"));
            for (Map<String,Object> item : gioHang) {
                SanPham s = (SanPham) item.get("sanpham");
                if (s.getId() == id) {
                    item.put("soluong", slMoi);
                    break;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
 @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
