/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.NguoiDungDAO;
import model.NguoiDung;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/TaiKhoanServlet")
public class TaiKhoanServlet extends HttpServlet {

    private final NguoiDungDAO ndDao = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession ses = req.getSession(false);
        NguoiDung ndSession = (ses != null) ? (NguoiDung) ses.getAttribute("nguoiDung") : null;

        if (ndSession == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }

        NguoiDung nd = ndDao.layTheoTenDangNhap(ndSession.getTenDangNhap());
        req.setAttribute("nguoiDung", nd);
        req.getRequestDispatcher("thong_tin_ca_nhan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession ses = req.getSession(false);
        NguoiDung ndSession = (ses != null) ? (NguoiDung) ses.getAttribute("nguoiDung") : null;

        if (ndSession == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }

        NguoiDung nd = new NguoiDung();
        nd.setTenDangNhap(ndSession.getTenDangNhap());
        nd.setHoTen(req.getParameter("hoTen"));
        nd.setEmail(req.getParameter("email"));
        nd.setSoDienThoai(req.getParameter("soDienThoai"));

        boolean ok = ndDao.capNhatThongTin(nd);
        ses.setAttribute("msgTK", ok ? "Đã lưu hồ sơ." : "Lưu thất bại!");
        resp.sendRedirect("TaiKhoanServlet");
    }
}
