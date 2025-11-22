/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DonHangDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.DonHang;
import model.DonHangChiTiet;
import model.SanPham;
import dao.TKNganHangDAO;
import model.TKNganHang;
import java.util.List;
import model.NguoiDung;
import dao.DiaChiDAO;
import model.DiaChi;

/**
 *
 * @author asus
 */
@WebServlet(name = "ThanhToanServlet", urlPatterns = {"/ThanhToanServlet"})
public class ThanhToanServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ThanhToanServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ThanhToanServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //HttpSession session = request.getSession(); thêm phần dưới 
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nguoiDung") == null) {
            response.sendRedirect(request.getContextPath() + "/dang_nhap.jsp");
            return;
        }
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
        if (gioHang == null || gioHang.isEmpty()) {
            response.sendRedirect("gio_hang.jsp");
            return;
        }

        // ===== (HEAD) Kiểm tra tồn kho từng sản phẩm trong giỏ =====
        for (Map<String, Object> item : gioHang) {
            SanPham sp = (SanPham) item.get("sanpham");
            int soLuong = (int) item.get("soluong");

            if (soLuong > sp.getSoLuong()) {
                request.setAttribute("error", "Sản phẩm " + sp.getTen() + " vượt quá tồn kho (" + sp.getSoLuong() + ")");
                request.getRequestDispatcher("gio_hang.jsp").forward(request, response);
                return;
            }
        }

        String tongTienStr = request.getParameter("tongTien");
        double tongTien = 0;
        if (tongTienStr != null && !tongTienStr.isEmpty()) {
            try {
                tongTien = Double.parseDouble(tongTienStr);
            } catch (NumberFormatException e) {
                tongTien = 0;
            }
        }
        // ✅ Lưu tổng tiền vào session
        session.setAttribute("tongTien", tongTien);

        String[] idsChon = request.getParameterValues("chonSP");
        if (idsChon == null || idsChon.length == 0) {
            session.setAttribute("message", "Vui lòng chọn ít nhất 1 sản phẩm!");
            response.sendRedirect("gio_hang.jsp");
            return;
        }
        List<Map<String, Object>> gioHangChon = new ArrayList<>();

        if (idsChon != null && gioHang != null) {
            Set<Integer> selectedIds = new HashSet<>();
            for (String s : idsChon) {
                selectedIds.add(Integer.parseInt(s.trim()));
            }

            for (Map<String, Object> item : gioHang) {
                SanPham sp = (SanPham) item.get("sanpham");
                if (selectedIds.contains(sp.getId_sanpham())) {
                    item.put("daChon", true);
                    gioHangChon.add(item);
                } else {
                    item.put("daChon", false);
                }
            }
        }

        session.setAttribute("gioHangChon", gioHangChon);
        request.setAttribute("tongTienHang", tongTien);

        String xacNhan = request.getParameter("xacNhan");

        if (xacNhan == null) {
            // Lấy thông tin người dùng từ session
            NguoiDung nguoiDung = (NguoiDung) session.getAttribute("nguoiDung");

            // Lấy danh sách tài khoản ngân hàng theo userId
            TKNganHangDAO tkDao = new TKNganHangDAO();
            List<TKNganHang> dsTaiKhoan = tkDao.listByUserId(nguoiDung.getId());

            // Truyền xuống JSP
            request.setAttribute("dsTaiKhoanNganHang", dsTaiKhoan);
            // 🔹 Lấy danh sách địa chỉ đã lưu của user
            DiaChiDAO diaChiDAO = new DiaChiDAO();
            List<DiaChi> dsDiaChi = diaChiDAO.listByUser(nguoiDung.getId());
            request.setAttribute("dsDiaChi", dsDiaChi);

            // ===== Chưa nhấn Xác nhận, chỉ hiển thị form =====
            RequestDispatcher rd = request.getRequestDispatcher("thanh_toan.jsp");
            rd.forward(request, response);
            return;
        }

        // ===== Nhấn Xác nhận, xử lý lưu đơn hàng =====
        Integer idNguoiDungObj = (Integer) session.getAttribute("idNguoiDung");
// Lấy object người dùng từ session
        model.NguoiDung nguoiDung = (model.NguoiDung) session.getAttribute("nguoiDung");

        if (nguoiDung == null) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

// Lấy id người dùng đúng chuẩn
        int idNguoiDung = nguoiDung.getId();

        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        String soDienThoai = request.getParameter("soDienThoai");
        String diaChi = request.getParameter("diaChi");
        String phuongThuc = request.getParameter("phuongThuc");

        if (phuongThuc == null || phuongThuc.trim().isEmpty()) {
            phuongThuc = "COD"; // mặc định
        }
        request.setAttribute("diaChi", diaChi);
        request.setAttribute("phuongThuc", phuongThuc);

        DonHang dh = new DonHang();
        dh.setId_nguoidung(idNguoiDung);
        dh.setDiaChi(diaChi);
        dh.setSoDienThoai(soDienThoai);
        dh.setPhuongThuc(request.getParameter("phuongThuc") != null
                ? request.getParameter("phuongThuc")
                : "COD");

        dh.setNgayDat(new Date());

        List<DonHangChiTiet> chiTiets = new ArrayList<>();
        for (Map<String, Object> item : gioHangChon) {
            SanPham sp = (SanPham) item.get("sanpham");
            int sl = (Integer) item.get("soluong");
            double thanhTien = sp.getGia() * sl;
            DonHangChiTiet ct = new DonHangChiTiet(0, sp.getId_sanpham(), sl, thanhTien);
            chiTiets.add(ct);
        }

        dh.setChiTiet(chiTiets);
        dh.setTongTien(tongTien);

        DonHangDAO dhDAO = new DonHangDAO();
        int idDonHang = dhDAO.themDonHang(dh);

        if (idDonHang > 0) {
            // Xóa sản phẩm đã đặt khỏi giỏ
            gioHang.removeIf(item -> item.get("daChon") != null && (Boolean) item.get("daChon"));
            session.setAttribute("gioHang", gioHang);
            session.setAttribute("idDonHangMoi", idDonHang);
            response.sendRedirect("don_hang.jsp");
        } else {
            session.setAttribute("message", "Đặt hàng thất bại!");
            response.sendRedirect("gio_hang.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
