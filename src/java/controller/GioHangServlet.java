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
<<<<<<< HEAD
@SuppressWarnings("unchecked")
=======
@WebServlet(name = "GioHangServlet", urlPatterns = {"/GioHangServlet"})
>>>>>>> origin/huyenpea
public class GioHangServlet extends HttpServlet {

    private SanPhamDAO sanPhamDAO = new SanPhamDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        String action = request.getParameter("action");
//        String idParam = request.getParameter("id");
//
//        if (action != null && action.equals("xoa") && idParam != null) {
//            int idXoa = Integer.parseInt(idParam);
//            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
//
//            if (gioHang != null) {
//                Iterator<Map<String, Object>> iterator = gioHang.iterator();
//                while (iterator.hasNext()) {
//                    Map<String, Object> item = iterator.next();
//                    model.SanPham sp = (model.SanPham) item.get("sanpham");
//                    if (sp.getId_sanpham() == idXoa) {
//                        iterator.remove(); // ✅ Xóa sản phẩm khỏi giỏ
//                        break;
//                    }
//                }
//                session.setAttribute("gioHang", gioHang);
//            }
//        }
//
//        // Quay lại trang giỏ hàng sau khi xóa
//        response.sendRedirect("gio_hang.jsp");

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        // ✅ Xóa sản phẩm khỏi giỏ hàng
        if ("xoa".equals(action) && idParam != null) {
            int idXoa = Integer.parseInt(idParam);
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");

            if (gioHang != null) {
                gioHang.removeIf(item -> {
                    SanPham sp = (SanPham) item.get("sanpham");
                    return sp.getId_sanpham() == idXoa;
                });
                session.setAttribute("gioHang", gioHang);
            }

            response.sendRedirect("gio_hang.jsp");
            return;
        }

        // ✅ Chuyển đến trang hiển thị giỏ hàng
        request.getRequestDispatcher("gio_hang.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        String idSanPham = request.getParameter("idSanPham");
//
//        HttpSession session = request.getSession();
//        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
//        if (gioHang == null) gioHang = new ArrayList<>();
//
//        boolean daCo = false;
//        for (Map<String, Object> item : gioHang) {
//            SanPham sp = (SanPham) item.get("sanpham");
//            if (sp.getId_sanpham() == Integer.parseInt(idSanPham)) { // đổi getId()
//                int sl = (int) item.get("soluong");
//                item.put("soluong", sl + 1);
//                daCo = true;
//                break;
//            }
//        }
//        if (!daCo) {
//            SanPhamDAO dao = new SanPhamDAO();
//            SanPham sp = dao.layTheoId(Integer.parseInt(idSanPham));
//
//            if (sp != null) {
//                Map<String, Object> item = new HashMap<>();
//                item.put("sanpham", sp);
//                item.put("soluong", 1);
//                gioHang.add(item);
//            }
//        }
//
//        session.setAttribute("gioHang", gioHang);
//        response.sendRedirect(request.getHeader("referer"));

        String idSanPham = request.getParameter("idSanPham");
        if (idSanPham == null || idSanPham.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        HttpSession session = request.getSession();
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
        if (gioHang == null) {
            gioHang = new ArrayList<>();
        }

        boolean daCo = false;
        int id = Integer.parseInt(idSanPham);

        // ✅ Nếu sản phẩm đã có trong giỏ thì tăng số lượng
        for (Map<String, Object> item : gioHang) {
            SanPham sp = (SanPham) item.get("sanpham");
            if (sp.getId_sanpham() == id) {
                int sl = (int) item.get("soluong");
                item.put("soluong", sl + 1);
                daCo = true;
                break;
            }
        }

        // ✅ Nếu chưa có thì thêm mới
        if (!daCo) {
            SanPham sp = sanPhamDAO.layTheoId(id);
            if (sp != null) {
                Map<String, Object> item = new HashMap<>();
                item.put("sanpham", sp);
                item.put("soluong", 1);
                gioHang.add(item);
            }
        }

        // ✅ Cập nhật lại session
        session.setAttribute("gioHang", gioHang);

        // ✅ Sau khi thêm sản phẩm, quay lại trang trước
        response.sendRedirect(request.getHeader("referer"));
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý giỏ hàng: thêm, xóa, cập nhật, hiển thị.";
    }
}
