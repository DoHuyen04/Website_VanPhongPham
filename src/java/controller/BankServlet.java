/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BankDAO;
import model.BankAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/bank")
public class BankServlet extends HttpServlet {
    private final BankDAO bankDAO = new BankDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession ses = req.getSession(false);
        if (ses == null || ses.getAttribute("tenDangNhap") == null) {
            resp.sendRedirect("dang_nhap.jsp"); return;
        }
        String user = (String) ses.getAttribute("tenDangNhap");
        String act  = req.getParameter("act");

        boolean ok = false;

        try {
            switch (act==null?"":act) {
                case "add" -> {
                    BankAccount b = new BankAccount();
                    b.setTenNganHang(req.getParameter("tennganhang"));
                    b.setSoTaiKhoan(req.getParameter("sotaikhoan"));
                    b.setChuTaiKhoan(req.getParameter("chutaikhoan"));
                    b.setChiNhanh(req.getParameter("chinhanh"));
                    b.setMacDinh("1".equals(req.getParameter("macdinh")));
                    ok = bankDAO.addForUsername(user, b);
                }
                case "delete" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    ok = bankDAO.delete(user, id);
                }
                case "set_default" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    ok = bankDAO.setDefault(user, id);
                }
            }
        } catch (Exception ignored) {}

        ses.setAttribute("msgBank", ok? "Thao tác thành công." : "Thao tác thất bại!");
        resp.sendRedirect("thong_tin_ca_nhan.jsp?tab=bank");
    }

    // Không hỗ trợ GET ở đây, mọi thứ qua POST và redirect về tab
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect("thong_tin_ca_nhan.jsp?tab=bank");
    }
}
