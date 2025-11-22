/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.DiaChi;

public class DiaChiDAO {

    // Lấy danh sách tất cả địa chỉ của 1 người dùng
    public List<DiaChi> listByUser(int userId) {
        List<DiaChi> list = new ArrayList<>();
        String sql = "SELECT * FROM diachi WHERE userId = ? ORDER BY macDinh DESC, id DESC";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DiaChi d = map(rs);
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm mới 1 địa chỉ
    public boolean insert(DiaChi d) {
        String sql = """
            INSERT INTO diachi(userId, hoTen, soDienThoai, diaChiDuong, xaPhuong, quanHuyen, tinhThanh, macDinh)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, d.getUserId());
            ps.setString(2, d.getHoTen());
            ps.setString(3, d.getSoDienThoai());
            ps.setString(4, d.getDiaChiDuong());
            ps.setString(5, d.getXaPhuong());
            ps.setString(6, d.getQuanHuyen());
            ps.setString(7, d.getTinhThanh());
            ps.setBoolean(8, d.isMacDinh());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật 1 địa chỉ
    public boolean update(DiaChi d) {
        String sql = """
            UPDATE diachi SET hoTen=?, soDienThoai=?, diaChiDuong=?, xaPhuong=?, quanHuyen=?, tinhThanh=?, macDinh=?
            WHERE id=? AND userId=?
        """;
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, d.getHoTen());
            ps.setString(2, d.getSoDienThoai());
            ps.setString(3, d.getDiaChiDuong());
            ps.setString(4, d.getXaPhuong());
            ps.setString(5, d.getQuanHuyen());
            ps.setString(6, d.getTinhThanh());
            ps.setBoolean(7, d.isMacDinh());
            ps.setInt(8, d.getId());
            ps.setInt(9, d.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa địa chỉ theo id
    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM diachi WHERE id=? AND userId=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa trạng thái mặc định của tất cả địa chỉ user trước khi set cái mới
    public void clearDefault(int userId) {
        String sql = "UPDATE diachi SET macDinh=0 WHERE userId=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Đặt 1 địa chỉ là mặc định
    public void setDefault(int id, int userId) {
        try (Connection cn = DBUtil.getConnection()) {
            cn.setAutoCommit(false);

            try (PreparedStatement ps1 = cn.prepareStatement("UPDATE diachi SET macDinh=0 WHERE userId=?");
                 PreparedStatement ps2 = cn.prepareStatement("UPDATE diachi SET macDinh=1 WHERE id=? AND userId=?")) {

                ps1.setInt(1, userId);
                ps1.executeUpdate();

                ps2.setInt(1, id);
                ps2.setInt(2, userId);
                ps2.executeUpdate();

                cn.commit();
            } catch (Exception e) {
                cn.rollback();
                throw e;
            } finally {
                cn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
        // Lấy 1 địa chỉ theo id
    public DiaChi findById(int id) {
        String sql = "SELECT * FROM diachi WHERE id = ?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // ✅ Hàm ánh xạ (map) ResultSet → đối tượng DiaChi
    private DiaChi map(ResultSet rs) throws SQLException {
        DiaChi d = new DiaChi();
        d.setId(rs.getInt("id"));
        d.setUserId(rs.getInt("userId"));
        d.setHoTen(rs.getString("hoTen"));
        d.setSoDienThoai(rs.getString("soDienThoai"));
        d.setDiaChiDuong(rs.getString("diaChiDuong"));
        d.setXaPhuong(rs.getString("xaPhuong"));
        d.setQuanHuyen(rs.getString("quanHuyen"));
        d.setTinhThanh(rs.getString("tinhThanh"));
        d.setMacDinh(rs.getBoolean("macDinh"));
        return d;
    }
}
