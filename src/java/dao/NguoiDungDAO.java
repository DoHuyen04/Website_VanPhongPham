 package dao;

import static dao.DBUtil.getConnection;
import model.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;

public class NguoiDungDAO {

<<<<<<< HEAD
<<<<<<< HEAD
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
=======
    // ✅ Đăng ký người dùng mới
   public boolean dangKy(NguoiDung nd) {
        String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh) VALUES (?,?,?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
=======
    // Đăng ký người dùng mới
    public boolean dangKy(NguoiDung nd) {
        String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh) VALUES (?,?,?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
>>>>>>> origin/iamaine

            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau());
            ps.setString(3, nd.getHoTen());
            ps.setString(4, nd.getEmail());
            ps.setString(5, nd.getSoDienThoai());
            ps.setString(6, nd.getGioiTinh());

            LocalDate ns = nd.getNgaySinh();
            if (ns != null) {
                ps.setDate(7, Date.valueOf(ns));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }
<<<<<<< HEAD
>>>>>>> origin/huyenpea
=======
>>>>>>> origin/iamaine

            return ps.executeUpdate() > 0;
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
<<<<<<< HEAD
=======
public boolean kiemTraTonTai(String tenDangNhap, String email) {
    String sql = "SELECT COUNT(*) FROM nguoidung WHERE tendangnhap = ? OR email = ?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, tenDangNhap);
        ps.setString(2, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
>>>>>>> origin/huyenpea
}


    public boolean kiemTraTonTai(String tenDangNhap, String email) {
        String sql = "SELECT COUNT(*) FROM nguoidung WHERE tendangnhap = ? OR email = ?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đăng nhập
    public NguoiDung dangNhap(String tenDangNhap, String matKhau) {
<<<<<<< HEAD
        String sql = "SELECT id_nguoidung, tendangnhap, hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=? AND matkhau=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
=======
        String sql = "SELECT id_nguoidung, tendangnhap, hoten, email, sodienthoai, avatarurl FROM nguoidung WHERE tendangnhap=? AND matkhau=?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
>>>>>>> origin/iamaine

            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id_nguoidung"));
                    nd.setTenDangNhap(rs.getString("tendangnhap"));
                    nd.setHoTen(rs.getString("hoten"));
                    nd.setEmail(rs.getString("email"));
                    nd.setSoDienThoai(rs.getString("sodienthoai"));
                    nd.setAvatarUrl(rs.getString("avatarurl"));
                    return nd;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
<<<<<<< HEAD
<<<<<<< HEAD
}
=======
    // >>> THÊM VÀO NguoiDungDAO.java
public NguoiDung layTheoTenDangNhap(String tenDangNhap) {
    String sql = "SELECT id_nguoidung, tendangnhap, hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, tenDangNhap);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id_nguoidung"));
                nd.setTenDangNhap(rs.getString("tendangnhap"));
                nd.setHoTen(rs.getString("hoten"));
                nd.setEmail(rs.getString("email"));
                nd.setSoDienThoai(rs.getString("sodienthoai"));
                return nd;
=======

    public NguoiDung layTheoIdDayDu(int id) {
        String sql = "SELECT id_nguoidung, tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh, "
                + "avatar_url AS avatarUrl "
                + // ✨ alias về avatarUrl
                "FROM nguoidung WHERE id_nguoidung = ?";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id_nguoidung"));
                    nd.setTenDangNhap(rs.getString("tendangnhap"));
                    nd.setMatKhau(rs.getString("matkhau"));
                    nd.setHoTen(rs.getString("hoten"));
                    nd.setEmail(rs.getString("email"));
                    nd.setSoDienThoai(rs.getString("sodienthoai"));
                    nd.setGioiTinh(rs.getString("gioitinh"));
                    nd.setAvatarUrl(rs.getString("avatarUrl"));          // ✨ lấy theo alias
                    Date d = rs.getDate("ngaysinh");
                    nd.setNgaySinh(d != null ? d.toLocalDate() : null);
                    return nd;
                }
>>>>>>> origin/iamaine
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

<<<<<<< HEAD
public boolean capNhatThongTinCoBan(NguoiDung nd) {
    String sql = "UPDATE nguoidung SET hoten=?, email=?, sodienthoai=? WHERE tendangnhap=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, nd.getHoTen());
        ps.setString(2, nd.getEmail());
        ps.setString(3, nd.getSoDienThoai());
        ps.setString(4, nd.getTenDangNhap());
        return ps.executeUpdate() == 1;
    } catch (SQLException e) { e.printStackTrace(); }
    return false;
}
// ====== THÊM MỚI: LẤY USER ĐẦY ĐỦ THEO ID ======
public NguoiDung layTheoIdDayDu(int id) {
    String sql = "SELECT id_nguoidung, tendangnhap, hoten, email, sodienthoai, gioitinh, ngaysinh " +
                 "FROM nguoidung WHERE id_nguoidung=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id_nguoidung"));
                nd.setTenDangNhap(rs.getString("tendangnhap"));
                nd.setHoTen(rs.getString("hoten"));
                nd.setEmail(rs.getString("email"));
                nd.setSoDienThoai(rs.getString("sodienthoai"));

