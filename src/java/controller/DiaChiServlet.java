/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DiaChiDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.DiaChi;

@WebServlet(name = "DiaChiServlet", urlPatterns = {"/DiaChiServlet"})
public class DiaChiServlet extends HttpServlet {

    private final DiaChiDAO dao = new DiaChiDAO();

    // HIỂN THỊ DANH SÁCH ĐỊA CHỈ
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy session để biết user đang đăng nhập
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        // Nếu chưa đăng nhập thì quay lại trang đăng nhập
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        // Lấy danh sách địa chỉ của user
        List<DiaChi> dsDiaChi = dao.listByUser(userId);

        // Gắn vào request để JSP hiển thị
        req.setAttribute("dsDiaChi", dsDiaChi);

        // Chuyển đến trang JSP hiển thị (tạo file dia_chi.jsp ở bước 4)
        req.getRequestDispatcher("/tk_dia_chi.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        String action = req.getParameter("action");

        // URL quay lại đúng tab Địa chỉ
        String backTo = req.getParameter("backTo");
        if (backTo == null || backTo.isBlank()) {
            backTo = req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=address";
        }

        try {
            switch (action) {
                case "add": {
                    DiaChi d = buildFromReq(req, userId);
                    if (d.isMacDinh()) {
                        dao.clearDefault(userId);
                    }
                    dao.insert(d);
                    break;
                }
                case "update": {
                    DiaChi d = buildFromReq(req, userId);
                    d.setId(Integer.parseInt(req.getParameter("id")));
                    if (d.isMacDinh()) {
                        dao.clearDefault(userId);
                    }
                    dao.update(d);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    dao.delete(id, userId);
                    break;
                }
                case "setDefault": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    dao.setDefault(id, userId);
                    break;
                }

                default:
                    System.out.println("⚠️ Action không hợp lệ: " + action);
            }
            resp.sendRedirect(backTo);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(backTo);
            return;
        }
    }

    // ✅ Hàm build địa chỉ từ request
    private DiaChi buildFromReq(HttpServletRequest req, int userId) {
        DiaChi d = new DiaChi();
        d.setUserId(userId);
        d.setHoTen(req.getParameter("hoTen"));
        d.setSoDienThoai(req.getParameter("soDienThoai"));
        d.setDiaChiDuong(req.getParameter("diaChiDuong"));
        d.setXaPhuong(req.getParameter("xaPhuong"));
        d.setQuanHuyen(req.getParameter("quanHuyen"));
        d.setTinhThanh(req.getParameter("tinhThanh"));
        d.setMacDinh("on".equals(req.getParameter("macDinh"))); // checkbox
        return d;
    }
}
