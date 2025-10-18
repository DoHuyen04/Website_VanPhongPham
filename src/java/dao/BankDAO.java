/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.BankAccount;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BankDAO {

    // Lấy id người dùng từ tên đăng nhập
    private Integer getUserIdByUsername(Connection cn, String tenDangNhap) throws SQLException {
        String sql = "SELECT id FROM nguoidung WHERE tendangnhap=?";
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    public List<BankAccount> listByUsername(String tenDangNhap) {
        List<BankAccount> list = new ArrayList<>();
        String sql = """
            SELECT b.* FROM taikhoannganhang b
            JOIN nguoidung u ON u.id=b.user_id
            WHERE u.tendangnhap=? ORDER BY b.macdinh DESC, b.id DESC
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BankAccount b = new BankAccount();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setTenNganHang(rs.getString("tennganhang"));
                    b.setSoTaiKhoan(rs.getString("sotaikhoan"));
                    b.setChuTaiKhoan(rs.getString("chutaikhoan"));
                    b.setChiNhanh(rs.getString("chinhanh"));
                    b.setMacDinh(rs.getInt("macdinh")==1);
                    b.setTrangThai(rs.getString("trangthai"));
                    list.add(b);
                }
            }
        } catch (SQLException e){ e.printStackTrace(); }
        return list;
    }

    public boolean addForUsername(String tenDangNhap, BankAccount b) {
        String resetDefault = "UPDATE taikhoannganhang SET macdinh=0 WHERE user_id=?";
        String sql = """
            INSERT INTO taikhoannganhang(user_id,tennganhang,sotaikhoan,chutaikhoan,chinhanh,macdinh,trangthai)
            VALUES (?,?,?,?,?, ?, 'approved')
        """;
        try (Connection cn = DBUtil.getConnection()) {
            Integer uid = getUserIdByUsername(cn, tenDangNhap);
            if (uid == null) return false;
            // Nếu thêm mới là mặc định
            if (b.isMacDinh()) {
                try (PreparedStatement p0 = cn.prepareStatement(resetDefault)) {
                    p0.setInt(1, uid); p0.executeUpdate();
                }
            }
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setInt(1, uid);
                ps.setString(2, b.getTenNganHang());
                ps.setString(3, b.getSoTaiKhoan());
                ps.setString(4, b.getChuTaiKhoan());
                ps.setString(5, b.getChiNhanh());
                ps.setInt(6, b.isMacDinh()?1:0);
                return ps.executeUpdate()==1;
            }
        } catch (SQLException e){ e.printStackTrace(); }
        return false;
    }

    public boolean delete(String tenDangNhap, int id) {
        String sql = """
            DELETE b FROM taikhoannganhang b
            JOIN nguoidung u ON u.id=b.user_id
            WHERE u.tendangnhap=? AND b.id=?
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            ps.setInt(2, id);
            return ps.executeUpdate()==1;
        } catch (SQLException e){ e.printStackTrace(); }
        return false;
    }

    public boolean setDefault(String tenDangNhap, int id) {
        try (Connection cn = DBUtil.getConnection()) {
            Integer uid = getUserIdByUsername(cn, tenDangNhap);
            if (uid == null) return false;
            try (PreparedStatement p1 = cn.prepareStatement("UPDATE taikhoannganhang SET macdinh=0 WHERE user_id=?")) {
                p1.setInt(1, uid); p1.executeUpdate();
            }
            try (PreparedStatement p2 = cn.prepareStatement("UPDATE taikhoannganhang SET macdinh=1 WHERE id=? AND user_id=?")) {
                p2.setInt(1, id); p2.setInt(2, uid);
                return p2.executeUpdate()==1;
            }
        } catch (SQLException e){ e.printStackTrace(); }
        return false;
    }
}

