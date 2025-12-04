package controller;

import dao.DonHangDAO;
import dao.SanPhamDAO;
import dao.DanhGiaDAO;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DonHang;
import model.DonHangChiTiet;
import model.NguoiDung;
import model.SanPham;

@WebServlet(name = "DonHangServlet", urlPatterns = {"/DonHangServlet"})
public class DonHangServlet extends HttpServlet {

    private DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        String hanhDong = req.getParameter("hanhDong");
        if ("lichsu".equals(hanhDong)) {

            String tab = req.getParameter("tab");

            Set<String> validTabs = Set.of("dadat", "dagiao", "danggiao", "dahuy", "hoantien");

            // Nếu tab null hoặc không hợp lệ → filter = null (ALL)
            String filter = (tab != null && validTabs.contains(tab)) ? tab : null;

            // Tab active
            String activeTab = (filter == null) ? "all" : filter;

            List<DonHang> ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId(), filter);
            req.setAttribute("activeTab", activeTab);
            req.setAttribute("dsDonHang", ds);

            // ========== Lấy thông tin đánh giá ==========
            DanhGiaDAO dgDAO = new DanhGiaDAO();

            // 1) Map đơn hàng đã đánh giá (theo id đơn hàng / sản phẩm tùy bạn định nghĩa)
            Map<Integer, Integer> mapDonHangDanhGia =
                    dgDAO.laySanPhamDaDanhGiaTheoDonHang(nd.getId());
            req.setAttribute("mapDonHangDanhGia", mapDonHangDanhGia);

            // 2) Set các id sản phẩm mà user đã đánh giá
            Set<Integer> spDaDanhGia =
                    dgDAO.laySanPhamDaDanhGiaTheoNguoiDung(nd.getId());
            req.setAttribute("spDaDanhGia", spDaDanhGia);

            // ---------- Lấy map sản phẩm để hiển thị ----------
            SanPhamDAO spDAO = new SanPhamDAO();
            List<SanPham> dsSP = spDAO.layTatCa();   // Lấy tất cả sản phẩm 1 lần
            Map<Integer, SanPham> mapFullSP = dsSP.stream()
                    .collect(Collectors.toMap(
                            SanPham::getId_sanpham,
                            sp -> sp
                    ));
            req.setAttribute("mapSP", mapFullSP);

            req.getRequestDispatcher("don_hang.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=all");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        String action = req.getParameter("action");

        // HỦY / HOÀN TIỀN
        if ("cancel".equals(action) || "refund".equals(action)) {
            try {
                int idDonHang = Integer.parseInt(req.getParameter("id"));
                String tt = "cancel".equals(action) ? "dahuy" : "hoantien";
                donHangDAO.capNhatTrangThai(idDonHang, nd.getId(), tt);

                String tab = "cancel".equals(action) ? "dahuy" : "hoantien";
                resp.sendRedirect(req.getContextPath()
                        + "/DonHangServlet?hanhDong=lichsu&tab=" + tab);
            } catch (NumberFormatException ex) {
                resp.sendRedirect(req.getContextPath() + "/DonHangServlet?hanhDong=lichsu");
            }
            return;
        }

        // LƯU ĐƠN HÀNG
        if ("luuDonHang".equals(action)) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHang =
                    (List<Map<String, Object>>) session.getAttribute("gioHang");
            if (gioHang == null || gioHang.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gio_hang.jsp");
                return;
            }

            String diaChi = nonEmpty(req.getParameter("diaChi"),
                    (String) session.getAttribute("diaChi"));
            String sdt = nonEmpty(req.getParameter("soDienThoai"),
                    (String) session.getAttribute("soDienThoai"));
            String phuongThuc = nonEmpty(req.getParameter("phuongThuc"),
                    (String) session.getAttribute("phuongThuc"));
            if (phuongThuc == null || phuongThuc.isEmpty()) phuongThuc = "COD";

            DonHang dh = new DonHang();
            dh.setIdNguoiDung(nd.getId());
            dh.setDiaChi(diaChi);
            dh.setSoDienThoai(sdt);
            dh.setPhuongThuc(phuongThuc);

            double tong = 0;
            for (Map<String, Object> item : gioHang) {
                SanPham sp = (SanPham) item.get("sanpham");
                int sl = (int) item.get("soluong");

                DonHangChiTiet ct = new DonHangChiTiet();
                ct.setId_sanpham(sp.getId_sanpham());
                ct.setSoLuong(sl);
                ct.setGia(sp.getGia());

                dh.getChiTiet().add(ct);
                tong += sp.getGia() * sl;
            }
            double phiShip = 15000;
            dh.setTongTien(tong + phiShip);

            int id_donhang = donHangDAO.themDonHang(dh);
            if (id_donhang > 0) {
                session.removeAttribute("gioHang");
                session.setAttribute("donHangHienTai", dh);
                session.setAttribute("diaChi", diaChi);
                session.setAttribute("phuongThuc", phuongThuc);
                session.setAttribute("soDienThoai", sdt);

                resp.sendRedirect(req.getContextPath() + "/don_hang.jsp");
            } else {
                req.setAttribute("loi", "Tạo đơn hàng thất bại");
                req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/trang_chu.jsp");
    }

    private static String nonEmpty(String val, String fallback) {
        return (val != null && !val.trim().isEmpty())
                ? val.trim()
                : (fallback != null ? fallback.trim() : "");
    }
}
