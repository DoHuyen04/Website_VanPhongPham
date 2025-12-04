package controller;

import dao.DonHangDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ShipperCapNhatTrangThai", urlPatterns = {"/ShipperCapNhatTrangThai"})
public class ShipperCapNhatTrangThai extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String msg = "";
        String msgType = "danger";

        try {
            String idStr = request.getParameter("idDonHang");
            String trangThaiMoi = request.getParameter("trangThaiMoi");

            System.out.println("[SERVLET] Received idDonHang=" + idStr + ", trangThaiMoi=" + trangThaiMoi);

            if (idStr == null || idStr.trim().isEmpty()) {
                msg = "❌ Không nhận được ID đơn hàng!";
                System.out.println("[SERVLET] " + msg);
            } else {
                int idDonHang = Integer.parseInt(idStr.trim());
                DonHangDAO dao = new DonHangDAO();

                int affected = dao.capNhatTrangThaiCoDieuKien(idDonHang, trangThaiMoi);

                if (affected > 0) {
                    msg = "✅ Cập nhật trạng thái thành công! ID=" + idDonHang;
                    msgType = "success";
                    System.out.println("[SERVLET] " + msg);
                } else {
                    String currentRaw = dao.layTrangThaiRawVaLog(Integer.parseInt(idStr.trim()));
                    String currentNorm = currentRaw != null ? dao.normalizeStatus(currentRaw) : "N/A";
                    msg = "❌ Cập nhật thất bại! Trạng thái hiện tại: '" + currentNorm + "'";
                    System.out.println("[SERVLET] " + msg);
                }
            }
        } catch (NumberFormatException e) {
            msg = "❌ ID đơn hàng không hợp lệ!";
            System.out.println("[SERVLET] " + msg);
            e.printStackTrace();
        } catch (Exception e) {
            msg = "❌ Lỗi server: " + e.getMessage();
            System.out.println("[SERVLET] " + msg);
            e.printStackTrace();
        }

        request.getSession().setAttribute("msg", msg);
        request.getSession().setAttribute("msgType", msgType);
        response.sendRedirect("ShipperDonHang");
    }
}