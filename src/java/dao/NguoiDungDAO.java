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
        String sql = "INSERT INTO nguoidung (tendangnhap, matkhau, hoten, email, sodienthoai) VALUES (?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, nd.getTenDangNhap());
            ps.setString(2, nd.getMatKhau()); 
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
    // >>> THÊM VÀO NguoiDungDAO.java
public NguoiDung layTheoTenDangNhap(String tenDangNhap) {
    String sql = "SELECT id, tendangnhap, hoten, email, sodienthoai FROM nguoidung WHERE tendangnhap=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, tenDangNhap);
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
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}

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
    String sql = "SELECT id, tendangnhap, hoten, email, sodienthoai, gioitinh, ngaysinh " +
                 "FROM nguoidung WHERE id=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id"));
                nd.setTenDangNhap(rs.getString("tendangnhap"));
                nd.setHoTen(rs.getString("hoten"));
                nd.setEmail(rs.getString("email"));
                nd.setSoDienThoai(rs.getString("sodienthoai"));

                // --- cột mới ---
                nd.setGioiTinh(rs.getString("gioitinh"));
                Date d = rs.getDate("ngaysinh");
                nd.setNgaySinh(d != null ? d.toLocalDate() : null);

                return nd;
            }
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}

// ====== THÊM MỚI: LẤY USER ĐẦY ĐỦ THEO TÊN ĐĂNG NHẬP (nếu bạn muốn dùng username) ======
public NguoiDung layDayDuTheoTenDangNhap(String tenDangNhap) {
    String sql = "SELECT id, tendangnhap, hoten, email, sodienthoai, gioitinh, ngaysinh " +
                 "FROM nguoidung WHERE tendangnhap=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setString(1, tenDangNhap);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id"));
                nd.setTenDangNhap(rs.getString("tendangnhap"));
                nd.setHoTen(rs.getString("hoten"));
                nd.setEmail(rs.getString("email"));
                nd.setSoDienThoai(rs.getString("sodienthoai"));
                nd.setGioiTinh(rs.getString("gioitinh"));
                Date d = rs.getDate("ngaysinh");
                nd.setNgaySinh(d != null ? d.toLocalDate() : null);
                return nd;
            }
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}

// ====== THÊM MỚI: CẬP NHẬT HỒ SƠ (không đụng email/mật khẩu) ======
public boolean capNhatHoSo(NguoiDung nd) {
    String sql = "UPDATE nguoidung SET hoten=?, sodienthoai=?, gioitinh=?, ngaysinh=? WHERE id=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {

        ps.setString(1, nd.getHoTen());
        ps.setString(2, nd.getSoDienThoai());
        ps.setString(3, nd.getGioiTinh());

        LocalDate ns = nd.getNgaySinh();
        if (ns != null) {
            ps.setDate(4, Date.valueOf(ns));
        } else {
            ps.setNull(4, java.sql.Types.DATE);
        }

        ps.setInt(5, nd.getId());
        return ps.executeUpdate() == 1;

    } catch (SQLException e) { e.printStackTrace(); }
    return false;
}

// ====== (TÙY CHỌN) THÊM MỚI: CHỈ CẬP NHẬT GIỚI TÍNH & NGÀY SINH ======
public boolean capNhatGioiTinhNgaySinh(int userId, String gioiTinh, LocalDate ngaySinh) {
    String sql = "UPDATE nguoidung SET gioitinh=?, ngaysinh=? WHERE id=?";
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


}
