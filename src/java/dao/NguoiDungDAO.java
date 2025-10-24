 package dao;

import model.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NguoiDungDAO {

    // ✅ Hàm kiểm tra trùng tài khoản/email/sđt
    public boolean isExist(String username, String email, String sdt) {
        String sql = "SELECT * FROM nguoidung WHERE tendangnhap = ? OR email = ? OR sodienthoai = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, sdt);

            ResultSet rs = ps.executeQuery();
            return rs.next(); // nếu có dữ liệu => trùng

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Đăng ký người dùng mới
    public boolean dangKy(NguoiDung nd) {
    String sql = "INSERT INTO nguoidung (tenDangNhap, matKhau, hoTen, email, soDienThoai, trangThai) VALUES (?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, nd.getTenDangNhap());
        ps.setString(2, nd.getMatKhau());
        ps.setString(3, nd.getHoTen());
        ps.setString(4, nd.getEmail());
        ps.setString(5, nd.getSoDienThoai());
        ps.setBoolean(6, true);

        int rows = ps.executeUpdate();
        System.out.println(">>> Số dòng thêm vào bảng nguoidung: " + rows);
        return rows > 0;

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
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