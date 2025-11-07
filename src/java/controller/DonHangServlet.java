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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        String hanhDong = req.getParameter("hanhDong");
        String action = req.getParameter("action");

        if ("lichsu".equals(hanhDong)) {
            String tab = req.getParameter("tab");
            List<DonHang> ds;
            if (tab != null) {
                ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId(), tab);
            } else {
                ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId());
            }
            req.setAttribute("activeTab", (tab == null ? "all" : tab));
            req.setAttribute("dsDonHang", ds);
            req.getRequestDispatcher("don_hang.jsp").forward(req, resp);
            return;
        } 
        resp.sendRedirect("trang_chu.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        String action = req.getParameter("action");

        if ("luuDonHang".equals(action)) {
            // Lấy thông tin thanh toán từ session (đã được lưu từ XacNhanOTPServlet)
            String diaChi = (String) session.getAttribute("diaChi");
            String sdt = (String) session.getAttribute("soDienThoai");
            String phuongThuc = (String) session.getAttribute("phuongThuc");
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");

            if (gioHang == null || gioHang.isEmpty()) {
                resp.sendRedirect("gio_hang.jsp");
                return;
            }

            // Tạo DonHang object
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

            // Lưu vào DB
            int id_donhang = donHangDAO.themDonHang(dh);
            if (id_donhang > 0) {
                // Xóa giỏ hàng sau khi lưu
                session.removeAttribute("gioHang");
                // Lưu idDonHang để hiển thị trang thanh toán thành công
                session.setAttribute("idDonHangThanhCong", id_donhang);
                req.getRequestDispatcher("thanh_toan_thanh_cong.jsp").forward(req, resp);
            } else {
                req.setAttribute("loi", "Tạo đơn hàng thất bại");
                req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
            }
            return;
        }

        // Các nhánh hủy/hoàn tiền
        if ("cancel".equals(action) || "refund".equals(action)) {
            int idDonHang = Integer.parseInt(req.getParameter("id"));
            String tt = "cancel".equals(action) ? "dahuy" : "hoantien";
            donHangDAO.capNhatTrangThai(idDonHang, nd.getId(), tt);
            String tab = "cancel".equals(action) ? "dahuy" : "hoantien";
            resp.sendRedirect("DonHangServlet?hanhDong=lichsu&tab=" + tab);
        }
    }
}
