package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
            req.getRequestDispatcher("don_hang.jsp").forward(req, resp);
            return;
        }
    resp.sendRedirect(req.getContextPath() + "/DonHangServlet?hanhDong=lichsu&tab=all");

        // resp.sendRedirect("trang_chu.jsp");
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
        // 1) HỦY / HOÀN TIỀN
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
        // 2) LƯU ĐƠN HÀNG
//        if ("luuDonHang".equals(action)) {
//            // CÁCH 1 (theo nhánh A): có sẵn trong session từ bước OTP
//            String diaChiFromSession = (String) session.getAttribute("diaChi");
//            String sdt = (String) session.getAttribute("soDienThoai");
//            String phuongThuc = (String) session.getAttribute("phuongThuc");
//
//            @SuppressWarnings("unchecked")
//            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
//
//            // CÁCH 2 (theo nhánh B): lấy từ form và fallback session từng phần
//            String duong = req.getParameter("duong");
//            String xa = req.getParameter("xa");
//            String huyen = req.getParameter("huyen");
//            String tinh = req.getParameter("tinh");
//
//            String sdtReq = req.getParameter("soDienThoai");
//            String phuongThucReq = req.getParameter("phuongThuc");
//
//            if ((duong == null || duong.isEmpty()) && session.getAttribute("duong") != null) {
//                duong = (String) session.getAttribute("duong");
//            }
//            if ((xa == null || xa.isEmpty()) && session.getAttribute("xa") != null) {
//                xa = (String) session.getAttribute("xa");
//            }
//            if ((huyen == null || huyen.isEmpty()) && session.getAttribute("huyen") != null) {
//                huyen = (String) session.getAttribute("huyen");
//            }
//            if ((tinh == null || tinh.isEmpty()) && session.getAttribute("tinh") != null) {
//                tinh = (String) session.getAttribute("tinh");
//            }
//            if ((sdtReq == null || sdtReq.isEmpty()) && session.getAttribute("soDienThoai") != null) {
//                sdtReq = (String) session.getAttribute("soDienThoai");
//            }
//            if ((phuongThucReq == null || phuongThucReq.isEmpty()) && session.getAttribute("phuongThuc") != null) {
//                phuongThucReq = (String) session.getAttribute("phuongThuc");
//            }
//
//            // Ưu tiên địa chỉ ghép từ các phần; nếu rỗng thì dùng diaChi từ session
//            StringBuilder sb = new StringBuilder();
//            if (duong != null && !duong.isEmpty()) {
//                sb.append(duong).append(", ");
//            }
//            if (xa != null && !xa.isEmpty()) {
//                sb.append(xa).append(", ");
//            }
//            if (huyen != null && !huyen.isEmpty()) {
//                sb.append(huyen).append(", ");
//            }
//            if (tinh != null && !tinh.isEmpty()) {
//                sb.append(tinh);
//            }
//            String diaChiFromParts = sb.toString().replaceAll(",\\s*$", "");
//
//            String baseParts = normalizeAddr(diaChiFromParts);
//            String baseSess = normalizeAddr(diaChiFromSession);
//
//            String baseAddr = !baseParts.isEmpty() ? baseParts : baseSess;
//            String diaChi = ensureSuffixVN(baseAddr);
//
//            // Ưu tiên giá trị từ form; nếu trống thì dùng session
//            if (sdtReq != null && !sdtReq.isEmpty()) {
//                sdt = sdtReq;
//            }
//            if (phuongThucReq != null && !phuongThucReq.isEmpty()) {
//                phuongThuc = phuongThucReq;
//            }
//
//            // Nếu giỏ hàng null/thấy rỗng → về giỏ
//            if (gioHang == null || gioHang.isEmpty()) {
//                resp.sendRedirect(req.getContextPath() + "/gio_hang.jsp");
//                return;
//            }
//
//            // Tạo đối tượng đơn hàng
//            DonHang dh = new DonHang();
//            dh.setIdNguoiDung(nd.getId());
//            dh.setDiaChi(diaChi);
//            dh.setSoDienThoai(sdt);
//            dh.setPhuongThuc(phuongThuc);
//
//            double tong = 0;
//            for (Map<String, Object> item : gioHang) {
//                SanPham sp = (SanPham) item.get("sanpham");
//                int sl = (int) item.get("soluong");
//
//                DonHangChiTiet ct = new DonHangChiTiet();
//                ct.setId_sanpham(sp.getId_sanpham());
//                ct.setSoLuong(sl);
//                ct.setGia(sp.getGia());
//
//                dh.getChiTiet().add(ct);
//                tong += sp.getGia() * sl;
//            }
//            dh.setTongTien(tong);
//
//            // Lưu DB
//            int id_donhang = donHangDAO.themDonHang(dh);
//            if (id_donhang > 0) {
//                // Xóa giỏ hàng sau khi lưu
//                session.removeAttribute("gioHang");
//                // Lưu idDonHang để hiển thị trang thanh toán thành công
//                session.setAttribute("idDonHangThanhCong", id_donhang);
//                req.getRequestDispatcher("thanh_toan_thanh_cong.jsp").forward(req, resp);
//            } else {
//                req.setAttribute("loi", "Tạo đơn hàng thất bại");
//                req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
//            }
//            return;
//        }
//        resp.sendRedirect(req.getContextPath() + "/trang_chu.jsp");
//
//    }
   if ("luuDonHang".equals(action)) {
            String diaChiSession = (String) session.getAttribute("diaChi");
            String sdt = (String) session.getAttribute("soDienThoai");
            String phuongThuc = (String) session.getAttribute("phuongThuc");
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");

            if (gioHang == null || gioHang.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gio_hang.jsp");
                return;
            }

            // Lấy từng phần địa chỉ từ form hoặc session fallback
            String duong = nonEmpty(req.getParameter("duong"), (String) session.getAttribute("duong"));
            String xa = nonEmpty(req.getParameter("xa"), (String) session.getAttribute("xa"));
            String huyen = nonEmpty(req.getParameter("huyen"), (String) session.getAttribute("huyen"));
            String tinh = nonEmpty(req.getParameter("tinh"), (String) session.getAttribute("tinh"));
            String sdtReq = nonEmpty(req.getParameter("soDienThoai"), sdt);
            String phuongThucReq = nonEmpty(req.getParameter("phuongThuc"), phuongThuc);

            // Ghép địa chỉ đầy đủ: Đường, Xã, Huyện, Tỉnh, Việt Nam
            String diaChi = ensureSuffixVN(joinNonBlank(duong, xa, huyen, tinh));
            sdt = sdtReq;
            phuongThuc = phuongThucReq;

            // Tạo đơn hàng
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
            dh.setTongTien(tong);

            int id_donhang = donHangDAO.themDonHang(dh);
            if (id_donhang > 0) {
                session.removeAttribute("gioHang");
                session.setAttribute("idDonHangThanhCong", id_donhang);
                req.getRequestDispatcher("thanh_toan_thanh_cong.jsp").forward(req, resp);
            } else {
                req.setAttribute("loi", "Tạo đơn hàng thất bại");
                req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/trang_chu.jsp");
    }
    // Ghép các phần không rỗng: "đường, xã, huyện, tỉnh"
private static String nonEmpty(String val, String fallback) {
        return (val != null && !val.trim().isEmpty()) ? val.trim() : (fallback != null ? fallback.trim() : "");
    }
    private static String joinNonBlank(String... parts) {
        StringBuilder b = new StringBuilder();
        for (String p : parts) {
            if (p != null && !p.trim().isEmpty()) {
                if (b.length() > 0) {
                    b.append(", ");
                }
                b.append(p.trim());
            }
        }
        return b.toString();
    }

// Chuẩn hoá chuỗi địa chỉ: bỏ ", Việt Nam" nếu đã có, gộp/phủi dấu phẩy thừa
    private static String normalizeAddr(String s) {
        if (s == null) {
            return "";
        }
        s = s.replaceAll("(?i),\\s*việt\\s*nam$", "");
        s = s.replaceAll("(\\s*,\\s*)+", ", ");
        s = s.replaceAll("^,\\s*|,\\s*$", "");
        return s.trim();
    }

// Bảo đảm chắc chắn có đuôi "Việt Nam"
    private static String ensureSuffixVN(String base) {
        base = normalizeAddr(base);
        return base.isEmpty() ? "Việt Nam" : base + ", Việt Nam";
    }

}
