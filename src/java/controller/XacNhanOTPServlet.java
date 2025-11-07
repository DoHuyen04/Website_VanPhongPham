package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Random;
import jakarta.mail.MessagingException;
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
import utils.EmailUtility;

@WebServlet(name = "XacNhanOTPServlet", urlPatterns = {"/XacNhanOTPServlet"})
public class XacNhanOTPServlet extends HttpServlet {

    private DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tránh truy cập GET trực tiếp
        response.sendRedirect("thanh_toan.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        // Lấy người dùng đã đăng nhập
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        if (nd == null) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String otpNhap = request.getParameter("otp");
        if (otpNhap == null || otpNhap.isEmpty()) {
            // ---- GIAI ĐOẠN 1: Gửi OTP ----
            String tenNguoiNhan = request.getParameter("tenNguoiNhan");
            String diaChi = request.getParameter("diaChi");
            String sdt = request.getParameter("soDienThoai");
            String email = nd.getEmail(); // lấy email từ tài khoản

            if (tenNguoiNhan == null || diaChi == null || sdt == null ||
                tenNguoiNhan.isEmpty() || diaChi.isEmpty() || sdt.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin nhận hàng!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            // Lưu tạm vào session
            session.setAttribute("tenNguoiNhan", tenNguoiNhan);
            session.setAttribute("diaChi", diaChi);
            session.setAttribute("soDienThoai", sdt);
            session.setAttribute("emailThanhToan", email);

            // Tạo OTP
            String otp = String.format("%06d", new Random().nextInt(999999));
            long otpExpire = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút
            session.setAttribute("otp", otp);
            session.setAttribute("otp_expire", otpExpire);

            // Gửi mail OTP
            String subject = "Mã xác nhận thanh toán đơn hàng";
            String message = "<h3>Xin chào " + tenNguoiNhan + "</h3>"
                    + "<p>Mã OTP của bạn là: <b>" + otp + "</b>. Hết hạn trong 5 phút.</p>";
            try {
                EmailUtility.sendEmail(email, subject, message);
                request.setAttribute("thongBao", "Mã OTP đã được gửi đến email " + email);
                request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            } catch (MessagingException e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể gửi email OTP. Vui lòng thử lại!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            }

        } else {
            // ---- GIAI ĐOẠN 2: Xác nhận OTP ----
            String otpSession = (String) session.getAttribute("otp");
            Long otpExpire = (Long) session.getAttribute("otp_expire");

            if (otpSession == null || otpExpire == null || System.currentTimeMillis() > otpExpire) {
                request.setAttribute("error", "OTP chưa gửi hoặc đã hết hạn!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            if (otpNhap.equals(otpSession)) {
                // OTP đúng → lưu đơn hàng
                session.removeAttribute("otp");
                session.removeAttribute("otp_expire");

                DonHang dh = new DonHang();
                dh.setIdNguoiDung(nd.getId());
                dh.setDiaChi((String) session.getAttribute("diaChi"));
                dh.setSoDienThoai((String) session.getAttribute("soDienThoai"));
                dh.setPhuongThuc("Thanh toán trực tuyến");

                double tongTien = 0.0;
                List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
                if (gioHang != null) {
                    for (Map<String, Object> item : gioHang) {
                        SanPham sp = (SanPham) item.get("sanpham");
                        int sl = (int) item.get("soluong");
                        DonHangChiTiet ct = new DonHangChiTiet();
                        ct.setId_sanpham(sp.getId_sanpham());
                        ct.setSoLuong(sl);
                        ct.setGia(sp.getGia());
                        dh.getChiTiet().add(ct);
                        tongTien += sp.getGia() * sl;
                    }
                }
                dh.setTongTien(tongTien);

                int idDonHang = donHangDAO.themDonHang(dh);
                if (idDonHang > 0) {
                    session.removeAttribute("gioHang");
                    session.setAttribute("lastDonHangId", idDonHang);
                    response.sendRedirect("thanh_toan_thanh_cong.jsp");
                } else {
                    request.setAttribute("error", "Lưu đơn hàng thất bại. Vui lòng thử lại!");
                    request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Mã OTP không đúng!");
                request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xác nhận OTP và lưu đơn hàng";
    }
}
