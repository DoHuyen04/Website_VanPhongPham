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
@WebServlet(name = "GioHangServlet", urlPatterns = {"/GioHangServlet"})
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
HttpSession session = request.getSession();
    String action = request.getParameter("action");
    String idParam = request.getParameter("id");

    // ✅ Xử lý xóa sản phẩm khỏi giỏ
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

        // ✅ Quay lại trang giỏ hàng sau khi xóa
        response.sendRedirect("GioHangServlet");
        return;
    }

    // ✅ Nếu không có action => hiển thị giỏ hàng
    List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
    if (gioHang == null) {
        gioHang = new ArrayList<>();
        session.setAttribute("gioHang", gioHang);
    }

    // Gửi danh sách giỏ hàng qua JSP
    request.setAttribute("gioHang", gioHang);
    RequestDispatcher rd = request.getRequestDispatcher("gio_hang.jsp");
    rd.forward(request, response);
//    
//        HttpSession session = request.getSession();
//        String action = request.getParameter("action");
//        String idParam = request.getParameter("id");
//
//        // ✅ Xóa sản phẩm khỏi giỏ hàng
//        if ("xoa".equals(action) && idParam != null) {
//            int idXoa = Integer.parseInt(idParam);
//            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
//
//            if (gioHang != null) {
//                gioHang.removeIf(item -> {
//                    SanPham sp = (SanPham) item.get("sanpham");
//                    return sp.getId_sanpham() == idXoa;
//                });
//                session.setAttribute("gioHang", gioHang);
//                int tongSoLuong = tinhTongSoLuong(gioHang);
//                session.setAttribute("tongSoLuong", tongSoLuong);
//
//                String redirect = request.getParameter("redirect");
//                if (redirect != null && redirect.equals("content")) {
//                    response.sendRedirect("content.jsp");
//                } else {
//                    response.sendRedirect("gio_hang.jsp");
//                }
//            }
//        }
    }

    private void themSanPham(HttpServletRequest req, List<Map<String, Object>> gioHang) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            SanPham sp = sanPhamDAO.layTheoId(id);
            if (sp == null) {
                return;
            }

            for (Map<String, Object> item : gioHang) {
                SanPham s = (SanPham) item.get("sanpham");
                if (s.getId_sanpham() == id) {            // đổi getId() -> getId_sanpham()
                    int soLuong = (int) item.get("soluong");
                    item.put("soluong", soLuong + 1);
                    return;
                }

            }
            Map<String, Object> newItem = new HashMap<>();
            newItem.put("sanpham", sp);
            newItem.put("soluong", 1);
            gioHang.add(newItem);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void xoaSanPham(HttpServletRequest req, List<Map<String, Object>> gioHang) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            gioHang.removeIf(item -> ((SanPham) item.get("sanpham")).getId_sanpham() == id); // đổi getId()
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void capNhatSoLuong(HttpServletRequest req, List<Map<String, Object>> gioHang) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int soLuongMoi = Integer.parseInt(req.getParameter("soLuong"));
            for (Map<String, Object> item : gioHang) {
                SanPham s = (SanPham) item.get("sanpham");
                if (s.getId_sanpham() == id) {           // đổi getId()
                    item.put("soluong", soLuongMoi);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int tinhTongSoLuong(List<Map<String, Object>> gioHang) {
        int tong = 0;
        for (Map<String, Object> item : gioHang) {
            tong += (int) item.get("soluong");
        }
        return tong;
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
            
            if (sp.getId_sanpham() == Integer.parseInt(idSanPham)) { // đổi getId()

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

        session.setAttribute("gioHang", gioHang);

        response.sendRedirect(request.getHeader("referer"));
    }

    @Override
public String getServletInfo() {
        return "Servlet xử lý giỏ hàng: thêm, xóa, cập nhật, hiển thị.";
    }
}