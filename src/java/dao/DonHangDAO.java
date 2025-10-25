package dao;

import model.DonHang;
import model.DonHangChiTiet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO {

    // ➤ Thêm đơn hàng
    public int themDonHang(DonHang dh) {
<<<<<<< HEAD
    String sql = "INSERT INTO donhang(id_nguoidung, diachi, sodienthoai, phuongthuc, tongtien, ngaydat) VALUES (?,?,?,?,?,NOW())";
    Connection cn = null;
    try {
        cn = DBUtil.getConnection();
        cn.setAutoCommit(false); // tắt auto-commit để quản lý transaction

        try (PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, dh.getIdNguoiDung());
=======
        String sql = "INSERT INTO don_hang (id_nguoidung, dia_chi, so_dien_thoai, phuong_thuc, tong_tien) VALUES (?,?,?,?,?)";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, dh.getId_nguoidung());
>>>>>>> origin/iamaine
            ps.setString(2, dh.getDiaChi());
            ps.setString(3, dh.getSoDienThoai());
            ps.setString(4, dh.getPhuongThuc());
            ps.setDouble(5, dh.getTongTien());

            int kq = ps.executeUpdate();

            if (kq > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
<<<<<<< HEAD
                        int idDonHang = rs.getInt(1);

                        String sqlCt = "INSERT INTO donhangchitiet(id_donhang, id_sanpham, soluong, gia) VALUES (?,?,?,?)";
                        try (PreparedStatement psCt = cn.prepareStatement(sqlCt)) {
                            for (DonHangChiTiet ct : dh.getChiTiet()) {
                                psCt.setInt(1, idDonHang);
=======
                        int id_donhang = rs.getInt(1);

                        // lưu chi tiết
                        String sqlCt = "INSERT INTO don_hang_chi_tiet (id_donhang, id_sanpham, so_luong, gia) VALUES (?,?,?,?)";
                        try (PreparedStatement psCt = cn.prepareStatement(sqlCt)) {
                            for (DonHangChiTiet ct : dh.getChiTiet()) {
                                psCt.setInt(1, id_donhang);
>>>>>>> origin/iamaine
                                psCt.setInt(2, ct.getId_sanpham());
                                psCt.setInt(3, ct.getSoLuong());
                                psCt.setDouble(4, ct.getGia());
                                psCt.addBatch();
                            }
                            psCt.executeBatch();
                        }

<<<<<<< HEAD
                        cn.commit(); // ✅ commit khi mọi thứ OK
                        return idDonHang;
=======
                        return id_donhang;
>>>>>>> origin/iamaine
                    }
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        // rollback khi lỗi xảy ra
        if (cn != null) {
            try {
                cn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    } finally {
        if (cn != null) {
            try {
                cn.setAutoCommit(true); // bật lại auto-commit
                cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

<<<<<<< HEAD
    return -1;
}

    // ➤ Lấy danh sách đơn hàng theo người dùng
    public List<DonHang> layDonHangTheoNguoiDung(int idNguoiDung) {
        List<DonHang> ds = new ArrayList<>();
        String sql = "SELECT * FROM donhang WHERE id_nguoidung=? ORDER BY ngaydat DESC";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idNguoiDung);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHang dh = new DonHang();
                    dh.setIdDonHang(rs.getInt("id_donhang"));
                    dh.setIdNguoiDung(rs.getInt("id_nguoidung"));
                    dh.setDiaChi(rs.getString("diachi"));
                    dh.setSoDienThoai(rs.getString("sodienthoai"));
                    dh.setPhuongThuc(rs.getString("phuongthuc"));
                    dh.setTongTien(rs.getDouble("tongtien"));
                    dh.setNgayDat(rs.getDate("ngaydat"));
                    // ➤ Lấy chi tiết đơn hàng
                    dh.setChiTiet(layChiTietDonHang(dh.getIdDonHang()));
=======
    public List<DonHang> layDonHangTheoNguoiDung(int id_nguoidung) {
        List<DonHang> ds = new ArrayList<>();
        String sql = "SELECT id_donhang, id_nguoidung, dia_chi, so_dien_thoai, phuong_thuc, tong_tien, ngay_lap " +
                     "FROM don_hang WHERE id_nguoidung=? ORDER BY ngay_lap DESC";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id_nguoidung);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHang dh = new DonHang();
                    dh.setId_donhang(rs.getInt("id_donhang"));
                    dh.setId_nguoidung(rs.getInt("id_nguoidung"));
                    dh.setDiaChi(rs.getString("dia_chi"));
                    dh.setSoDienThoai(rs.getString("so_dien_thoai"));
                    dh.setPhuongThuc(rs.getString("phuong_thuc"));
                    dh.setTongTien(rs.getDouble("tong_tien"));
                    dh.setNgayLap(rs.getTimestamp("ngay_lap")); // Timestamp là subclass của Date

                    // load chi tiết
                    dh.setChiTiet(layChiTietDonHang(dh.getId_donhang()));
>>>>>>> origin/iamaine
                    ds.add(dh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

<<<<<<< HEAD
    // ➤ Lấy chi tiết đơn hàng
    private List<DonHangChiTiet> layChiTietDonHang(int idDonHang) {
        List<DonHangChiTiet> ds = new ArrayList<>();
        String sql = "SELECT * FROM donhangchitiet WHERE id_donhang=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idDonHang);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangChiTiet ct = new DonHangChiTiet();
                    ct.setId_donhangchitiet(rs.getInt("id_donhangchitiet"));
                    ct.setId_sanpham(rs.getInt("id_sanpham"));
                    ct.setSoLuong(rs.getInt("soluong"));
=======
    private List<DonHangChiTiet> layChiTietDonHang(int id_donhang) {
        List<DonHangChiTiet> ds = new ArrayList<>();
        String sql = "SELECT id, id_sanpham, so_luong, gia FROM don_hang_chi_tiet WHERE id_donhang=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id_donhang);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHangChiTiet ct = new DonHangChiTiet();
                    ct.id_donhangchitiet(rs.getInt("id"));
                    ct.setId_sanpham(rs.getInt("id_sanpham"));
                    ct.setSoLuong(rs.getInt("so_luong"));
>>>>>>> origin/iamaine
                    ct.setGia(rs.getDouble("gia"));
                    ds.add(ct);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }
}
