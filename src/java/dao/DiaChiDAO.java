/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.DiaChi;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiaChiDAO {

    // Lấy danh sách địa chỉ theo user
    public List<DiaChi> findByUser(int userId) {
        String sql = "SELECT id, user_id, ho_ten, so_dien_thoai, dia_chi_duong, xa_phuong, quan_huyen, tinh_thanh, mac_dinh " +
             "FROM dia_chi WHERE user_id = ? ORDER BY mac_dinh DESC, id DESC";

        List<DiaChi> list = new ArrayList<>();

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DiaChi d = mapRow(rs);
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            
        }
        return list;
    }

    // Thêm địa chỉ và trả về ID mới (dùng cho AJAX)
    public int addAndReturnId(DiaChi d) {
        String sql = "INSERT INTO dia_chi (user_id, ho_ten, so_dien_thoai, dia_chi_duong, xa_phuong, quan_huyen, tinh_thanh, mac_dinh) " +
             "VALUES (?,?,?,?,?,?,?,?)";


        // Nếu đánh dấu mặc định, cần bỏ mặc định những địa chỉ khác trong cùng user (transaction)
        try (Connection cn = DBUtil.getConnection()) {
            cn.setAutoCommit(false);

            if (d.isMacDinh()) {
                unsetDefaultInternal(cn, d.getUserId());
            }

            try (PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, d.getUserId());
                ps.setString(2, d.getHoTen());
                ps.setString(3, d.getSoDienThoai());
                ps.setString(4, d.getDiaChiDuong());
                ps.setString(5, d.getXaPhuong());
                ps.setString(6, d.getQuanHuyen());
                ps.setString(7, d.getTinhThanh());
                ps.setBoolean(8, d.isMacDinh());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        cn.commit();
                        return id;
                    }
                }
            } catch (SQLException ex) {
                cn.rollback();
                throw ex;
            } finally {
                cn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // (Tuỳ chọn) Thêm địa chỉ không cần trả ID – giữ tương thích code cũ
    public boolean add(DiaChi d) {
        return addAndReturnId(d) > 0;
    }

    // Đặt mặc định 1 địa chỉ cho user (bỏ mặc định các cái khác)
    public void setDefault(int userId, int id) throws SQLException {
        try (Connection cn = DBUtil.getConnection()) {
            cn.setAutoCommit(false);
            try {
                unsetDefaultInternal(cn, userId);
                try (PreparedStatement ps = cn.prepareStatement(
                        "UPDATE dia_chi SET mac_dinh = 1 WHERE id = ? AND user_id = ?")) {
                    ps.setInt(1, id);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
                cn.commit();
            } catch (SQLException ex) {
                cn.rollback();
                throw ex;
            } finally {
                cn.setAutoCommit(true);
            }
        }
    }

    // Xoá địa chỉ (chỉ xoá của đúng user)
    public void delete(int userId, int id) throws SQLException {
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(
                     "DELETE FROM dia_chi WHERE id = ? AND user_id = ?")) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    // ====== Helpers ======

    private void unsetDefaultInternal(Connection cn, int userId) throws SQLException {
        try (PreparedStatement ps = cn.prepareStatement(
                "UPDATE dia_chi SET mac_dinh = 0 WHERE user_id = ? AND mac_dinh = 1")) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private DiaChi mapRow(ResultSet rs) throws SQLException {
    DiaChi d = new DiaChi();
    d.setId(rs.getInt("id"));
    d.setUserId(rs.getInt("user_id"));
    d.setHoTen(rs.getString("ho_ten"));
    d.setSoDienThoai(rs.getString("so_dien_thoai"));
    d.setDiaChiDuong(rs.getString("dia_chi_duong"));
    d.setXaPhuong(rs.getString("xa_phuong"));
    d.setQuanHuyen(rs.getString("quan_huyen"));
    d.setTinhThanh(rs.getString("tinh_thanh"));
    d.setMacDinh(rs.getBoolean("mac_dinh"));
    return d;
}
public boolean updateForUser(DiaChi d, int userId) {
        String sql =
            "UPDATE dia_chi " +
            "   SET ho_ten=?, so_dien_thoai=?, dia_chi_duong=?, xa_phuong=?, quan_huyen=?, tinh_thanh=?, mac_dinh=? " +
            " WHERE id=? AND user_id=?";

        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, d.getHoTen());          // ho_ten
            ps.setString(2, d.getSoDienThoai());    // so_dien_thoai
            ps.setString(3, d.getDiaChiDuong());    // dia_chi_duong
            ps.setString(4, d.getXaPhuong());       // xa_phuong
            ps.setString(5, d.getQuanHuyen());      // quan_huyen
            ps.setString(6, d.getTinhThanh());      // tinh_thanh
            ps.setBoolean(7, d.isMacDinh());        // mac_dinh
            ps.setInt(8, d.getId());                // WHERE id=?
            ps.setInt(9, userId);                   //   AND user_id=?
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Khi đặt 1 địa chỉ là mặc định, bỏ mặc định các địa chỉ khác của user */
    public void clearDefaultOthers(int userId, int exceptId) {
        String sql = "UPDATE dia_chi SET mac_dinh=0 WHERE user_id=? AND id<>?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, exceptId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
