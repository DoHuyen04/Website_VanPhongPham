package dao;

import model.DonHang;
import model.DonHangChiTiet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO {

    // ➤ Thêm đơn hàng
    public int themDonHang(DonHang dh) {
        String sql = "INSERT INTO donhang(id_nguoidung, diachi, sodienthoai, phuongthuc, tongtien, ngaydat) VALUES (?,?,?,?,?,NOW())";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, dh.getIdNguoiDung());
            ps.setString(2, dh.getDiaChi());
            ps.setString(3, dh.getSoDienThoai());
            ps.setString(4, dh.getPhuongThuc());
            ps.setDouble(5, dh.getTongTien());

            int kq = ps.executeUpdate();

            if (kq > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int idDonHang = rs.getInt(1);

                        // ➤ Lưu chi tiết đơn hàng
                        String sqlCt = "INSERT INTO donhangchitiet(id_donhang, id_sanpham, soluong, gia) VALUES (?,?,?,?)";
                        try (PreparedStatement psCt = cn.prepareStatement(sqlCt)) {
                            for (DonHangChiTiet ct : dh.getChiTiet()) {
                                psCt.setInt(1, idDonHang);
                                psCt.setInt(2, ct.getId_sanpham());
                                psCt.setInt(3, ct.getSoLuong());
                                psCt.setDouble(4, ct.getGia());
                                psCt.addBatch();
                            }
                            psCt.executeBatch();
                        }
                        return idDonHang;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ➤ Lấy danh sách đơn hàng theo người dùng
    public List<DonHang> layDonHangTheoNguoiDung(int idNguoiDung) {
        List<DonHang> ds = new ArrayList<>();
        String sql = "SELECT * FROM donhang WHERE id_nguoidung=? ORDER BY ngaydat DESC";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHang dh = new DonHang();
                    dh.setIdDonHang(rs.getInt("id_donhang"));
                    dh.setIdNguoiDung(rs.getInt("id_nguoidung"));
                    dh.setDiaChi(rs.getString("diachi"));
                    dh.setSoDienThoai(rs.getString("sodienthoai"));
                    dh.setPhuongThuc(rs.getString("phuongthuc"));
                    dh.setTongTien(rs.getDouble("tongtien"));
                    dh.setNgayDat(rs.getDate("ngaydat"));
                    // ➤ Lấy chi tiết đơn hàng
                    dh.setChiTiet(layChiTietDonHang(dh.getIdDonHang()));
                    ds.add(dh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

    // ➤ Lấy chi tiết đơn hàng
    private List<DonHangChiTiet> layChiTietDonHang(int idDonHang) {
        List<DonHangChiTiet> ds = new ArrayList<>();
        String sql = "SELECT * FROM donhangchitiet WHERE id_donhang=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idDonHang);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangChiTiet ct = new DonHangChiTiet();
                    ct.setId_donhangchitiet(rs.getInt("id"));
                    ct.setId_sanpham(rs.getInt("id_sanpham"));
                    ct.setSoLuong(rs.getInt("soluong"));
                    ct.setGia(rs.getDouble("gia"));
                    ds.add(ct);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }
}
