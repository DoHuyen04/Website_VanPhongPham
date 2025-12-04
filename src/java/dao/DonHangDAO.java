package dao;

import model.DonHang;
import model.DonHangChiTiet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.nio.charset.StandardCharsets;
public class DonHangDAO {
// --- Add these imports if not present ---
public String layTrangThaiRawVaLog(int idDonHang) {
        String sql = "SELECT trangthai FROM donhang WHERE id_donhang=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idDonHang);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String raw = rs.getString("trangthai");
                    String hex = raw != null ? bytesToHex(raw.getBytes(StandardCharsets.UTF_8)) : "NULL";
                    int len = raw != null ? raw.length() : 0;
                    int trimmedLen = raw != null ? raw.trim().length() : 0;
                    System.out.println("[DAO] layTrangThaiRaw: id=" + idDonHang + ", raw='" + raw + "', HEX=" + hex + ", len=" + len + ", trimmedLen=" + trimmedLen);
                    return raw;
                } else {
                    System.out.println("[DAO] layTrangThaiRaw: Không tìm thấy ID=" + idDonHang);
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println("[DAO ERROR] layTrangThaiRaw id=" + idDonHang);
            e.printStackTrace();
            return null;
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02X", b));
        return sb.toString();
    }

    // --- Chuẩn hóa trạng thái ---
    public String normalizeStatus(String s) {
        if (s == null) return null;
        String replaced = s.replace('\u00A0', ' '); // NBSP → space
        replaced = replaced.replaceAll("\\s+", " ");
        return replaced.trim().toLowerCase();
    }

    // --- Cập nhật trạng thái theo điều kiện ---
    public int capNhatTrangThaiCoDieuKien(int idDonHang, String trangThaiMoi) {
        if (trangThaiMoi == null) return 0;
        trangThaiMoi = normalizeStatus(trangThaiMoi);

        // 1) Lấy trạng thái hiện tại
        String currentRaw = layTrangThaiRawVaLog(idDonHang);
        if (currentRaw == null) return 0;
        String current = normalizeStatus(currentRaw);

        System.out.println("[DAO] Normalized current='" + current + "' | requested='" + trangThaiMoi + "'");

        // 2) Kiểm tra điều kiện
        boolean allowed = false;
        switch (trangThaiMoi) {
            case "danggiao":
                allowed = "dadat".equals(current);
                break;
            case "dagiao":
                allowed = "danggiao".equals(current);
                break;
            case "hoankho":
                allowed = "dahuy".equals(current) || "hoantien".equals(current);
                break;
            default:
                System.out.println("[DAO] Trạng thái mới không hợp lệ: " + trangThaiMoi);
                return 0;
        }

        if (!allowed) {
            System.out.println("[DAO] Không được phép chuyển từ '" + current + "' → '" + trangThaiMoi + "'");
            return 0;
        }

        // 3) Thực hiện UPDATE với commit
        String sql = "UPDATE donhang SET trangthai=? WHERE id_donhang=?";
        try (Connection cn = DBUtil.getConnection()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setString(1, trangThaiMoi);
                ps.setInt(2, idDonHang);
                int rows = ps.executeUpdate();
                cn.commit();
                System.out.println("[DAO] UPDATE rows=" + rows + " for id=" + idDonHang);
                return rows;
            } catch (SQLException e) {
                cn.rollback();
                System.out.println("[DAO ERROR] rollback update id=" + idDonHang);
                e.printStackTrace();
                return 0;
            }
        } catch (SQLException e) {
            System.out.println("[DAO ERROR] capNhatTrangThai update id=" + idDonHang);
            e.printStackTrace();
            return 0;
        }
    }

    // --- Lấy đơn hàng theo ID ---
    public DonHang layDonHangTheoId(int idDonHang) {
        String sql = "SELECT * FROM donhang WHERE id_donhang=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idDonHang);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DonHang dh = new DonHang();
                    dh.setIdDonHang(rs.getInt("id_donhang"));
                    dh.setIdNguoiDung(rs.getInt("id_nguoidung"));
                    dh.setDiaChi(rs.getString("diachi"));
                    dh.setSoDienThoai(rs.getString("sodienthoai"));
                    dh.setPhuongThuc(rs.getString("phuongthuc"));
                    dh.setTongTien(rs.getDouble("tongtien"));
                    dh.setNgayDat(rs.getDate("ngaydat"));
                    dh.setTrangthai(rs.getString("trangthai"));
                    return dh;
                }
            }
        } catch (SQLException e) {
            System.out.println("[DAO ERROR] Lỗi khi lấy đơn hàng ID=" + idDonHang);
            e.printStackTrace();
        }
        return null;
    }


