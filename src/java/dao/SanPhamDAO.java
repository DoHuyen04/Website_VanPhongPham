package dao;

import model.SanPham;
import java.sql.*;
import java.util.*;

public class SanPhamDAO {

    // ✅ Lấy tất cả sản phẩm
    public List<SanPham> layTatCa() {
        List<SanPham> ds = new ArrayList<>();
        String sql = "SELECT id_sanpham, ten, moTa, gia, danhMuc, soLuong, hinhAnh, loai FROM sanpham";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setId_sanpham(rs.getInt("id_sanpham"));
                sp.setTen(rs.getString("ten"));
                sp.setMoTa(rs.getString("moTa"));
                sp.setGia(rs.getDouble("gia"));
                sp.setDanhMuc(rs.getString("danhMuc"));
                sp.setSoLuong(rs.getInt("soLuong"));
                sp.setHinhAnh(rs.getString("hinhAnh"));
                sp.setLoai(rs.getString("loai"));
                ds.add(sp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

    // ✅ Lấy sản phẩm theo ID
    public SanPham layTheoId(int id) {
        String sql = "SELECT id_sanpham, ten, moTa, gia, danhMuc, soLuong, hinhAnh, loai FROM sanpham WHERE id_sanpham=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId_sanpham(rs.getInt("id_sanpham"));
                    sp.setTen(rs.getString("ten"));
                    sp.setMoTa(rs.getString("moTa"));
                    sp.setGia(rs.getDouble("gia"));
                    sp.setDanhMuc(rs.getString("danhMuc"));
                    sp.setSoLuong(rs.getInt("soLuong"));
                    sp.setHinhAnh(rs.getString("hinhAnh"));
                    sp.setLoai(rs.getString("loai"));
                    return sp;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Tìm theo từ khóa
    public List<SanPham> timTheoTuKhoa(String tuKhoa) {
        List<SanPham> ds = new ArrayList<>();
        String sql = "SELECT id_sanpham, ten, moTa, gia, danhMuc, soLuong, hinhAnh, loai FROM sanpham WHERE ten LIKE ?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, "%" + tuKhoa + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId_sanpham(rs.getInt("id_sanpham"));
                    sp.setTen(rs.getString("ten"));
                    sp.setMoTa(rs.getString("moTa"));
                    sp.setGia(rs.getDouble("gia"));
                    sp.setDanhMuc(rs.getString("danhMuc"));
                    sp.setSoLuong(rs.getInt("soLuong"));
                    sp.setHinhAnh(rs.getString("hinhAnh"));
                    sp.setLoai(rs.getString("loai"));
                    ds.add(sp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

    // ✅ Lọc + sắp xếp
    public List<SanPham> locVaSapXep(String danhMuc, String sapXep) {
        List<SanPham> ds = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id_sanpham, ten, moTa, gia, danhMuc, soLuong, hinhAnh, loai FROM sanpham WHERE 1=1");

        if (danhMuc != null && !danhMuc.isEmpty()) {
            sql.append(" AND danhMuc = ?");
        }

        if ("tang".equals(sapXep)) {
            sql.append(" ORDER BY gia ASC");
        } else if ("giam".equals(sapXep)) {
            sql.append(" ORDER BY gia DESC");
        }

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (danhMuc != null && !danhMuc.isEmpty()) {
                ps.setString(idx++, danhMuc);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setId_sanpham(rs.getInt("id_sanpham"));
                sp.setTen(rs.getString("ten"));
                sp.setMoTa(rs.getString("moTa"));
                sp.setGia(rs.getDouble("gia"));
                sp.setDanhMuc(rs.getString("danhMuc"));
                sp.setSoLuong(rs.getInt("soLuong"));
                sp.setHinhAnh(rs.getString("hinhAnh"));
                sp.setLoai(rs.getString("loai"));
                ds.add(sp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

    // ✅ Tìm kiếm nâng cao
    public List<SanPham> timKiemSanPham(String tuKhoa, String danhMuc, String sapXep) {
        List<SanPham> ds = new ArrayList<>();
        try {
            Connection cn = DBUtil.getConnection();
            String sql = "SELECT * FROM sanpham WHERE 1=1";
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) sql += " AND ten LIKE ?";
            if (danhMuc != null && !danhMuc.trim().isEmpty()) sql += " AND danhMuc = ?";

            if ("tang".equals(sapXep)) sql += " ORDER BY gia ASC";
            else if ("giam".equals(sapXep)) sql += " ORDER BY gia DESC";
            else if ("az".equals(sapXep)) sql += " ORDER BY ten ASC";
            else if ("za".equals(sapXep)) sql += " ORDER BY ten DESC";

            PreparedStatement ps = cn.prepareStatement(sql);
            int idx = 1;
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) ps.setString(idx++, "%" + tuKhoa + "%");
            if (danhMuc != null && !danhMuc.trim().isEmpty()) ps.setString(idx++, danhMuc);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setId_sanpham(rs.getInt("id_sanpham"));
                sp.setTen(rs.getString("ten"));
                sp.setGia(rs.getDouble("gia"));
                sp.setMoTa(rs.getString("moTa"));
                sp.setDanhMuc(rs.getString("danhMuc"));
                sp.setHinhAnh(rs.getString("hinhAnh"));
                sp.setLoai(rs.getString("loai"));
                ds.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ds;
    }

    // ✅ Lọc + tìm + sắp xếp tổng hợp
    public List<SanPham> timLocSapXep(String tuKhoa, String danhMuc, String sapXep) {
        List<SanPham> ds = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT id_sanpham, ten, moTa, gia, danhMuc, soLuong, hinhAnh, loai FROM sanpham WHERE 1=1"
        );

        if (tuKhoa != null && !tuKhoa.trim().isEmpty()) sql.append(" AND ten LIKE ?");
        if (danhMuc != null && !danhMuc.trim().isEmpty()) sql.append(" AND danhMuc = ?");

        if ("tang".equalsIgnoreCase(sapXep)) sql.append(" ORDER BY gia ASC");
        else if ("giam".equalsIgnoreCase(sapXep)) sql.append(" ORDER BY gia DESC");
        else if ("az".equalsIgnoreCase(sapXep)) sql.append(" ORDER BY ten ASC");
        else if ("za".equalsIgnoreCase(sapXep)) sql.append(" ORDER BY ten DESC");
        else sql.append(" ORDER BY id_sanpham DESC");

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) ps.setString(idx++, "%" + tuKhoa.trim() + "%");
            if (danhMuc != null && !danhMuc.trim().isEmpty()) ps.setString(idx++, danhMuc.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId_sanpham(rs.getInt("id_sanpham"));
                    sp.setTen(rs.getString("ten"));
                    sp.setMoTa(rs.getString("moTa"));
                    sp.setGia(rs.getDouble("gia"));
                    sp.setDanhMuc(rs.getString("danhMuc"));
                    sp.setSoLuong(rs.getInt("soLuong"));
                    sp.setHinhAnh(rs.getString("hinhAnh"));
                    sp.setLoai(rs.getString("loai"));
                    ds.add(sp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

   
    // ✅ Lấy danh sách sản phẩm bán chạy
    public List<SanPham> laySanPhamBanChay() {
        return laySanPhamTheoLoai("banchay");
    }

    // ✅ Lấy danh sách sản phẩm khuyến mãi
    public List<SanPham> laySanPhamKhuyenMai() {
        return laySanPhamTheoLoai("khuyenmai");
    }

    // ✅ Hàm dùng chung để lấy sản phẩm theo loại
    public List<SanPham> laySanPhamTheoLoai(String loai) {
        List<SanPham> ds = new ArrayList<>();
        String sql = "SELECT * FROM sanpham WHERE loai = ?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, loai);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham sp = new SanPham();
                    sp.setId_sanpham(rs.getInt("id_sanpham"));
                    sp.setTen(rs.getString("ten"));
                    sp.setMoTa(rs.getString("moTa"));
                    sp.setGia(rs.getDouble("gia"));
                    sp.setDanhMuc(rs.getString("danhMuc"));
                    sp.setSoLuong(rs.getInt("soLuong"));
                    sp.setHinhAnh(rs.getString("hinhAnh"));
                    sp.setLoai(rs.getString("loai"));
                    ds.add(sp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }
}
