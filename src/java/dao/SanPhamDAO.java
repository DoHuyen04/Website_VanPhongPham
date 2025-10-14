package dao;

import model.SanPham;
import java.sql.*;
import java.util.*;

public class SanPhamDAO {

    public List<SanPham> layTatCa() {
        List<SanPham> ds = new ArrayList<>();
        String sql = "SELECT id, ten, moTa, gia, danhMuc, soLuong, hinhAnh FROM sanpham";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setId(rs.getInt("id"));
                sp.setTen(rs.getString("ten"));
                sp.setMoTa(rs.getString("moTa"));
                sp.setGia(rs.getDouble("gia"));
                sp.setDanhMuc(rs.getString("danhMuc"));
                sp.setSoLuong(rs.getInt("soLuong"));
                sp.setHinhAnh(rs.getString("hinhAnh"));
                ds.add(sp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ds;
    }

    public SanPham layTheoId(int id) {
        String sql = "SELECT id, ten, moTa, gia, danhMuc, soLuong, hinhAnh FROM sanpham WHERE id=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId(rs.getInt("id"));
                    sp.setTen(rs.getString("ten"));
                    sp.setMoTa(rs.getString("moTa"));
                    sp.setGia(rs.getDouble("gia"));
                    sp.setDanhMuc(rs.getString("danhMuc"));
                    sp.setSoLuong(rs.getInt("soLuong"));
                    sp.setHinhAnh(rs.getString("hinhAnh"));
                    return sp;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<SanPham> timTheoTuKhoa(String tuKhoa) {
        List<SanPham> ds = new ArrayList<>();
        String sql = "SELECT id, ten, moTa, gia, danhMuc, soLuong, hinhAnh FROM sanpham WHERE ten LIKE ?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, "%" + tuKhoa + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId(rs.getInt("id"));
                    sp.setTen(rs.getString("ten"));
                    sp.setMoTa(rs.getString("moTa"));
                    sp.setGia(rs.getDouble("gia"));
                    sp.setDanhMuc(rs.getString("danhMuc"));
                    sp.setSoLuong(rs.getInt("soLuong"));
                    sp.setHinhAnh(rs.getString("hinhAnh"));
                    ds.add(sp);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return ds;
    }
}