                // --- cột mới ---
                nd.setGioiTinh(rs.getString("gioitinh"));
                Date d = rs.getDate("ngaysinh");
                nd.setNgaySinh(d != null ? d.toLocalDate() : null);

                return nd;
=======
    public NguoiDung layTheoTenDangNhap(String ten) {
        String sql = "SELECT id_nguoidung FROM nguoidung WHERE tendangnhap = ?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, ten);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return layTheoIdDayDu(rs.getInt(1));
                }
>>>>>>> origin/iamaine
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

<<<<<<< HEAD
// ====== THÊM MỚI: LẤY USER ĐẦY ĐỦ THEO TÊN ĐĂNG NHẬP (nếu bạn muốn dùng username) ======
public NguoiDung layDayDuTheoTenDangNhap(String tenDangNhap) {
    String sql = "SELECT id_nguoidung, tendangnhap, hoten, email, sodienthoai, gioitinh, ngaysinh " +
                 "FROM nguoidung WHERE tendangnhap=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setString(1, tenDangNhap);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id_nguoidung"));
                nd.setTenDangNhap(rs.getString("tendangnhap"));
                nd.setHoTen(rs.getString("hoten"));
                nd.setEmail(rs.getString("email"));
                nd.setSoDienThoai(rs.getString("sodienthoai"));
                nd.setGioiTinh(rs.getString("gioitinh"));
                Date d = rs.getDate("ngaysinh");
                nd.setNgaySinh(d != null ? d.toLocalDate() : null);
                return nd;
=======
    public boolean capNhatThongTin(NguoiDung nd) {
        final String sql
                = "UPDATE nguoidung "
                + "   SET hoTen = ?, "
                + "       email = ?, "
                + "       soDienThoai = ?, "
                + "       gioiTinh = ?, "
                + "       ngaySinh = ? "
                + " WHERE id_nguoidung = ?";

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nd.getHoTen());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getSoDienThoai());
            ps.setString(4, nd.getGioiTinh());

            if (nd.getNgaySinh() != null) {
                ps.setDate(5, java.sql.Date.valueOf(nd.getNgaySinh()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
>>>>>>> origin/iamaine
            }

            ps.setInt(6, nd.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

<<<<<<< HEAD
// ====== THÊM MỚI: CẬP NHẬT HỒ SƠ (không đụng email/mật khẩu) ======
public boolean capNhatHoSo(NguoiDung nd) {
    String sql = "UPDATE nguoidung SET hoten=?, sodienthoai=?, gioitinh=?, ngaysinh=? WHERE id_nguoidung=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
=======
    public boolean themNguoiDung(NguoiDung nd) {
        String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau());
            ps.setString(3, nd.getHoTen());
            ps.setString(4, nd.getEmail());
            ps.setString(5, nd.getSoDienThoai());
            ps.setString(6, nd.getGioiTinh());
            LocalDate ns = nd.getNgaySinh();
            if (ns != null) {
                ps.setDate(7, Date.valueOf(ns));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }
>>>>>>> origin/iamaine

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

<<<<<<< HEAD
        ps.setInt(5, nd.getId());
        return ps.executeUpdate() == 1;

    } catch (SQLException e) { e.printStackTrace(); }
    return false;
}

// ====== (TÙY CHỌN) THÊM MỚI: CHỈ CẬP NHẬT GIỚI TÍNH & NGÀY SINH ======
public boolean capNhatGioiTinhNgaySinh(int userId, String gioiTinh, LocalDate ngaySinh) {
    String sql = "UPDATE nguoidung SET gioitinh=?, ngaysinh=? WHERE id_nguoidung=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setString(1, gioiTinh);
        if (ngaySinh != null) {
            ps.setDate(2, Date.valueOf(ngaySinh));
        } else {
            ps.setNull(2, java.sql.Types.DATE);
        }
        ps.setInt(3, userId);
        return ps.executeUpdate() == 1;

    } catch (SQLException e) { e.printStackTrace(); }
    return false;
}

public boolean themNguoiDung(NguoiDung nd) {
    String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql))  {
        ps.setString(1, nd.getTenDangNhap());
        ps.setString(2, nd.getMatKhau());
        ps.setString(3, nd.getHoTen());
        ps.setString(4, nd.getEmail());
        ps.setString(5, nd.getSoDienThoai());
        ps.setString(6, nd.getGioiTinh());
         LocalDate ns = nd.getNgaySinh();
            if (ns != null) {
                ps.setDate(7, Date.valueOf(ns));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }

        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
=======
    public boolean updateAvatar(String tenDangNhap, String avatarUrl) {
        String sql = "UPDATE nguoidung SET avatar_url = ? WHERE tendangnhap = ?";  // ✨ avatar_url
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setString(2, tenDangNhap);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
>>>>>>> origin/iamaine

    public void updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE nguoidung SET avatar_url = ? WHERE id_nguoidung = ?"; // ✨ avatar_url
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật avatar: " + e.getMessage());
        }
    }

    public boolean updatePassword(int userId, String hashed) {
        final String sql = "UPDATE nguoidung SET matKhau=? WHERE id_nguoidung=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, hashed);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePasswordByUsername(String username, String hashed) {
        final String sql = "UPDATE nguoidung SET matKhau=? WHERE tenDangNhap=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, hashed);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
>>>>>>> origin/huyenpea
