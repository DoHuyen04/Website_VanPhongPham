package dao;

import model.DanhGia;
import java.sql.*;
import java.util.*;

public class DanhGiaDAO {

    // Thêm đánh giá mới
    public boolean themDanhGia(DanhGia dg) {
        String sql = "INSERT INTO danhgia (id_nguoidung, id_sanpham, sao, binhluan) VALUES (?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, dg.getIdNguoiDung());
            ps.setInt(2, dg.getIdSanPham());
            ps.setInt(3, dg.getSao());
            ps.setString(4, dg.getBinhLuan());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách đánh giá theo sản phẩm
    public List<DanhGia> layDanhGiaTheoSanPham(int idSanPham) {
        List<DanhGia> ds = new ArrayList<>();
        String sql = "SELECT id_danhgia, id_nguoidung, id_sanpham, sao, binhluan, ngay " +
                     "FROM danhgia WHERE id_sanpham=? ORDER BY ngay DESC";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idSanPham);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DanhGia dg = new DanhGia();
                    dg.setIdDanhGia(rs.getInt("id_danhgia"));
                    dg.setIdNguoiDung(rs.getInt("id_nguoidung"));
                    dg.setIdSanPham(rs.getInt("id_sanpham"));
                    dg.setSao(rs.getInt("sao"));
                    dg.setBinhLuan(rs.getString("binhluan"));
                    dg.setNgay(rs.getTimestamp("ngay"));
                    ds.add(dg);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }
}
