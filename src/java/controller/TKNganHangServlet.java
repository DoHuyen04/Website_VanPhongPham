/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.TKNganHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.TKNganHang;

@WebServlet(name = "TKNganHangServlet", urlPatterns = {"/TKNganHangServlet"})
public class TKNganHangServlet extends HttpServlet {

    private final TKNganHangDAO tkDAO = new TKNganHangDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    req.setCharacterEncoding("UTF-8");

    HttpSession session = req.getSession(false);
    if (session == null) {
        resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
        return;
    }

    // Đồng bộ: chấp nhận CẢ userId HOẶC tenDangNhap
    Integer idNguoiDungObj = (Integer) session.getAttribute("userId");
    String tenDangNhap = (String) session.getAttribute("tenDangNhap");

    if (idNguoiDungObj == null && (tenDangNhap == null || tenDangNhap.isBlank())) {
        resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
        return;
    }

    // Dùng id nếu có, nếu không có thì để -1 (để nhánh dùng username hoạt động)
    int idNguoiDung = (idNguoiDungObj != null) ? idNguoiDungObj : -1;

    String action = req.getParameter("act");
    boolean success = false;

    try {
        switch (action == null ? "" : action) {

            case "add" -> {
                TKNganHang tk = new TKNganHang();
                if (idNguoiDung != -1) tk.setId_nguoidung(idNguoiDung);
                tk.setTenNganHang(req.getParameter("tenNganHang"));
                tk.setSoTaiKhoan(req.getParameter("soTaiKhoan"));
                tk.setChuTaiKhoan(req.getParameter("chuTaiKhoan"));
                tk.setChiNhanh(req.getParameter("chiNhanh"));
                String md = String.valueOf(req.getParameter("macDinh"));
                tk.setMacDinh("1".equals(md) || "on".equalsIgnoreCase(md) || "true".equalsIgnoreCase(md));
                tk.setTrangThai("approved");
                success = tkDAO.themTaiKhoan(tenDangNhap, tk);          // nếu DAO theo tenDangNhap
            }

            case "delete" -> {
                int idTkNganHang = Integer.parseInt(req.getParameter("id_TkNganHang"));
                success = (idNguoiDung != -1)
                        ? tkDAO.xoaTaiKhoan(idNguoiDung, idTkNganHang)
                        : tkDAO.xoaTaiKhoan(tenDangNhap, idTkNganHang);
            }

            case "set_default" -> {
                int idTkNganHang = Integer.parseInt(req.getParameter("id_TkNganHang"));
                success = (idNguoiDung != -1)
                        ? tkDAO.datMacDinh(idNguoiDung, idTkNganHang)
                        : tkDAO.datMacDinh(tenDangNhap, idTkNganHang);
            }

            default -> success = false;
        }
    } catch (Exception e) {
        e.printStackTrace();
        success = false;
    }

    session.setAttribute("msgBank", success ? "Thao tác thành công." : "Thao tác thất bại!");
    resp.sendRedirect(req.getContextPath() + "/thong_tin_ca_nhan.jsp?tab=tknh");
}
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect("thong_tin_ca_nhan.jsp?tab=tknh");
    }
}
