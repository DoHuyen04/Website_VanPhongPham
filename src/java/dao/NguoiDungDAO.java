package dao;

import model.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;

public class NguoiDungDAO {

    // ✅ Đăng ký người dùng mới
    public boolean dangKy(NguoiDung nd) {
        String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh) VALUES (?,?,?,?,?,?,?)";
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

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    // ✅ Đăng nhập
    public NguoiDung dangNhap(String tenDangNhap, String matKhau) {
        String sql = "SELECT id_nguoidung, tendangnhap, hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=? AND matkhau=?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

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
                    return nd;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    // dao/NguoiDungDAO.java

    public NguoiDung layTheoIdDayDu(int id) {
        String sql = "SELECT id_nguoidung, tendangnhap, matkhau, hoten, email, sodienthoai, gioitinh, ngaysinh "
                + "FROM nguoidung WHERE id_nguoidung = ?";
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

                    Date d = rs.getDate("ngaysinh"); // java.sql.Date
                    nd.setNgaySinh(d != null ? d.toLocalDate() : null);

                    return nd;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public NguoiDung layTheoTenDangNhap(String ten) {
        String sql = "SELECT id_nguoidung FROM nguoidung WHERE tendangnhap = ?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, ten);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return layTheoIdDayDu(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


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
            }

            ps.setInt(6, nd.getId()); // map tới id_nguoidung

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
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

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatar(String tenDangNhap, String avatarUrl) {
        String sql = "UPDATE nguoidung SET avatar_url = ? WHERE tendangnhap = ?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setString(2, tenDangNhap);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
