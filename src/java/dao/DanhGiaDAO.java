package dao;

import model.DanhGia;
import java.sql.*;
import java.util.*;
import java.util.Set;
import java.util.HashSet;

public class DanhGiaDAO {

    public boolean themDanhGia(DanhGia dg) {
        String sql = "INSERT INTO danhgia (id_nguoidung, id_sanpham, id_donhang, sao, binhluan, hinh_anh) "
                + "VALUES (?,?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, dg.getIdNguoiDung());
            ps.setInt(2, dg.getIdSanPham());
            ps.setInt(3, dg.getIdDonHang());
            ps.setInt(4, dg.getSao());
            ps.setString(5, dg.getBinhLuan());
            ps.setString(6, dg.getHinhAnh());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<DanhGia> layDanhGiaTheoSanPham(int idSanPham) {
        List<DanhGia> ds = new ArrayList<>();
        String sql = "SELECT * FROM danhgia WHERE id_sanpham=? ORDER BY ngay DESC";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idSanPham);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DanhGia dg = new DanhGia();
                    dg.setIdDanhGia(rs.getInt("id_danhgia"));
                    dg.setIdNguoiDung(rs.getInt("id_nguoidung"));
                    dg.setIdSanPham(rs.getInt("id_sanpham"));
                    dg.setIdDonHang(rs.getInt("id_donhang"));   // <--- MỚI
                    dg.setSao(rs.getInt("sao"));
                    dg.setBinhLuan(rs.getString("binhluan"));
                    dg.setNgay(rs.getTimestamp("ngay"));
                    dg.setHinhAnh(rs.getString("hinh_anh"));

                    ds.add(dg);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return ds;
    }

    public Map<Integer, Integer> laySanPhamDaDanhGiaTheoDonHang(int idNguoiDung) {
        Map<Integer, Integer> result = new HashMap<>();
        String sql = "SELECT id_donhang, id_sanpham "
                + "FROM danhgia WHERE id_nguoidung=? AND id_donhang IS NOT NULL "
                + "ORDER BY ngay DESC";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idNguoiDung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int idDon = rs.getInt("id_donhang");
                    int idSP = rs.getInt("id_sanpham");

                    if (!result.containsKey(idDon)) {
                        result.put(idDon, idSP);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    // Lấy danh sách id_sanpham mà 1 người dùng đã đánh giá
    public Set<Integer> laySanPhamDaDanhGiaTheoNguoiDung(int idNguoiDung) {
        Set<Integer> result = new HashSet<>();
        String sql = "SELECT DISTINCT id_sanpham FROM danhgia WHERE id_nguoidung=?";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(rs.getInt("id_sanpham"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

}
