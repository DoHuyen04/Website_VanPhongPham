/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SanPhamDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import model.SanPham;

/**
 *
 * @author asus
 */
@WebServlet(name = "CapNhatGioHangServlet", urlPatterns = {"/CapNhatGioHangServlet"})
public class CapNhatGioHangServlet extends HttpServlet {

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
            out.println("<title>Servlet CapNhatGioHangServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CapNhatGioHangServlet at " + request.getContextPath() + "</h1>");
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
        response.sendRedirect("giohang.jsp");
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
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");

        Map<String, Object> result = new HashMap<>();
        if (gioHang == null || gioHang.isEmpty()) {
            result.put("status", "error");
            result.put("message", "Giỏ hàng trống");
            out.print(toJSON(result));
            return;
        }

        // 1️⃣ Update số lượng (nếu có)
        String id_raw = request.getParameter("id");
        String sl_raw = request.getParameter("soluong");
        if (id_raw != null && sl_raw != null) {
            try {
                int id = Integer.parseInt(id_raw);
                int soLuong = Integer.parseInt(sl_raw);

                Iterator<Map<String, Object>> iter = gioHang.iterator();
                boolean found = false;

                while (iter.hasNext()) {
                    Map<String, Object> item = iter.next();
                    SanPham sp = (SanPham) item.get("sanpham");

                    if (sp.getId_sanpham() == id) {
                        found = true;

                        if (soLuong <= 0) {
                            iter.remove();
                            result.put("status", "removed");
                            result.put("message", "Đã xóa sản phẩm khỏi giỏ hàng");
                        } else {
                            item.put("soluong", soLuong);
                            result.put("status", "success");
                            result.put("message", "Đã cập nhật số lượng");
                        }
                        break;
                    }
                }

                if (!found) {
                    result.put("status", "error");
                    result.put("message", "Sản phẩm không tồn tại");
                }

            } catch (NumberFormatException e) {
                result.put("status", "error");
                result.put("message", "Tham số không hợp lệ");
            }
        }

        // 2️⃣ Cập nhật tick chọn
        for (Map<String, Object> item : gioHang) {
            item.put("daChon", false);
        }

        String[] chonSP = request.getParameterValues("chonSP");

        if (chonSP != null) {
            for (String idStr : chonSP) {
                try {
                    int id = Integer.parseInt(idStr);
                    for (Map<String, Object> item : gioHang) {
                        SanPham sp = (SanPham) item.get("sanpham");
                        if (sp.getId_sanpham() == id) {
                            item.put("daChon", true);
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        // 3️⃣ Build danh sách gioHangChon
       List<Map<String, Object>> gioHangChon = new ArrayList<>();
    double tongTienHang = 0;
    for (Map<String, Object> item : gioHang) {
        if (Boolean.TRUE.equals(item.get("daChon"))) {
            gioHangChon.add(item);
            SanPham sp = (SanPham) item.get("sanpham");
            int soLuong = (item.get("soluong") instanceof Integer) ? (Integer) item.get("soluong")
                      : Integer.parseInt(item.get("soluong").toString());
            tongTienHang += sp.getGia() * soLuong;
        }
    }

    // 3.1 Nếu không có sản phẩm nào được chọn (mới truy cập checkout), bạn có thể
    //     tự động chọn tất cả để tránh hiển thị rỗng — tùy bạn có muốn auto-select hay không.
    if (gioHangChon.isEmpty()) {
        // OPTION A: tự chọn tất cả (bỏ comment nếu muốn)
        for (Map<String, Object> item : gioHang) {
            item.put("daChon", true);
            gioHangChon.add(item);
            SanPham sp = (SanPham) item.get("sanpham");
            int soLuong = (item.get("soluong") instanceof Integer) ? (Integer) item.get("soluong")
                      : Integer.parseInt(item.get("soluong").toString());
            tongTienHang += sp.getGia() * soLuong;
        }
        // result.put("autoSelected", true);
    }

 // 4️⃣ Lưu lại session
        session.setAttribute("gioHang", gioHang);
        session.setAttribute("gioHangChon", gioHangChon);
         session.setAttribute("tongTienHang", tongTienHang);
        if (!result.containsKey("status")) {
            result.put("status", "success");
            result.put("message", "Cập nhật giỏ hàng thành công");
        }
        out.print(toJSON(result));
    }

    private String toJSON(Map<String, Object> map) {
        return "{"
                + "\"status\":\"" + map.get("status") + "\","
                + "\"message\":\"" + map.get("message") + "\""
                + "}";
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
