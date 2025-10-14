package dao;

import model.DanhGia;
import java.sql.*;
import java.util.*;

public class DanhGiaDAO {

    public boolean themDanhGia(DanhGia dg) {
        String sql = "INSERT INTO danh_gia(ma_nguoi_dung, ma_san_pham, sao, binh_luan) VALUES (?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, dg.getMaNguoiDung());
            ps.setInt(2, dg.getMaSanPham());
            ps.setInt(3, dg.getSao());
            ps.setString(4, dg.getBinhLuan());
            int kq = ps.executeUpdate();
            return kq > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<DanhGia> layDanhGiaTheoSanPham(int maSanPham) {
        List<DanhGia> ds = new ArrayList<>();
        String sql = "SELECT id, ma_nguoi_dung, ma_san_pham, sao, binh_luan, ngay FROM danh_gia WHERE ma_san_pham=? ORDER BY ngay DESC";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, maSanPham);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DanhGia dg = new DanhGia();
                    dg.setId(rs.getInt("id"));
                    dg.setMaNguoiDung(rs.getInt("ma_nguoi_dung"));
                    dg.setMaSanPham(rs.getInt("ma_san_pham"));
                    dg.setSao(rs.getInt("sao"));
                    dg.setBinhLuan(rs.getString("binh_luan"));
                    dg.setNgay(rs.getTimestamp("ngay"));
                    ds.add(dg);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ds;
    }
}
