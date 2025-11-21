package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.util.Arrays;
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
import java.util.HashMap;
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

        // LẤY NGƯỜI DÙNG ĐÃ ĐĂNG NHẬP
        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        // DỮ LIỆU TỪ FORM
        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        //String diaChi = request.getParameter("diaChi");
        String sdt = request.getParameter("soDienThoai");
        String tinh = request.getParameter("tinh");
        String huyen = request.getParameter("huyen");
        String xa = request.getParameter("xa");
        String duong = request.getParameter("duong");
        String diaChi = duong + ", " + xa + ", " + huyen + ", " + tinh;
        String phuongThuc = request.getParameter("phuongThuc");
        session.setAttribute("phuongThuc", phuongThuc);

        // KIỂM TRA THÔNG TIN NHẬN HÀNG
        if (tenNguoiNhan == null || tenNguoiNhan.isEmpty()
                || diaChi == null || diaChi.isEmpty()
                || sdt == null || sdt.isEmpty()) {
            request.setAttribute("error", "Không thể lấy địa chỉ nhận hàng. Vui lòng nhập lại!");
            request.setAttribute("tenNguoiNhan", tenNguoiNhan);
            request.setAttribute("diaChi", diaChi);
            request.setAttribute("soDienThoai", sdt);
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        // Email ưu tiên từ tài khoản
        String email = (nd != null ? nd.getEmail() : null);
        if (email == null) {
            email = (String) session.getAttribute("email");
        }
        if (email == null) {
            email = request.getParameter("email");
        }

        // Lấy OTP người dùng nhập (nếu có)
        String otpNhap = request.getParameter("otp");

        // ===== GIAI ĐOẠN 1: GỬI OTP =====
        if (otpNhap == null || otpNhap.isEmpty()) {

            if (nd == null && (email == null || email.isEmpty())) {
                request.setAttribute("error", "Vui lòng đăng nhập để thanh toán!");
                request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
                return;
            }

            // Lưu thông tin nhận hàng và email vào session
            session.setAttribute("tenNguoiNhan", tenNguoiNhan);
            session.setAttribute("diaChi", diaChi);
            session.setAttribute("soDienThoai", sdt);
            session.setAttribute("email", email);
            session.setAttribute("emailThanhToan", email);

            // Lấy giỏ hàng và sản phẩm đã chọn trước khi gửi OTP
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
            String[] chonSanPham = request.getParameterValues("chonSP");
            if (gioHang == null || chonSanPham == null || chonSanPham.length == 0) {
                request.setAttribute("error", "Không có sản phẩm nào được chọn để thanh toán!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            session.setAttribute("gioHangChon", gioHang);
            session.setAttribute("chonSP", chonSanPham);

            // Tạo OTP 6 số, hết hạn 5 phút
            String otp = String.format("%06d", new Random().nextInt(999999));
            long otpExpire = System.currentTimeMillis() + 5 * 60 * 1000;
            session.setAttribute("otp", otp);
            session.setAttribute("otp_expire", otpExpire);

            // Gửi email OTP
            String subject = "Mã xác nhận thanh toán đơn hàng của bạn";
            String message
                    = "<html>"
                    + "<body style='font-family:Arial,sans-serif; line-height:1.6; background-color:#f7f8fa; padding:20px;'>"
                    + "<div style='max-width:600px; margin:auto; background-color:#ffffff; border-radius:10px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.1);'>"
                    + "<h2 style='color:#4A90E2; text-align:center;'>Xác nhận thanh toán đơn hàng</h2>"
                    + "<p>Xin chào <b>" + tenNguoiNhan + "</b>,</p>"
                    + "<p>Mã OTP để hoàn tất thanh toán:</p>"
                    + "<div style='text-align:center; margin:25px 0;'>"
                    + "<span style='font-size:26px; font-weight:bold; color:#ffffff; background:linear-gradient(135deg, #74ABE2, #5563DE); padding:12px 30px; border-radius:8px; letter-spacing:3px;'>" + otp + "</span>"
                    + "</div>"
                    + "<p>Mã OTP có hiệu lực 5 phút. Không chia sẻ mã này với người khác.</p>"
                    + "<p style='margin-top:25px;'>Trân trọng,<br><b>Đội ngũ WEB Văn Phòng Phẩm</b></p>"
                    + "</div></body></html>";
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

        // ===== GIAI ĐOẠN 2: XÁC NHẬN OTP =====
        String otpSession = (String) session.getAttribute("otp");
        Long otpExpire = (Long) session.getAttribute("otp_expire");

        if (otpSession == null || otpExpire == null || System.currentTimeMillis() > otpExpire) {
            request.setAttribute("error", "OTP chưa gửi hoặc đã hết hạn!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        if (!otpNhap.trim().equals(otpSession.trim())) {
            request.setAttribute("error", "OTP không đúng! Vui lòng thử lại.");
            request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            return;
        }

        // OTP đúng → xóa session
        session.removeAttribute("otp");
        session.removeAttribute("otp_expire");

        // LẤY GIỎ HÀNG VÀ SẢN PHẨM ĐÃ CHỌN
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHangChon");
        String[] chonSanPham = (String[]) session.getAttribute("chonSP");

        if (gioHang == null || chonSanPham == null || chonSanPham.length == 0) {
            request.setAttribute("error", "Không có sản phẩm nào được chọn để đặt!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        // TẠO ĐƠN HÀNG
        DonHang dh = new DonHang();
        dh.setIdNguoiDung(nd.getId());
        dh.setDiaChi((String) session.getAttribute("diaChi"));
        dh.setSoDienThoai((String) session.getAttribute("soDienThoai"));
        dh.setPhuongThuc(request.getParameter("phuongThuc") != null ? request.getParameter("phuongThuc") : "COD");
//if (phuongThuc == null) phuongThuc = "COD";
//dh.setPhuongThuc(phuongThuc);

        double tongTien = 0.0;
        List<String> chonSPList = Arrays.asList(chonSanPham);

        for (Map<String, Object> item : gioHang) {
            SanPham sp = (SanPham) item.get("sanpham");
            int sl = (int) item.get("soluong");

            if (chonSPList.contains(String.valueOf(sp.getId_sanpham()))) {
                DonHangChiTiet ct = new DonHangChiTiet();
                ct.setId_sanpham(sp.getId_sanpham());
                ct.setSoLuong(sl);
                ct.setGia(sp.getGia());
                dh.getChiTiet().add(ct);
                tongTien += sp.getGia() * sl;
            }
        }
        dh.setTongTien(tongTien);

        // LƯU ĐƠN HÀNG
        int idDonHang = donHangDAO.themDonHang(dh);
        if (idDonHang > 0) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHangHienTai = (List<Map<String, Object>>) session.getAttribute("gioHang");
            if (gioHangHienTai != null) {
                gioHangHienTai.removeIf(item -> {
                    SanPham sp = (SanPham) item.get("sanpham");
                    return chonSPList.contains(String.valueOf(sp.getId_sanpham()));
                });
                session.setAttribute("gioHang", gioHangHienTai);
            }
            session.removeAttribute("gioHangChon");
            session.removeAttribute("chonSP");
            session.setAttribute("lastDonHangId", idDonHang);
            // ----- GỬI EMAIL THÔNG BÁO ĐƠN HÀNG -----
            double phiVanChuyen = 15000;
            double tongThanhToan = dh.getTongTien() + phiVanChuyen;

            Map<Integer, String> sanPhamMap = new HashMap<>();
            for (Map<String, Object> item : gioHang) {
                SanPham sp = (SanPham) item.get("sanpham");
                sanPhamMap.put(sp.getId_sanpham(), sp.getTen());
            }
            StringBuilder sb = new StringBuilder();
            sb.append("<html><body>");
            sb.append("<h2>WEB Văn Phòng Phẩm - Xác nhận đơn hàng</h2>");
            sb.append("<p>Xin chào <b>").append(nd.getHoTen()).append("</b>,</p>");
            sb.append("<p>Cảm ơn bạn đã đặt hàng. Chi tiết đơn hàng của bạn (ID: ").append(idDonHang).append(") như sau:</p>");
            sb.append("<table border='1' cellpadding='8' cellspacing='0' style='border-collapse:collapse;'>");
            sb.append("<tr><th>Mã sản phẩm</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr>");

            for (DonHangChiTiet ct : dh.getChiTiet()) {
               
                sb.append("<tr>");
                sb.append("<td>").append(ct.getId_sanpham()).append("</td>");
                sb.append("<td>").append(ct.getSoLuong()).append("</td>");
                sb.append("<td>").append(String.format("%,.0f VNĐ", ct.getGia())).append("</td>");
                sb.append("<td>").append(String.format("%,.0f VNĐ", ct.getGia() * ct.getSoLuong())).append("</td>");
                sb.append("</tr>");
            }

            sb.append("</table>");
            sb.append("<p><b>Tổng tiền hàng:</b> ").append(String.format("%,.0f VNĐ", dh.getTongTien())).append("</p>");
            sb.append("<p><b>Phí vận chuyển:</b> ").append(String.format("%,.0f VNĐ", phiVanChuyen)).append("</p>");
            sb.append("<p><b>Tổng thanh toán:</b> ").append(String.format("%,.0f VNĐ", tongThanhToan)).append("</p>");
            sb.append("<p>Địa chỉ nhận hàng: ").append(dh.getDiaChi()).append("</p>");
            sb.append("<p>Phương thức thanh toán: ").append(dh.getPhuongThuc()).append("</p>");
            sb.append("<p>Trân trọng,<br>Đội ngũ WEB Văn Phòng Phẩm</p>");
            sb.append("</body></html>");

            try {
                EmailUtility.sendEmail(nd.getEmail(), "Xác nhận đơn hàng #" + idDonHang, sb.toString());
            } catch (MessagingException e) {
                e.printStackTrace();
            }
            response.sendRedirect("thanh_toan_thanh_cong.jsp");
        } else {
            request.setAttribute("error", "Lưu đơn hàng thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xác nhận OTP và lưu đơn hàng";
    }
}
