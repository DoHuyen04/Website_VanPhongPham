package dao;

import model.TKNganHang;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TKNganHangDAO {

    // Lấy id người dùng theo tên đăng nhập (bảng nguoidung có cột id và tendangnhap)
    private Integer getIdNguoiDungByTenDangNhap(Connection cn, String tenDangNhap) throws SQLException {
        String sql = "SELECT id_nguoidung FROM nguoidung WHERE tendangnhap=?";
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return null;
    }

    // Map 1 dòng ResultSet -> đối tượng TKNganHang (khớp tên thuộc tính của model)
    private TKNganHang map(ResultSet rs) throws SQLException {
        TKNganHang tk = new TKNganHang();
        tk.setIdTkNganHang(rs.getInt("id_TkNganHang"));
        tk.setIdNguoiDung(rs.getInt("id_nguoidung"));
        tk.setTenNganHang(rs.getString("tenNganHang"));
        tk.setSoTaiKhoan(rs.getString("soTaiKhoan"));
        tk.setChuTaiKhoan(rs.getString("chuTaiKhoan"));
        tk.setChiNhanh(rs.getString("chiNhanh"));
        tk.setMacDinh(rs.getBoolean("macDinh"));
        tk.setTrangThai(rs.getString("trangThai"));
        return tk;
    }

    // Danh sách theo userId (ưu tiên dùng trong Servlet)
    public List<TKNganHang> listByUserId(int userId) {
        String sql = """
  SELECT id_TkNganHang, id_nguoidung, tenNganHang, soTaiKhoan,
         chuTaiKhoan, chiNhanh, macDinh, trangThai
  FROM TKNganHang
  WHERE id_nguoidung = ?
  ORDER BY macDinh DESC, id_TkNganHang DESC
""";
        List<TKNganHang> list = new ArrayList<>();
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Danh sách theo tên đăng nhập (nếu bạn muốn gọi ở nơi khác)
    public List<TKNganHang> layDanhSachTheoTenDangNhap(String tenDangNhap) {
        List<TKNganHang> list = new ArrayList<>();
        String sql = """
  SELECT t.id_TkNganHang, t.id_nguoidung, t.tenNganHang, t.soTaiKhoan,
         t.chuTaiKhoan, t.chiNhanh, t.macDinh, t.trangThai
  FROM TKNganHang t
  JOIN nguoidung u ON u.id_nguoidung = t.id_nguoidung
  WHERE u.tenDangNhap=?
  ORDER BY t.macDinh DESC, t.id_TkNganHang DESC
""";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm theo userId (dùng trong Servlet khi đã có session userId)
    public boolean themTaiKhoanByUserId(int userId, TKNganHang tk) {
        String resetDefault = "UPDATE TKNganHang SET macDinh=0 WHERE id_nguoidung=?";
        String sql = """
  INSERT INTO TKNganHang
  (id_nguoidung, tenNganHang, soTaiKhoan, chuTaiKhoan, chiNhanh, macDinh, trangThai)
  VALUES (?,?,?,?,?,?,?)
""";

        try (Connection cn = DBUtil.getConnection()) {

            if (tk.isMacDinh()) {
                try (PreparedStatement ps0 = cn.prepareStatement(resetDefault)) {
                    ps0.setInt(1, userId);
                    ps0.executeUpdate();
                }
            }

            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, tk.getTenNganHang());
                ps.setString(3, tk.getSoTaiKhoan());
                ps.setString(4, tk.getChuTaiKhoan());
                ps.setString(5, tk.getChiNhanh());
                ps.setBoolean(6, tk.isMacDinh());
                ps.setString(7, tk.getTrangThai()); // ví dụ: "daduyet" / "choduyet"
                return ps.executeUpdate() == 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm theo tên đăng nhập (nếu cần)
    public boolean themTaiKhoan(String tenDangNhap, TKNganHang tk) {
        String resetDefault = "UPDATE TKNganHang SET macDinh=0 WHERE id_nguoidung=?";
        String sql = """
  INSERT INTO TKNganHang
  (id_nguoidung, tenNganHang, soTaiKhoan, chuTaiKhoan, chiNhanh, macDinh, trangThai)
  VALUES (?,?,?,?,?,?,?)
""";

        try (Connection cn = DBUtil.getConnection()) {
            Integer uid = getIdNguoiDungByTenDangNhap(cn, tenDangNhap);
            if (uid == null) {
                return false;
            }

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
                ps.setString(7, tk.getTrangThai());
                return ps.executeUpdate() == 1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoá theo userId
    public boolean xoaTaiKhoan(int idNguoiDung, int idTkNganHang) {
        String sql = "DELETE FROM TKNganHang WHERE id_nguoidung=? AND id_TkNganHang=?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idNguoiDung);
            ps.setInt(2, idTkNganHang);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoá theo tên đăng nhập
    public boolean xoaTaiKhoan(String tenDangNhap, int idTkNganHang) {
        String sql = """
  DELETE t FROM TKNganHang t
  JOIN nguoidung u ON u.id_nguoidung = t.id_nguoidung
  WHERE u.tenDangNhap=? AND t.id_TkNganHang=?
""";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            ps.setInt(2, idTkNganHang);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đặt mặc định theo userId
    public boolean datMacDinh(int idNguoiDung, int idTkNganHang) {
        try (Connection cn = DBUtil.getConnection()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps1 = cn.prepareStatement(
                    "UPDATE TKNganHang SET macDinh=0 WHERE id_nguoidung=?"); PreparedStatement ps2 = cn.prepareStatement(
                            "UPDATE TKNganHang SET macDinh=1 WHERE id_TkNganHang=? AND id_nguoidung=?")) {
                ps1.setInt(1, idNguoiDung);
                ps1.executeUpdate();

                ps2.setInt(1, idTkNganHang);
                ps2.setInt(2, idNguoiDung);
                boolean ok = ps2.executeUpdate() == 1;

                cn.commit();
                return ok;
            } catch (SQLException ex) {
                cn.rollback();
                throw ex;
            } finally {
                cn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đặt mặc định theo tên đăng nhập
    public boolean datMacDinh(String tenDangNhap, int idTkNganHang) {
        try (Connection cn = DBUtil.getConnection()) {
            Integer uid = getIdNguoiDungByTenDangNhap(cn, tenDangNhap);
            if (uid == null) {
                return false;
            }
            return datMacDinh(uid, idTkNganHang);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}