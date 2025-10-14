package dao;

import model.NguoiDung;
import java.sql.*;

public class NguoiDungDAO {

    public boolean dangKy(NguoiDung nd) {
        String sql = "INSERT INTO nguoi_dung(ten_dang_nhap, mat_khau, ho_ten, email, so_dien_thoai) VALUES (?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau()); // NOTE: production -> hash password
            ps.setString(3, nd.getHoTen());
            ps.setString(4, nd.getEmail());
            ps.setString(5, nd.getSoDienThoai());
            int kq = ps.executeUpdate();
            return kq > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public NguoiDung dangNhap(String tenDangNhap, String matKhau) {
        String sql = "SELECT id, ten_dang_nhap, ho_ten, email, so_dien_thoai FROM nguoi_dung WHERE ten_dang_nhap=? AND mat_khau=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id"));
                    nd.setTenDangNhap(rs.getString("ten_dang_nhap"));
                    nd.setHoTen(rs.getString("ho_ten"));
                    nd.setEmail(rs.getString("email"));
                    nd.setSoDienThoai(rs.getString("so_dien_thoai"));
                    return nd;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
