package controller;

import dao.DonHangDAO;
import model.DonHang;
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
        try {
            String idStr = request.getParameter("idDonHang");
            String trangThaiMoi = request.getParameter("trangThaiMoi");

            System.out.println("[DEBUG] Nhận request: idDonHang=" + idStr + ", trangThaiMoi=" + trangThaiMoi);

            int idDonHang = Integer.parseInt(idStr.trim());

            DonHangDAO dao = new DonHangDAO();
            DonHang dh = dao.layDonHangTheoId(idDonHang);

            if (dh == null) {
                msg = "❌ Không tìm thấy đơn hàng với ID=" + idDonHang;
                System.out.println("[ERROR] " + msg);
            } else {
                String ttHienTai = dh.getTrangthai();
                System.out.println("[DEBUG] Trạng thái hiện tại: '" + ttHienTai + "'");

                // Cập nhật trực tiếp mà không kiểm tra cứng nhắc
                boolean success = dao.capNhatTrangThai(idDonHang, trangThaiMoi.trim().toLowerCase());

                if (success) {
                    msg = "✅ Cập nhật trạng thái thành công! ID=" + idDonHang + ", từ '" + ttHienTai + "' → '" + trangThaiMoi + "'";
                    System.out.println("[SUCCESS] " + msg);
                } else {
                    msg = "❌ Cập nhật thất bại! Vui lòng kiểm tra kết nối DB hoặc ID hợp lệ.";
                    System.out.println("[FAIL] " + msg);
                }
            }

        } catch (NumberFormatException e) {
            msg = "❌ ID đơn hàng không hợp lệ!";
            System.out.println("[ERROR] " + msg);
            e.printStackTrace();
        } catch (Exception e) {
            msg = "❌ Lỗi server khi cập nhật trạng thái: " + e.getMessage();
            System.out.println("[ERROR] " + msg);
            e.printStackTrace();
        }

        request.getSession().setAttribute("msg", msg);
        response.sendRedirect("ShipperDonHang");
    }
}
