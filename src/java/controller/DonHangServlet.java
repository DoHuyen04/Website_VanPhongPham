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
        HttpSession phien = req.getSession();
        Object o = phien.getAttribute("nguoiDung");
        if (o == null) {
            resp.sendRedirect("dang_nhap.jsp");
            return;
        }
        NguoiDung nd = (NguoiDung) o;

        String hanhDong = req.getParameter("hanhDong");
        if ("thanhtoan".equals(hanhDong)) {
            // hiện form thanh toán
            req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
            return;
        } else if ("lichsu".equals(hanhDong)) {
            // nd.getId() là id người dùng; DAO nhận int id_nguoidung
            List<DonHang> ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId());
            req.setAttribute("dsDonHang", ds);
            req.getRequestDispatcher("lich_su_don_hang.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect("trangchu.jsp");
    }

    @SuppressWarnings("unchecked")
    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    HttpSession phien = req.getSession();
    NguoiDung nd = (NguoiDung) phien.getAttribute("nguoiDung");
    if (nd == null) {
        resp.sendRedirect("dang_nhap.jsp");
        return;
    }

    // LẤY THÔNG TIN ĐỊA CHỈ TỪ FORM (duong, xa, huyen, tinh)
    String duong = req.getParameter("duong");
    String xa = req.getParameter("xa");
    String huyen = req.getParameter("huyen");
    String tinh = req.getParameter("tinh");
    // Nếu bạn vẫn dùng param tên "diaChi" ở form, đoạn này vẫn hoạt động nếu "duong" null -> fallback
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

    String sdt = req.getParameter("soDienThoai");
    String phuongThuc = req.getParameter("phuongThuc");

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
