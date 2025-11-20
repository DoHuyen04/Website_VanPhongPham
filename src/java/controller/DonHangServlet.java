package controller;

import dao.DonHangDAO;
import dao.SanPhamDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.stream.Collectors;
import model.DonHang;
import model.DonHangChiTiet;
import model.NguoiDung;
import model.SanPham;

@WebServlet(name = "DonHangServlet", urlPatterns = {"/DonHangServlet"})
public class DonHangServlet extends HttpServlet {

    private DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // KHÔNG tạo session mới
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        String hanhDong = req.getParameter("hanhDong");
        String action = req.getParameter("action");

        if ("lichsu".equals(hanhDong)) {
            String tab = req.getParameter("tab");
            String filter = ("dadat".equals(tab) || "dahuy".equals(tab) || "hoantien".equals(tab)) ? tab : null;

            List<DonHang> ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId(), filter);
            req.setAttribute("activeTab", filter == null ? "all" : filter); // để tô active tab
            req.setAttribute("dsDonHang", ds);
            // --------------- LẤY TÊN SẢN PHẨM ĐỂ HIỂN THỊ ---------------
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

        HttpSession session = req.getSession(false); // KHÔNG tạo session mới
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        String action = req.getParameter("action"); // "luuDonHang" | "cancel" | "refund" | null

        // 1️⃣ HỦY / HOÀN TIỀN
        if ("cancel".equals(action) || "refund".equals(action)) {
            try {
                int idDonHang = Integer.parseInt(req.getParameter("id"));
                String tt = "cancel".equals(action) ? "dahuy" : "hoantien";
                boolean ok = donHangDAO.capNhatTrangThai(idDonHang, nd.getId(), tt);

                String tab = "cancel".equals(action) ? "dahuy" : "hoantien";
                resp.sendRedirect(req.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=" + tab);
                return;
            } catch (NumberFormatException ex) {
                resp.sendRedirect(req.getContextPath() + "/DonHangServlet?hanhDong=lichsu");
                return;
            }
        }

        // 2️⃣ LƯU ĐƠN HÀNG
        if ("luuDonHang".equals(action)) {

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
            if (gioHang == null || gioHang.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gio_hang.jsp");
                return;
            }
            String diaChi = req.getParameter("diaChi"); // lấy địa chỉ đầy đủ đã ghép ở JSP

            if (diaChi == null || diaChi.trim().isEmpty()) {
                // fallback nếu cần thiết
                diaChi = (String) session.getAttribute("diaChi");
            }

            // --- LẤY SỐ ĐIỆN THOẠI & PHƯƠNG THỨC THANH TOÁN ---
            String sdt = nonEmpty(req.getParameter("soDienThoai"), (String) session.getAttribute("soDienThoai"));
            String phuongThuc = nonEmpty(req.getParameter("phuongThuc"), (String) session.getAttribute("phuongThuc"));
            if (phuongThuc == null || phuongThuc.trim().isEmpty()) {
                phuongThuc = "COD"; // mặc định
            }
            String soDienThoai = req.getParameter("soDienThoai");
            if (soDienThoai == null || soDienThoai.trim().isEmpty()) {
                soDienThoai = (String) session.getAttribute("soDienThoai");
            }
            // --- TẠO ĐƠN HÀNG ---
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

                // Lưu chi tiết vào đơn hàng
                dh.getChiTiet().add(ct);
                tong += sp.getGia() * sl;
                // Lấy toàn bộ sản phẩm 1 lần
            }
            double phiShip = 15000;
            dh.setTongTien(tong + phiShip);

            // --- LƯU ĐƠN HÀNG QUA DAO ---
            int id_donhang = donHangDAO.themDonHang(dh);
            if (id_donhang > 0) {
                // XÓA GIỎ HÀNG & LƯU ĐƠN HÀNG HIỆN TẠI TRONG SESSION
                session.removeAttribute("gioHang");
                session.setAttribute("donHangHienTai", dh);

                // Lưu lại địa chỉ để hiển thị
                session.setAttribute("diaChi", diaChi);
                session.setAttribute("phuongThuc", phuongThuc);
                session.setAttribute("soDienThoai", soDienThoai);

                resp.sendRedirect(req.getContextPath() + "/don_hang.jsp");
            } else {
                req.setAttribute("loi", "Tạo đơn hàng thất bại");
                req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
            }

            return;
        }

        // Nếu không phải action nào trên → về trang chủ
        resp.sendRedirect(req.getContextPath() + "/trang_chu.jsp");
    }

// --- HỖ TRỢ ---
    private static String nonEmpty(String val, String fallback) {
        return (val != null && !val.trim().isEmpty()) ? val.trim() : (fallback != null ? fallback.trim() : "");
    }

    private static String joinNonBlank(String... parts) {
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p != null && !p.trim().isEmpty()) {
                if (sb.length() > 0) {
                    sb.append(", ");
                }
                sb.append(p.trim());
            }
        }
        return sb.toString();
    }

    private static String normalizeAddr(String s) {
        if (s == null) {
            return "";
        }
        s = s.replaceAll("(?i),\\s*việt\\s*nam$", "");
        s = s.replaceAll("(\\s*,\\s*)+", ", ");
        s = s.replaceAll("^,\\s*|,\\s*$", "");
        return s.trim();
    }

    private static String ensureSuffixVN(String base) {
        base = normalizeAddr(base);
        return base.isEmpty() ? "Việt Nam" : base + ", Việt Nam";
    }

}
