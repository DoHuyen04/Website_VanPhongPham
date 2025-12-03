package controller;

import java.sql.Connection;
import dao.DBUtil;
import dao.DonHangDAO;
import model.DonHang;
import model.SanPham;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import model.DonHangChiTiet;
@WebServlet(name = "ShipperDonHang", urlPatterns = {"/ShipperDonHang"})
public class ShipperDonHang extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trangThai = req.getParameter("trangthai");
        if (trangThai == null || trangThai.isEmpty()) {
            trangThai = "dashboard";
        }
 String trangThaiParam = req.getParameter("trangthai"); // dadat, danggiao, dagiao, hoankho
        if (trangThaiParam == null || trangThaiParam.trim().isEmpty()) {
            trangThaiParam = "dashboard"; // mặc định là dashboard hiển thị tất cả
        }
final String finaltrangThaiParam = trangThaiParam;
        DonHangDAO dao = new DonHangDAO();
        List<DonHang> dsDonHang;

        switch(trangThaiParam.toLowerCase()) {
            case "dadat": // Đơn hàng đang giao
            case "danggiao": // Đang giao
            case "dagiao": // Đã giao
            case "hoankho": // Hoàn hàng
                dsDonHang = dao.layTatCaDonHang().stream()
                        .filter(dh -> finaltrangThaiParam.equalsIgnoreCase(dh.getTrangthai()))
                        .toList();
                break;
            case "dashboard":
            default:
                dsDonHang = dao.layTatCaDonHang(); // tất cả đơn hàng
                break;
        }
      
        Map<Integer, SanPham> mapSP = new HashMap<>();

        // Dữ liệu thống kê
        int totalOrders = 0;
        int ordersInProgress = 0;
        int ordersDelivered = 0;
        int ordersReturned = 0;
        List<Map<String, Object>> topProducts = new ArrayList<>();
        List<Map<String, Object>> topRatedProducts = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {

            // --- Lấy danh sách đơn hàng theo trạng thái ---
            String sql = "SELECT * FROM donhang";
            if ("dadat".equals(trangThai)) sql += " WHERE trangthai='dadat'";
            else if ("danggiao".equals(trangThai)) sql += " WHERE trangthai='danggiao'";
            else if ("dagiao".equals(trangThai)) sql += " WHERE trangthai='dagiao'";
            else if ("hoankho".equals(trangThai)) sql += " WHERE trangthai='hoankho'";
            // "thongke" lấy tất cả

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
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

                // Lấy chi tiết sản phẩm
                List<DonHangChiTiet> chiTietList = new ArrayList<>();
                PreparedStatement psCT = conn.prepareStatement("SELECT * FROM donhang_chitiet WHERE id_donhang=?");
                psCT.setInt(1, dh.getIdDonHang());
                ResultSet rsCT = psCT.executeQuery();
                while (rsCT.next()) {
                    DonHangChiTiet ct = new DonHangChiTiet();
                    ct.setId_sanpham(rsCT.getInt("id_sanpham"));
                    ct.setSoLuong(rsCT.getInt("soluong"));
                    ct.setGia(rsCT.getDouble("gia"));
                    chiTietList.add(ct);

                    // Lấy thông tin sản phẩm mapSP
                    if (!mapSP.containsKey(ct.getId_sanpham())) {
                        PreparedStatement psSP = conn.prepareStatement("SELECT * FROM sanpham WHERE id_sanpham=?");
                        psSP.setInt(1, ct.getId_sanpham());
                        ResultSet rsSP = psSP.executeQuery();
                        if (rsSP.next()) {
                            SanPham sp = new SanPham();
                            sp.setId_sanpham(rsSP.getInt("id_sanpham"));
                            sp.setTen(rsSP.getString("ten"));
                            sp.setGia(rsSP.getDouble("gia"));
                            sp.setMoTa(rsSP.getString("moTa"));
                            sp.setSoLuong(rsSP.getInt("soLuong"));
                            sp.setDanhMuc(rsSP.getString("danhMuc"));
                            sp.setHinhAnh(rsSP.getString("hinhAnh"));
                            sp.setLoai(rsSP.getString("loai"));
                            mapSP.put(sp.getId_sanpham(), sp);
                        }
                        rsSP.close();
                        psSP.close();
                    }
                }
                dh.setChiTiet(chiTietList);
                rsCT.close();
                psCT.close();

                dsDonHang.add(dh);
            }
            rs.close();
            ps.close();

            // --- Thống kê tổng số đơn ---
            Statement st = conn.createStatement();
            ResultSet rsStat = st.executeQuery("SELECT COUNT(*) AS total FROM donhang");
            if (rsStat.next()) totalOrders = rsStat.getInt("total");
            rsStat.close();

            // --- Số lượng đơn theo trạng thái ---
            rsStat = st.executeQuery("SELECT trangthai, COUNT(*) AS count FROM donhang GROUP BY trangthai");
            while (rsStat.next()) {
                String tt = rsStat.getString("trangthai");
                int count = rsStat.getInt("count");
                switch (tt) {
                    case "danggiao" -> ordersInProgress = count;
                    case "dagiao" -> ordersDelivered = count;
                    case "hoankho" -> ordersReturned = count;
                }
            }
            rsStat.close();

            // --- Top sản phẩm bán chạy nhất ---
            rsStat = st.executeQuery(
                "SELECT id_sanpham, SUM(soluong) AS total_qty " +
                "FROM donhang_chitiet GROUP BY id_sanpham ORDER BY total_qty DESC LIMIT 5");
            while (rsStat.next()) {
                int idSP = rsStat.getInt("id_sanpham");
                int qty = rsStat.getInt("total_qty");
                SanPham sp = mapSP.get(idSP);
                if (sp != null) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", idSP);
                    m.put("name", sp.getTen());
                    m.put("quantity", qty);
                    topProducts.add(m);
                }
            }
            rsStat.close();

            // --- Top sản phẩm đánh giá cao ---
            rsStat = st.executeQuery(
                "SELECT idSanPham, AVG(sao) as avg_rating " +
                "FROM DanhGia GROUP BY idSanPham ORDER BY avg_rating DESC LIMIT 5");
            while (rsStat.next()) {
                int idSP = rsStat.getInt("idSanPham");
                double rating = rsStat.getDouble("avg_rating");
                SanPham sp = mapSP.get(idSP);
                if (sp != null) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", idSP);
                    m.put("name", sp.getTen());
                    m.put("rating", rating);
                    topRatedProducts.add(m);
                }
            }
            rsStat.close();
            st.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        req.setAttribute("dsDonHang", dsDonHang);
        req.setAttribute("mapSP", mapSP);
        req.setAttribute("activeTab", trangThai);

        // Truyền dữ liệu thống kê
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("ordersInProgress", ordersInProgress);
        req.setAttribute("ordersDelivered", ordersDelivered);
        req.setAttribute("ordersReturned", ordersReturned);
        req.setAttribute("topProducts", topProducts);
        req.setAttribute("topRatedProducts", topRatedProducts);

        req.getRequestDispatcher("shipper_dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
