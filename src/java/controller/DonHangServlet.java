/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.DonHang;
import model.DonHangChiTiet;
import model.NguoiDung;
import model.SanPham;

/**
 *
 * @author asus
 */
@WebServlet(name = "DonHangServlet", urlPatterns = {"/DonHangServlet"})
public class DonHangServlet extends HttpServlet {

    private DonHangDAO donHangDAO = new DonHangDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DonHangServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DonHangServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        HttpSession phien = req.getSession(false);
//        Object o = phien.getAttribute("nguoiDung");
//        if (o == null) {
//            resp.sendRedirect("dang_nhap.jsp");
//            return;
//        }
//        NguoiDung nd = (NguoiDung) o;
        HttpSession phien = req.getSession(false); // KHÔNG tạo session mới
        if (phien == null || phien.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) phien.getAttribute("nguoiDung");

        String hanhDong = req.getParameter("hanhDong");
        if ("thanhtoan".equals(hanhDong)) {
            // hiện form thanh toán
            req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
            return;
        } else if ("lichsu".equals(hanhDong)) {
            // --- BẮT ĐẦU: PHẦN THÊM MỚI ---
            // Đọc tab lọc trạng thái (tất cả / đã đặt / đã huỷ / hoàn tiền)
            String tab = req.getParameter("tab");
            String filter = null;
            if ("dadat".equals(tab) || "dahuy".equals(tab) || "hoantien".equals(tab)) {
                filter = tab;
            }

            // Nếu có filter thì gọi hàm có trạng thái, ngược lại giữ như cũ
            List<DonHang> ds;
            if (filter != null) {
                ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId(), filter);
            } else {
                ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId());
            }

            // Lưu trạng thái tab đang active để JSP biết
            req.setAttribute("activeTab", (tab == null ? "all" : tab));
            // --- KẾT THÚC PHẦN THÊM MỚI ---

            // nd.getId() là id người dùng; DAO nhận int id_nguoidung
            // Giữ nguyên các dòng gốc
            req.setAttribute("dsDonHang", ds);
            req.getRequestDispatcher("don_hang.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect("trangchu.jsp");
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        HttpSession phien = req.getSession();
//        NguoiDung nd = (NguoiDung) phien.getAttribute("nguoiDung");
//        if (nd == null) {
//            resp.sendRedirect("dang_nhap.jsp");
//            return;
//        }
        HttpSession phien = req.getSession(false); // KHÔNG tạo session mới
        if (phien == null || phien.getAttribute("nguoiDung") == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) phien.getAttribute("nguoiDung");
        // ➤ Thêm NHÁNH ACTION thay đổi trạng thái
        String action = req.getParameter("action"); // 'cancel' | 'refund' | null
        if ("cancel".equals(action) || "refund".equals(action)) {
            int idDonHang = Integer.parseInt(req.getParameter("id"));
            String tt = "cancel".equals(action) ? "dahuy" : "hoantien";
            boolean ok = donHangDAO.capNhatTrangThai(idDonHang, nd.getId(), tt);
            String tab = "cancel".equals(action) ? "dahuy" : "hoantien";
            resp.sendRedirect("DonHangServlet?hanhDong=lichsu&tab=" + tab);
            return;
        }

        // LẤY THÔNG TIN ĐỊA CHỈ TỪ FORM (duong, xa, huyen, tinh)
        String duong = req.getParameter("duong");
        String xa = req.getParameter("xa");
        String huyen = req.getParameter("huyen");
        String tinh = req.getParameter("tinh");

        String sdt = req.getParameter("soDienThoai");
        String phuongThuc = req.getParameter("phuongThuc");

// Fallback: nếu request không có (do đi qua bước OTP) thì lấy từ session
        if ((duong == null || duong.isEmpty()) && phien.getAttribute("duong") != null) {
            duong = (String) phien.getAttribute("duong");
        }
        if ((xa == null || xa.isEmpty()) && phien.getAttribute("xa") != null) {
            xa = (String) phien.getAttribute("xa");
        }
        if ((huyen == null || huyen.isEmpty()) && phien.getAttribute("huyen") != null) {
            huyen = (String) phien.getAttribute("huyen");
        }
        if ((tinh == null || tinh.isEmpty()) && phien.getAttribute("tinh") != null) {
            tinh = (String) phien.getAttribute("tinh");
        }
        if ((sdt == null || sdt.isEmpty()) && phien.getAttribute("soDienThoai") != null) {
            sdt = (String) phien.getAttribute("soDienThoai");
        }
        if ((phuongThuc == null || phuongThuc.isEmpty()) && phien.getAttribute("phuongThuc") != null) {
            phuongThuc = (String) phien.getAttribute("phuongThuc");
        }

// GHÉP LẠI địa chỉ sau khi đã fallback
        String diaChi = "";
        if (duong != null && !duong.isEmpty()) {
            diaChi = duong + ", ";
        }
        if (xa != null && !xa.isEmpty()) {
            diaChi += xa + ", ";
        }
        if (huyen != null && !huyen.isEmpty()) {
            diaChi += huyen + ", ";
        }
        if (tinh != null && !tinh.isEmpty()) {
            diaChi += tinh;
        }

        // LẤY GIỎ HÀNG TỪ SESSION
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) phien.getAttribute("gioHang");
        if (gioHang == null || gioHang.isEmpty()) {
            resp.sendRedirect("gio_hang.jsp");
            return;
        }

        // Tạo DonHang object
        DonHang dh = new DonHang();
        dh.setIdNguoiDung(nd.getId()); // lưu id người dùng đúng tên getter/setter trong model
        dh.setDiaChi(diaChi);
        dh.setSoDienThoai(sdt);
        dh.setPhuongThuc(phuongThuc);

        double tong = 0.0;
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

        // Gọi DAO để lưu
        int id_donhang = donHangDAO.themDonHang(dh);
        if (id_donhang > 0) {
            // Lưu thành công -> xoá giỏ và chuyển hướng tới hiển thị lịch sử (đúng URL servlet)
            phien.removeAttribute("gioHang");
            // chuyển về chính servlet nhưng với param hanhDong=lichsu (chú ý tên servlet chính xác)
            resp.sendRedirect("DonHangServlet?hanhDong=lichsu");
        } else {
            req.setAttribute("loi", "Tạo đơn hàng thất bại");
            req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
