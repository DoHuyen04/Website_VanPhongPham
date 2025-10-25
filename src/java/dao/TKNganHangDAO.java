package dao;

import model.TKNganHang;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TKNganHangDAO {

    // 🔹 Lấy id người dùng theo tên đăng nhập
    private Integer getIdNguoiDungByTenDangNhap(Connection cn, String tenDangNhap) throws SQLException {
        String sql = "SELECT id FROM nguoidung WHERE tendangnhap=?";
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    // 🔹 Lấy danh sách tài khoản ngân hàng của người dùng
    public List<TKNganHang> layDanhSachTheoTenDangNhap(String tenDangNhap) {
        List<TKNganHang> list = new ArrayList<>();
        String sql = """
            SELECT t.* FROM tknganhang t
            JOIN nguoidung u ON u.id = t.id_nguoidung
            WHERE u.tendangnhap=?
            ORDER BY t.macdinh DESC, t.id_tknganhang DESC
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TKNganHang tk = new TKNganHang();
                    tk.setIdTkNganHang(rs.getInt("id_tknganhang"));
                    tk.setIdNguoiDung(rs.getInt("id_nguoidung"));
                    tk.setTenNganHang(rs.getString("tennganhang"));
                    tk.setSoTaiKhoan(rs.getString("sotaikhoan"));
                    tk.setChuTaiKhoan(rs.getString("chutaikhoan"));
                    tk.setChiNhanh(rs.getString("chinhanh"));
                    tk.setMacDinh(rs.getBoolean("macdinh"));
                    tk.setTrangThai(rs.getString("trangthai"));
                    list.add(tk);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Thêm tài khoản ngân hàng cho người dùng
    public boolean themTaiKhoanTheoTenDangNhap(String tenDangNhap, TKNganHang tk) {
        String resetDefault = "UPDATE tknganhang SET macdinh=0 WHERE id_nguoidung=?";
        String sql = """
            INSERT INTO tknganhang(id_nguoidung, tennganhang, sotaikhoan, chutaikhoan, chinhanh, macdinh, trangthai)
            VALUES (?, ?, ?, ?, ?, ?, 'approved')
        """;
        try (Connection cn = DBUtil.getConnection()) {
            Integer uid = getIdNguoiDungByTenDangNhap(cn, tenDangNhap);
            if (uid == null) return false;

            // Nếu thêm mới là tài khoản mặc định thì reset các tài khoản khác
            if (tk.isMacDinh()) {
                try (PreparedStatement ps0 = cn.prepareStatement(resetDefault)) {
                    ps0.setInt(1, uid);
                    ps0.executeUpdate();
                }
            }

            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setInt(1, uid);
                ps.setString(2, tk.getTenNganHang());
                ps.setString(3, tk.getSoTaiKhoan());
                ps.setString(4, tk.getChuTaiKhoan());
                ps.setString(5, tk.getChiNhanh());
                ps.setBoolean(6, tk.isMacDinh());
                return ps.executeUpdate() == 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Xóa tài khoản ngân hàng
    public boolean xoaTaiKhoan(String tenDangNhap, int idTkNganHang) {
        String sql = """
            DELETE t FROM tknganhang t
            JOIN nguoidung u ON u.id = t.id_nguoidung
            WHERE u.tendangnhap=? AND t.id_tknganhang=?
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            ps.setInt(2, idTkNganHang);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Đặt tài khoản làm mặc định
    public boolean datMacDinh(String tenDangNhap, int idTkNganHang) {
        try (Connection cn = DBUtil.getConnection()) {
            Integer uid = getIdNguoiDungByTenDangNhap(cn, tenDangNhap);
            if (uid == null) return false;

            // Hủy mặc định các tài khoản khác
            try (PreparedStatement ps1 = cn.prepareStatement("UPDATE tknganhang SET macdinh=0 WHERE id_nguoidung=?")) {
                ps1.setInt(1, uid);
                ps1.executeUpdate();
            }

            // Đặt tài khoản được chọn là mặc định
            try (PreparedStatement ps2 = cn.prepareStatement("UPDATE tknganhang SET macdinh=1 WHERE id_tknganhang=? AND id_nguoidung=?")) {
                ps2.setInt(1, idTkNganHang);
                ps2.setInt(2, uid);
                return ps2.executeUpdate() == 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
