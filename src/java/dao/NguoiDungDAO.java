package dao;

import model.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NguoiDungDAO {

    // ✅ Đăng ký người dùng mới
    public boolean dangKy(NguoiDung nd) {
        String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai) VALUES (?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau()); // Lưu ý: thực tế nên mã hóa mật khẩu
            ps.setString(3, nd.getHoTen());
            ps.setString(4, nd.getEmail());
            ps.setString(5, nd.getSoDienThoai());

            int kq = ps.executeUpdate();
            return kq > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Đăng nhập
    public NguoiDung dangNhap(String tenDangNhap, String matKhau) {
        String sql = "SELECT id, tendangnhap, hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=? AND matkhau=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id"));
                    nd.setTenDangNhap(rs.getString("tendangnhap"));
                    nd.setHoTen(rs.getString("hoten"));
                    nd.setEmail(rs.getString("email"));
                    nd.setSoDienThoai(rs.getString("sodienthoai"));
                    return nd;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
