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

        // Có thể có cả userId lẫn tenDangNhap, ưu tiên userId
        Integer idNguoiDungObj = (Integer) session.getAttribute("userId");
        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        if (idNguoiDungObj == null && (tenDangNhap == null || tenDangNhap.isBlank())) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        int userId = (idNguoiDungObj != null) ? idNguoiDungObj : -1;

        String action = req.getParameter("action");
        if (action == null) {
            action = req.getParameter("act");
        }
        if ("set_default".equalsIgnoreCase(action)) {
            action = "setDefault";
        }

        boolean success = false;

        try {
            if ("add".equals(action)) {
                TKNganHang tk = new TKNganHang();
                tk.setTenNganHang(req.getParameter("tenNganHang"));
                tk.setSoTaiKhoan(req.getParameter("soTaiKhoan"));
                tk.setChuTaiKhoan(req.getParameter("chuTaiKhoan"));
                tk.setChiNhanh(req.getParameter("chiNhanh"));

                String md = String.valueOf(req.getParameter("macDinh")); 
                tk.setMacDinh("1".equals(md) || "on".equalsIgnoreCase(md) || "true".equalsIgnoreCase(md));
                tk.setTrangThai("daduyet"); 

                if (userId != -1) {
                    tk.setId_nguoidung(userId);
                    success = tkDAO.themTaiKhoanByUserId(userId, tk);
                } else {
                    success = tkDAO.themTaiKhoan(tenDangNhap, tk);
                }

            } else if ("delete".equals(action)) {
                int idTk = Integer.parseInt(req.getParameter("id"));
                success = (userId != -1)
                        ? tkDAO.xoaTaiKhoan(userId, idTk)
                        : tkDAO.xoaTaiKhoan(tenDangNhap, idTk);

            } else if ("setDefault".equals(action)) {
                int idTk = Integer.parseInt(req.getParameter("id"));
                success = (userId != -1)
                        ? tkDAO.datMacDinh(userId, idTk)
                        : tkDAO.datMacDinh(tenDangNhap, idTk);

            } else {
                success = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            success = false;
        }
        session.setAttribute("msgBank", success ? "Lưu thẻ thành công!" : "Thao tác thất bại!");
        resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=tknh");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/nguoidung?hanhDong=hoso&tab=tknh");

    }
}
