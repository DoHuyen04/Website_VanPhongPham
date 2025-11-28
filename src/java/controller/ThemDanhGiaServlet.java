package controller;

import dao.DanhGiaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.DanhGia;
import model.NguoiDung;

@WebServlet(name = "ThemDanhGiaServlet", urlPatterns = {"/them_danh_gia"})
public class ThemDanhGiaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // Lấy user từ session
        NguoiDung nd = (session != null) ? (NguoiDung) session.getAttribute("nguoiDung") : null;
        if (nd == null) {
            // Chưa đăng nhập → đẩy về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        try {
            int idSanPham = Integer.parseInt(request.getParameter("idSanPham"));
            int sao = Integer.parseInt(request.getParameter("sao"));
            String binhLuan = request.getParameter("binhLuan");

            DanhGia dg = new DanhGia();
            dg.setIdNguoiDung(nd.getId());
            dg.setIdSanPham(idSanPham);
            dg.setSao(sao);
            dg.setBinhLuan(binhLuan);

            DanhGiaDAO dao = new DanhGiaDAO();
            dao.themDanhGia(dg);

            response.sendRedirect(request.getContextPath()  + "/DonHangServlet?hanhDong=lichsu&tab=dadat");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/loi.jsp");
        }
    }
}
