/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.TKNganHangDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TKNganHang;

/**
 *
 * @author asus
 */
@WebServlet(name = "TKNganHangServlet", urlPatterns = {"/TKNganHangServlet"})
public class TKNganHangServlet extends HttpServlet {

    private final TKNganHangDAO tkDAO = new TKNganHangDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("tenDangNhap") == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }

        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        String action = req.getParameter("act");
        boolean success = false;

        try {
            switch (action == null ? "" : action) {
                case "add" -> {
                    TKNganHang tk = new TKNganHang();
                    tk.setTenNganHang(req.getParameter("tennganhang"));
                    tk.setSoTaiKhoan(req.getParameter("sotaikhoan"));
                    tk.setChuTaiKhoan(req.getParameter("chutaikhoan"));
                    tk.setChiNhanh(req.getParameter("chinhanh"));
                    tk.setMacDinh("1".equals(req.getParameter("macdinh")));
                    tk.setTrangThai("approved"); // hoặc "pending" nếu cần duyệt
                    success = tkDAO.themTaiKhoanTheoTenDangNhap(tenDangNhap, tk);
                }
                case "delete" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    success = tkDAO.xoaTaiKhoan(tenDangNhap, id);
                }
                case "set_default" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    success = tkDAO.datMacDinh(tenDangNhap, id);
                }
                default -> success = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Gửi thông báo kết quả
        session.setAttribute("msgBank", success ? "Thao tác thành công." : "Thao tác thất bại!");
        resp.sendRedirect("thong_tin_ca_nhan.jsp?tab=tknh");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect("thong_tin_ca_nhan.jsp?tab=tknh");
    }
}