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
        response.sendRedirect("thanh_toan.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        // LẤY NGƯỜI DÙNG ĐÃ ĐĂNG NHẬP (HEAD)
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        // DỮ LIỆU TỪ FORM (iamaine + HEAD)
        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        String diaChi = request.getParameter("diaChi");
        String sdt = request.getParameter("soDienThoai");

        // Email: ưu tiên từ tài khoản; nếu không có thì lấy từ session/param (iamaine)
        String email = (nd != null ? nd.getEmail() : null);
        if (email == null) email = (String) session.getAttribute("email");
        if (email == null) email = request.getParameter("email");

        // OTP người dùng nhập (nếu có) → GIAI ĐOẠN 2
        String otpNhap = request.getParameter("otp");

        // ===== GIAI ĐOẠN 1: GỬI OTP (khi chưa nhập otp) =====
        if (otpNhap == null || otpNhap.isEmpty()) {
            // Nếu chưa đăng nhập và cũng không có email → bắt đăng nhập (giữ logic an toàn của HEAD)
            if (nd == null && (email == null || email.isEmpty())) {
                request.setAttribute("error", "Vui lòng đăng nhập để thanh toán!");
                request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
                return;
            }

            // Validate đủ thông tin nhận hàng (HEAD + iamaine)
            if (tenNguoiNhan == null || diaChi == null || sdt == null
                    || tenNguoiNhan.isEmpty() || diaChi.isEmpty() || sdt.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin nhận hàng!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            // Lấy tổng tiền từ session (iamaine có đọc, không bắt buộc dùng ở đây)
            double tongTien = 0;
            Object tongTienObj = session.getAttribute("tongTien");
            if (tongTienObj instanceof Double) {
                tongTien = (Double) tongTienObj;
            }

            // LƯU TẠM THÔNG TIN ĐỂ QUA BƯỚC OTP
            session.setAttribute("tenNguoiNhan", tenNguoiNhan);
            session.setAttribute("diaChi", diaChi);
            session.setAttribute("soDienThoai", sdt);
            // giữ cả hai key email để tương thích 2 nhánh
            session.setAttribute("email", email);
            session.setAttribute("emailThanhToan", email);

            // TẠO OTP 6 SỐ & HẾT HẠN 5 PHÚT (HEAD + iamaine)
            String otp = String.format("%06d", new Random().nextInt(999999));
            long thoiGianHetHan = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút
            session.setAttribute("otp", otp);
            session.setAttribute("otp_expire", thoiGianHetHan);

            // GỬI MAIL OTP — mẫu HTML “đẹp” (iamaine)
            String subject = "Mã xác nhận thanh toán đơn hàng của bạn";
            String message
                    = "<html>"
                    + "<body style='font-family:Arial,sans-serif; line-height:1.6; background-color:#f7f8fa; padding:20px;'>"
                    + "<div style='max-width:600px; margin:auto; background-color:#ffffff; border-radius:10px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.1);'>"
                    + "<h2 style='color:#4A90E2; text-align:center;'>Xác nhận thanh toán đơn hàng</h2>"
                    + "<p>Xin chào <b>" + tenNguoiNhan + "</b>,</p>"
                    + "<p>Cảm ơn bạn đã mua sắm tại <b>WEB Văn Phòng Phẩm</b>! <br>"
                    + "Dưới đây là mã xác nhận (OTP) để hoàn tất thanh toán đơn hàng của bạn:</p>"
                    + "<div style='text-align:center; margin:25px 0;'>"
                    + "<span style='font-size:26px; font-weight:bold; color:#ffffff; background:linear-gradient(135deg, #74ABE2, #5563DE); padding:12px 30px; border-radius:8px; letter-spacing:3px;'>" + otp + "</span>"
                    + "</div>"
                    + "<p>Mã OTP có hiệu lực trong <b>5 phút</b>. Vui lòng không chia sẻ mã này với bất kỳ ai để đảm bảo an toàn tài khoản của bạn.</p>"
                    + "<p style='margin-top:25px;'>Trân trọng,<br>"
                    + "<b>Đội ngũ hỗ trợ - WEB Văn Phòng Phẩm</b></p>"
                    + "<hr style='margin-top:30px; border:none; border-top:1px solid #ddd;'>"
                    + "<p style='font-size:12px; color:#777; text-align:center;'>Đây là email tự động, vui lòng không phản hồi lại email này.</p>"
                    + "</div>"
                    + "</body>"
                    + "</html>";
            try {
                EmailUtility.sendEmail(email, subject, message);
                request.setAttribute("thongBao", "Mã OTP đã được gửi đến email " + email);
                request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            } catch (MessagingException e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể gửi email OTP. Vui lòng thử lại!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            }
            return;
        }

        // ===== GIAI ĐOẠN 2: XÁC NHẬN OTP (khi đã nhập otp) =====
        // BẮT ĐĂNG NHẬP (HEAD giữ logic an toàn)
        if (nd == null) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String otpSession = (String) session.getAttribute("otp");
        Long otpExpire = (Long) session.getAttribute("otp_expire");

        if (otpSession == null || otpExpire == null || System.currentTimeMillis() > otpExpire) {
            request.setAttribute("error", "OTP chưa gửi hoặc đã hết hạn!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        if (otpNhap.equals(otpSession)) {
            // OTP đúng → xóa dấu vết OTP
            session.removeAttribute("otp");
            session.removeAttribute("otp_expire");

            // TẠO ĐƠN HÀNG (HEAD)
            DonHang dh = new DonHang();
            dh.setIdNguoiDung(nd.getId());
            dh.setDiaChi((String) session.getAttribute("diaChi"));
            dh.setSoDienThoai((String) session.getAttribute("soDienThoai"));
            dh.setPhuongThuc("Thanh toán trực tuyến");

            double tongTien = 0.0;
            @SuppressWarnings("unchecked")
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
                session.setAttribute("lastDonHangId", idDonHang); // giữ key theo HEAD
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

    @Override
    public String getServletInfo() {
        return "Servlet xác nhận OTP và lưu đơn hàng";
    }
}
