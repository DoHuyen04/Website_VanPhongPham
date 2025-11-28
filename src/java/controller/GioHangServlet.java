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
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
HttpSession session = request.getSession(false);
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
     String action = request.getParameter("action");
    HttpSession session = request.getSession();
    List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
    if (gioHang == null) {
        gioHang = new ArrayList<>();
    }

   if ("xoaNhieu".equals(action)) {
    String ids = request.getParameter("ids");
    if (ids != null && !ids.isEmpty()) {
        Set<String> setIds = new HashSet<>();
        for(String s : ids.split(",")) setIds.add(s.trim()); // ✅ trim
        gioHang.removeIf(item -> setIds.contains(String.valueOf(((SanPham)item.get("sanpham")).getId_sanpham())));
    }
    session.setAttribute("gioHang", gioHang);
    response.getWriter().write("OK");
    return;
}

    if ("capnhat".equals(action)) {
        int id = Integer.parseInt(request.getParameter("idSanPham"));
        int soLuongMoi = Integer.parseInt(request.getParameter("soLuong"));
        capNhatSoLuong(request, gioHang);
        session.setAttribute("gioHang", gioHang);
        response.sendRedirect("GioHangServlet");
        return;
    }
    String tenDangNhap = (session != null) ? (String) session.getAttribute("tenDangNhap") : null;

    if (tenDangNhap == null) {
        // Nếu chưa đăng nhập → chuyển đến trang đăng nhập
        response.sendRedirect("dang_nhap.jsp?error=notloggedin");
        return;
    }


    String idSanPham = request.getParameter("idSanPham");
    if (idSanPham == null || idSanPham.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    int id = Integer.parseInt(idSanPham);
    SanPham sp = sanPhamDAO.layTheoId(id);
    if (sp == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int tonKho = sp.getSoLuong(); // 🔹 Cần có getter này trong model
    
    if (gioHang == null) gioHang = new ArrayList<>();

    boolean daCo = false;
    String message = "";

    for (Map<String, Object> item : gioHang) {
        SanPham spGio = (SanPham) item.get("sanpham");
        if (spGio.getId_sanpham() == id) {
            int soLuongHienTai = (int) item.get("soluong");
            if (soLuongHienTai + 1 > tonKho) {
                message = "⚠️ Cảnh báo: Số lượng vượt quá tồn kho (" + tonKho + ")";
            } else {
                item.put("soluong", soLuongHienTai + 1);
                message = "Đã thêm" + sp.getTen() +" vào giỏ hàng thành công";
            }
            daCo = true;
            break;
        }
    }

    if (!daCo) {
        if (tonKho > 0) {
            Map<String, Object> item = new HashMap<>();
            item.put("sanpham", sp);
            item.put("soluong", 1);
            gioHang.add(item);
            message = "Đã thêm" + sp.getTen() +" vào giỏ hàng thành công";
        } else {
            message = "⚠️ Cảnh báo: Sản phẩm \"" + sp.getTen() + "\" đã hết hàng!";
        }
    }

    session.setAttribute("gioHang", gioHang);
    session.setAttribute("message", message);

    response.sendRedirect(request.getHeader("referer"));
    }

    @Override
public String getServletInfo() {
        return "Servlet xử lý giỏ hàng: thêm, xóa, cập nhật, hiển thị.";
    }
}