// --- Helper: đọc trạng thái thô và log hex ---
/**
 * New: cập nhật trạng thái nhưng first fetch current status and compare in Java.
 * trả về số row updated (1) hoặc 0.
 */
public int capNhatTrangThaiCoDieuKien2(int idDonHang, String trangThaiMoi) {
    if (trangThaiMoi == null) return 0;
    trangThaiMoi = normalizeStatus(trangThaiMoi);

    // 1) Lấy trạng thái hiện tại (raw) và log
    String currentRaw = layTrangThaiRawVaLog(idDonHang);
    if (currentRaw == null) {
        System.out.println("[DAO] capNhatTrangThaiCoDieuKien2: Không tìm thấy đơn hàng id=" + idDonHang);
        return 0;
    }
    String current = normalizeStatus(currentRaw);
    System.out.println("[DAO] Normalized current='" + current + "' | requested='" + trangThaiMoi + "'");

    // 2) Kiểm tra điều kiện chuyển trạng thái theo quy tắc
    boolean allowed = false;
    switch (trangThaiMoi) {
        case "danggiao":
            allowed = "dadat".equals(current);
            break;
        case "dagiao":
            allowed = "danggiao".equals(current);
            break;
        case "hoankho":
            allowed = "dahuy".equals(current) || "hoantien".equals(current);
            break;
        default:
            System.out.println("[DAO] capNhatTrangThaiCoDieuKien2: trạng thái mới không hợp lệ: " + trangThaiMoi);
            return 0;
    }

    if (!allowed) {
        System.out.println("[DAO] capNhatTrangThaiCoDieuKien2: Không được phép chuyển từ '" + current + "' → '" + trangThaiMoi + "'");
        return 0;
    }

    // 3) Nếu allowed -> thực hiện update bình thường
    String sql = "UPDATE donhang SET trangthai=? WHERE id_donhang=?";
    try (Connection cn = DBUtil.getConnection();
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, trangThaiMoi);
        ps.setInt(2, idDonHang);
        int rows = ps.executeUpdate();
        System.out.println("[DAO] capNhatTrangThaiCoDieuKien2: UPDATE rows=" + rows + " for id=" + idDonHang);
        return rows;
    } catch (SQLException e) {
        System.out.println("[DAO ERROR] capNhatTrangThaiCoDieuKien2 update id=" + idDonHang);
        e.printStackTrace();
        return 0;
    }
}

    // ➤ Thêm đơn hàng
    public int themDonHang(DonHang dh) {
        String sql = "INSERT INTO donhang(id_nguoidung, diachi, sodienthoai, phuongthuc, tongtien, ngaydat, trangthai) VALUES (?,?,?,?,?,NOW(),'dadat')";
        Connection cn = null;
        try {
            cn = DBUtil.getConnection();
            cn.setAutoCommit(false);

            try (PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, dh.getIdNguoiDung());
                ps.setString(2, dh.getDiaChi());
                ps.setString(3, dh.getSoDienThoai());
                ps.setString(4, dh.getPhuongThuc());
                ps.setDouble(5, dh.getTongTien());

                int kq = ps.executeUpdate();
                if (kq > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            int idDonHang = rs.getInt(1);

                            String sqlCt = "INSERT INTO donhangchitiet(id_donhang, id_sanpham, soluong, gia) VALUES (?,?,?,?)";
                            try (PreparedStatement psCt = cn.prepareStatement(sqlCt)) {
                                for (DonHangChiTiet ct : dh.getChiTiet()) {
                                    psCt.setInt(1, idDonHang);
                                    psCt.setInt(2, ct.getId_sanpham());
                                    psCt.setInt(3, ct.getSoLuong());
                                    psCt.setDouble(4, ct.getGia());
                                    psCt.addBatch();
                                }
                                psCt.executeBatch();
                            }

                            cn.commit();
                            return idDonHang;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (cn != null) {
                try { cn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (cn != null) {
                try { cn.setAutoCommit(true); cn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return -1;
    }

    // Lấy chi tiết đơn hàng
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
                    ct.setId_donhang(rs.getInt("id_donhang"));
                    ct.setId_sanpham(rs.getInt("id_sanpham"));
                    ct.setSoLuong(rs.getInt("soluong"));
                    ct.setGia(rs.getDouble("gia"));
                    ds.add(ct);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }


    // (Giữ phương thức layChiTietDonHang riêng)
    private List<DonHangChiTiet> layChiTietDonHangPublic(int idDonHang) { return layChiTietDonHang(idDonHang); }
    // ----------------- CẬP NHẬT TRẠNG THÁI (AN TOÀN VỚI ĐIỀU KIỆN) -----------------

    /**
     * Cập nhật trạng thái mới nhưng chỉ khi trạng thái hiện tại hợp lệ theo quy tắc:
     * - nếu trangThaiMoi == "danggiao"  => yêu cầu trangthai hiện tại = "dadat"
     * - nếu trangThaiMoi == "dagiao"    => yêu cầu trangthai hiện tại = "danggiao"
     * - nếu trangThaiMoi == "hoankho"   => yêu cầu trangthai hiện tại IN ('dahuy','hoantien')
     *
     * Trả về số hàng bị ảnh hưởng (rows).
     */
   

    // Cũ: capNhatTrangThai vẫn giữ nếu cần dùng generic (không dùng điều kiện)
    public boolean capNhatTrangThai(int idDonHang, String trangThaiMoi) {
        String sql = "UPDATE donhang SET trangthai=? WHERE id_donhang=?";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, trangThaiMoi);
            ps.setInt(2, idDonHang);

            int rows = ps.executeUpdate();
            System.out.println("[DEBUG DAO] rows updated=" + rows);
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("[ERROR DAO] Lỗi khi cập nhật trạng thái cho ID=" + idDonHang);
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả đơn hàng
    public List<DonHang> layTatCaDonHang() {
        List<DonHang> ds = new ArrayList<>();
        String sql = "SELECT * FROM donhang ORDER BY ngaydat DESC";
        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DonHang dh = new DonHang();
                dh.setIdDonHang(rs.getInt("id_donhang"));
                dh.setIdNguoiDung(rs.getInt("id_nguoidung"));
                dh.setDiaChi(rs.getString("diachi"));
                dh.setSoDienThoai(rs.getString("sodienthoai"));
                dh.setPhuongThuc(rs.getString("phuongthuc"));
                dh.setTongTien(rs.getDouble("tongtien"));
                dh.setNgayDat(rs.getDate("ngaydat"));
                dh.setTrangthai(rs.getString("trangthai"));
                dh.setChiTiet(layChiTietDonHang(dh.getIdDonHang()));
                ds.add(dh);
            }

        } catch (SQLException e) {
            System.out.println("[ERROR DAO] Lỗi khi lấy danh sách đơn hàng");
            e.printStackTrace();
        }
        return ds;
    }
    public List<DonHang> layDonHangTheoNguoiDung(int idNguoiDung) {
        return layDonHangTheoNguoiDung(idNguoiDung, null);
    }

// ➤ HÀM MỚI: có filter theo trạng thái (null = tất cả)
    public List<DonHang> layDonHangTheoNguoiDung(int idNguoiDung, String trangThai) {
        List<DonHang> ds = new ArrayList<>();

        // chỉ chấp nhận 3 giá trị hợp lệ
        boolean valid = "dadat".equalsIgnoreCase(trangThai)
                || "dahuy".equalsIgnoreCase(trangThai)
                || "hoantien".equalsIgnoreCase(trangThai);

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM donhang WHERE id_nguoidung=?"
        );
        if (valid) {
            sql.append(" AND trangthai=?");
        }
        sql.append(" ORDER BY ngaydat DESC");

        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            ps.setInt(1, idNguoiDung);
            if (valid) {
                ps.setString(2, trangThai.toLowerCase());
            }

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
                    dh.setTrangthai(rs.getString("trangthai"));
                    dh.setChiTiet(layChiTietDonHang(dh.getIdDonHang()));
                    ds.add(dh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ds;
    }

    // ➤ Lấy chi tiết đơn hàng
//    private List<DonHangChiTiet> layChiTietDonHang(int idDonHang) {
//        List<DonHangChiTiet> ds = new ArrayList<>();
//        String sql = "SELECT * FROM donhangchitiet WHERE id_donhang=?";
//
//        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
//
//            ps.setInt(1, idDonHang);
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    DonHangChiTiet ct = new DonHangChiTiet();
//                    ct.setId_donhangchitiet(rs.getInt("id_donhangchitiet"));
//                    ct.setId_donhang(rs.getInt("id_donhang"));
//                    ct.setId_sanpham(rs.getInt("id_sanpham"));
//                    ct.setSoLuong(rs.getInt("soluong"));
//                    ct.setGia(rs.getDouble("gia"));
//                    ds.add(ct);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return ds;
//    }
    // ➤ CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG: 'dadat' | 'dahuy' | 'hoantien'

    public boolean capNhatTrangThai(int idDonHang, int idNguoiDung, String trangThai) {
        String sql = "UPDATE donhang SET trangthai=? WHERE id_donhang=? AND id_nguoidung=?";
        try (Connection cn = DBUtil.getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, trangThai);
            ps.setInt(2, idDonHang);
            ps.setInt(3, idNguoiDung);

            int kq = ps.executeUpdate();
            return kq > 0; // true nếu cập nhật thành công

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
