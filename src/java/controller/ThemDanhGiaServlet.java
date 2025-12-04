package controller;

import dao.DanhGiaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import model.DanhGia;
import model.NguoiDung;

@WebServlet(name = "ThemDanhGiaServlet", urlPatterns = {"/them_danh_gia"})
@MultipartConfig
public class ThemDanhGiaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        NguoiDung nd = (session != null) ? (NguoiDung) session.getAttribute("nguoiDung") : null;
        if (nd == null) {
            response.sendRedirect(request.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        try {
            int idSanPham = Integer.parseInt(request.getParameter("idSanPham"));
            int idDonHang = Integer.parseInt(request.getParameter("idDonHang"));
            int sao = Integer.parseInt(request.getParameter("sao"));
            String binhLuan = request.getParameter("binhLuan");

            // ---- XỬ LÝ ẢNH ----
            Part imgPart = request.getPart("hinhAnh");   // name="hinhAnh" trong form
            String fileName = null;

            if (imgPart != null && imgPart.getSize() > 0) {
                // Tên file gốc
                String submittedFileName = Paths.get(imgPart.getSubmittedFileName())
                        .getFileName().toString();

                String uploadDir = getServletContext().getRealPath("/uploads/review");

                System.out.println("=== UPLOAD DIR (review) = " + uploadDir + " ===");
                System.out.println("=== Context path = " + request.getContextPath() + " ===");

                Path uploadPath = Paths.get(uploadDir);

                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                // Đổi tên cho unique
                fileName = System.currentTimeMillis() + "_" + submittedFileName;

                // Lưu file
                imgPart.write(uploadDir + File.separator + fileName);
            }

            DanhGia dg = new DanhGia();
            dg.setIdNguoiDung(nd.getId());
            dg.setIdSanPham(idSanPham);
            dg.setIdDonHang(idDonHang);
            dg.setSao(sao);
            dg.setBinhLuan(binhLuan);
            dg.setHinhAnh(fileName);

            DanhGiaDAO dao = new DanhGiaDAO();
            dao.themDanhGia(dg);

            response.sendRedirect(request.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=dadat");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=dadat"
            );
        }

    }

}
