package dao;

import model.DonHang;
import model.DonHangChiTiet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO {

    public int themDonHang(DonHang dh) {
        String sql = "INSERT INTO don_hang(ma_nguoi_dung, dia_chi, so_dien_thoai, phuong_thuc, tong_tien) VALUES (?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, dh.getMaNguoiDung());
            ps.setString(2, dh.getDiaChi());
            ps.setString(3, dh.getSoDienThoai());
            ps.setString(4, dh.getPhuongThuc());
            ps.setDouble(5, dh.getTongTien());
            int kq = ps.executeUpdate();
            if (kq > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int maDon = rs.getInt(1);
                        // lưu chi tiết
                        String sqlCt = "INSERT INTO don_hang_chi_tiet(ma_don_hang, ma_san_pham, so_luong, gia) VALUES (?,?,?,?)";
                        try (PreparedStatement psCt = cn.prepareStatement(sqlCt)) {
                            for (DonHangChiTiet ct : dh.getChiTiet()) {
                                psCt.setInt(1, maDon);
                                psCt.setInt(2, ct.getMaSanPham());
                                psCt.setInt(3, ct.getSoLuong());
                                psCt.setDouble(4, ct.getGia());
                                psCt.addBatch();
                            }
                            psCt.executeBatch();
                        }
                        return maDon;
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<DonHang> layDonHangTheoNguoiDung(int maNguoiDung) {
        List<DonHang> ds = new ArrayList<>();
        String sql = "SELECT id, ma_nguoi_dung, dia_chi, so_dien_thoai, phuong_thuc, tong_tien, ngay_lap FROM don_hang WHERE ma_nguoi_dung=? ORDER BY ngay_lap DESC";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHang dh = new DonHang();
                    dh.setId(rs.getInt("id"));
                    dh.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
                    dh.setDiaChi(rs.getString("dia_chi"));
                    dh.setSoDienThoai(rs.getString("so_dien_thoai"));
                    dh.setPhuongThuc(rs.getString("phuong_thuc"));
                    dh.setTongTien(rs.getDouble("tong_tien"));
                    dh.setNgayLap(rs.getTimestamp("ngay_lap"));
                    // load chi tiết
                    dh.setChiTiet(layChiTietDonHang(dh.getId()));
                    ds.add(dh);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ds;
    }

    private List<DonHangChiTiet> layChiTietDonHang(int maDon) {
        List<DonHangChiTiet> ds = new ArrayList<>();
        String sql = "SELECT id, ma_san_pham, so_luong, gia FROM don_hang_chi_tiet WHERE ma_don_hang=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, maDon);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangChiTiet ct = new DonHangChiTiet();
                    ct.setId(rs.getInt("id"));
                    ct.setMaSanPham(rs.getInt("ma_san_pham"));
                    ct.setSoLuong(rs.getInt("so_luong"));
                    ct.setGia(rs.getDouble("gia"));
                    ds.add(ct);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ds;
    }
}
