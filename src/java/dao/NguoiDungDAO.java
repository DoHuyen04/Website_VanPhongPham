package dao;

import model.NguoiDung;
import java.sql.*;

public class NguoiDungDAO {

    // ======================= KIỂM TRA TRÙNG =======================
    public boolean isExist(String username, String email, String sdt) {
        String sql = """
            SELECT COUNT(*)
            FROM nguoidung
            WHERE tendangnhap = ? OR email = ? OR sodienthoai = ?
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, sdt);

            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
    }

    // ======================= INSERT CHƯA KÍCH HOẠT =======================
    public int themNguoiDungChuaKichHoat(NguoiDung nd) {
        String sql = """
            INSERT INTO nguoidung
            (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh, trangthai)
            VALUES (?, ?, ?, ?, ?, ?, ?, 0)
        """;

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau());
            ps.setString(3, nd.getHoTen());
            ps.setString(4, nd.getEmail());
            ps.setString(5, nd.getSoDienThoai());
            ps.setString(6, nd.getGioiTinh());

            // 🔥 NGÀY SINH LÀ STRING → CHUYỂN THÀNH SQL DATE
            if (nd.getNgaySinh() != null && !nd.getNgaySinh().isEmpty()) {
                ps.setDate(7, Date.valueOf(nd.getNgaySinh()));   // yyyy-MM-dd
            } else {
                ps.setNull(7, Types.DATE);
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ======================= KÍCH HOẠT =======================
    public boolean kichHoatTaiKhoan(int id) {
        String sql = "UPDATE nguoidung SET trangthai = 1 WHERE id_nguoidung = ?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================= KIỂM TRA TỒN TẠI =======================
    public boolean kiemTraTonTai(String tenDangNhap, String email) {
        String sql = "SELECT COUNT(*) FROM nguoidung WHERE tendangnhap=? OR email=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, tenDangNhap);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();

            return rs.next() && rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================= ĐĂNG KÝ =======================
    public boolean dangKy(NguoiDung nd) {
        String sql = """
            INSERT INTO nguoidung
            (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh, trangthai)
            VALUES (?, ?, ?, ?, ?, ?, ?, 1)
        """;

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau());
            ps.setString(3, nd.getHoTen());
            ps.setString(4, nd.getEmail());
            ps.setString(5, nd.getSoDienThoai());
            ps.setString(6, nd.getGioiTinh());

            if (nd.getNgaySinh() != null && !nd.getNgaySinh().isEmpty()) {
                ps.setDate(7, Date.valueOf(nd.getNgaySinh()));  // yyyy-MM-dd
            } else {
                ps.setNull(7, Types.DATE);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ======================= LẤY THEO USERNAME =======================
    public NguoiDung layTheoTenDangNhap(String tenDangNhap) {
        String sql = "SELECT * FROM nguoidung WHERE tendangnhap=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, tenDangNhap);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapNguoiDung(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================= LẤY THEO ID =======================
    public NguoiDung layTheoIdDayDu(int id) {
        String sql = "SELECT * FROM nguoidung WHERE id_nguoidung=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapNguoiDung(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================= MAP DỮ LIỆU TỪ DB =======================
    private NguoiDung mapNguoiDung(ResultSet rs) throws SQLException {
        NguoiDung nd = new NguoiDung();

        nd.setId(rs.getInt("id_nguoidung"));
        nd.setTenDangNhap(rs.getString("tendangnhap"));
        nd.setHoTen(rs.getString("hoten"));
        nd.setEmail(rs.getString("email"));
        nd.setSoDienThoai(rs.getString("sodienthoai"));
        nd.setGioiTinh(rs.getString("gioitinh"));

        // ⏳ NGÀY SINH TRONG DB → STRING
        Date d = rs.getDate("ngaysinh");
        nd.setNgaySinh(d != null ? d.toString() : null);   // yyyy-MM-dd

        nd.setAvatarUrl(rs.getString("avatarurl"));

        return nd;
    }

    // ======================= UPDATE THÔNG TIN =======================
    public boolean capNhatThongTin(NguoiDung nd) {
        String sql = """
            UPDATE nguoidung
            SET hoten=?, email=?, sodienthoai=?, gioitinh=?, ngaysinh=?
            WHERE id_nguoidung=?
        """;

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nd.getHoTen());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getSoDienThoai());
            ps.setString(4, nd.getGioiTinh());

            if (nd.getNgaySinh() != null && !nd.getNgaySinh().isEmpty()) {
                ps.setDate(5, Date.valueOf(nd.getNgaySinh()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setInt(6, nd.getId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================= UPDATE PASSWORD =======================
    public boolean updatePassword(int id, String hashedPw) {
        String sql = "UPDATE nguoidung SET matkhau=? WHERE id_nguoidung=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, hashedPw);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatar(int userId, String url) {
        String sql = "UPDATE nguoidung SET avatarurl=? WHERE id_nguoidung=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, url);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
