/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
public class DonHangServlet extends HttpServlet {
  private DonHangDAO donHangDAO = new DonHangDAO();
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
            out.println("<title>Servlet DonHangServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DonHangServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @SuppressWarnings("unchecked")
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
            List<DonHang> ds = donHangDAO.layDonHangTheoNguoiDung(nd.getId());
            req.setAttribute("dsDonHang", ds);
            req.getRequestDispatcher("lich_su_don_hang.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect("trangchu");
    }

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession phien = req.getSession();
        NguoiDung nd = (NguoiDung) phien.getAttribute("nguoiDung");
        if (nd == null) { resp.sendRedirect("dang_nhap.jsp"); return; }

        String diaChi = req.getParameter("diaChi");
        String sdt = req.getParameter("soDienThoai");
        String phuongThuc = req.getParameter("phuongThuc");

        List<Map<String,Object>> gioHang = (List<Map<String,Object>>) phien.getAttribute("gioHang");
        if (gioHang == null || gioHang.isEmpty()) { resp.sendRedirect("gio_hang.jsp"); return; }

        DonHang dh = new DonHang();
        dh.setMaNguoiDung(nd.getId());
        dh.setDiaChi(diaChi);
        dh.setSoDienThoai(sdt);
        dh.setPhuongThuc(phuongThuc);
        double tong = 0;
        for (Map<String,Object> item : gioHang) {
            model.SanPham sp = (model.SanPham) item.get("sanpham");
            int sl = (int) item.get("soluong");
            DonHangChiTiet ct = new DonHangChiTiet();
            ct.setMaSanPham(sp.getId());
            ct.setSoLuong(sl);
            ct.setGia(sp.getGia());
            dh.themChiTiet(ct);
            tong += sp.getGia() * sl;
        }
        dh.setTongTien(tong);
        int maDon = donHangDAO.themDonHang(dh);
        if (maDon > 0) {
            phien.removeAttribute("gioHang");
            resp.sendRedirect("donhang?hanhDong=lichsu");
        } else {
            req.setAttribute("loi", "Tạo đơn hàng thất bại");
            req.getRequestDispatcher("thanh_toan.jsp").forward(req, resp);
        }
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
