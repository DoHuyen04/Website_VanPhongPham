package controller;

import dao.DonHangDAO;
import jakarta.servlet.http.HttpSession;
import model.DonHang;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ShipperCapNhatDonServlet")
public class ShipperCapNhatDonServlet extends HttpServlet {

     protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));
        
        DonHangDAO dao = new DonHangDAO();
        HttpSession ss = request.getSession();

        switch (action) {

            case "danggiao":
                dao.capNhatTrangThai(id, "danggiao");
                ss.setAttribute("msg", "🚚 Đơn hàng " + id + " đang giao");
                break;

            case "dagiao":
                dao.capNhatTrangThai(id, "dagiao");
                ss.setAttribute("msg", "✅ Đã giao đơn hàng " + id);
                break;

            case "hoankho":
                dao.capNhatTrangThai(id, "hoankho");
                ss.setAttribute("msg", "📦 Đơn hàng " + id + " đã hoàn kho");
                break;
        }

        response.sendRedirect("ShipperDonHang");
    }

    // Hàm lưu đơn hàng sang bảng donhang_dagiao
    private void saveDonHangDaGiao(DonHang dh){
        String sqlDon = "INSERT INTO donhang_dagiao(id_donhang, id_nguoidung, diachi, sodienthoai, phuongthuc, tongtien, ngaydat) VALUES (?,?,?,?,?,?,?)";
        String sqlChiTiet = "INSERT INTO donhang_dagiao_chitiet(id_donhang, id_sanpham, soluong, gia) VALUES (?,?,?,?)";

        try (Connection cn = dao.DBUtil.getConnection();
             PreparedStatement psDon = cn.prepareStatement(sqlDon);
             PreparedStatement psCt = cn.prepareStatement(sqlChiTiet)) {

            cn.setAutoCommit(false);

            // Lưu thông tin đơn hàng
            psDon.setInt(1, dh.getIdDonHang());
            psDon.setInt(2, dh.getIdNguoiDung());
            psDon.setString(3, dh.getDiaChi());
            psDon.setString(4, dh.getSoDienThoai());
            psDon.setString(5, dh.getPhuongThuc());
            psDon.setDouble(6, dh.getTongTien());
            psDon.setDate(7, new java.sql.Date(dh.getNgayDat().getTime()));
            psDon.executeUpdate();

            // Lưu chi tiết đơn hàng
            if(dh.getChiTiet() != null){
                for(var ct : dh.getChiTiet()){
                    psCt.setInt(1, dh.getIdDonHang());
                    psCt.setInt(2, ct.getId_sanpham());
                    psCt.setInt(3, ct.getSoLuong());
                    psCt.setDouble(4, ct.getGia());
                    psCt.addBatch();
                }
                psCt.executeBatch();
            }

            cn.commit();
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}