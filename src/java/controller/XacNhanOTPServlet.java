package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Random;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeUtility;
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

    private final DonHangDAO donHangDAO = new DonHangDAO();

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

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");
        if (nd == null) {
            response.sendRedirect(request.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        // Lấy phương thức thanh toán (nếu không có trên request thì lấy ở session)
        String phuongThuc = request.getParameter("phuongThuc");
        if (phuongThuc == null || phuongThuc.isBlank()) {
            phuongThuc = (String) session.getAttribute("phuongThuc");
        }
        if (phuongThuc == null || phuongThuc.isBlank()) {
            phuongThuc = "COD";
        }
        session.setAttribute("phuongThuc", phuongThuc);

        // ========= LUỒNG THANH TOÁN KHI NHẬN HÀNG (COD) - KHÔNG OTP =========
        if ("COD".equalsIgnoreCase(phuongThuc)) {

            // LẤY THÔNG TIN NGƯỜI NHẬN TỪ FORM
            String tenNguoiNhan = request.getParameter("tenNguoiNhan");
            String sdt = request.getParameter("soDienThoai");
            String tinh = request.getParameter("tinh");
            String huyen = request.getParameter("huyen");
            String xa = request.getParameter("xa");
            String duong = request.getParameter("duong");
            String diaChi = duong + ", " + xa + ", " + huyen + ", " + tinh;

            if (tenNguoiNhan == null || tenNguoiNhan.isEmpty()
                    || diaChi == null || diaChi.isEmpty()
                    || sdt == null || sdt.isEmpty()) {
                request.setAttribute("error", "Không thể lấy địa chỉ nhận hàng. Vui lòng nhập lại!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            // LẤY GIỎ HÀNG VÀ SẢN PHẨM ĐÃ CHỌN
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
            String[] chonSanPham = request.getParameterValues("chonSP");
            if (gioHang == null || chonSanPham == null || chonSanPham.length == 0) {
                request.setAttribute("error", "Không có sản phẩm nào được chọn để thanh toán!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            // TẠO ĐƠN HÀNG
            DonHang dh = taoDonHang(nd, gioHang, chonSanPham, diaChi, sdt, phuongThuc);
            if (dh != null) {
                xoaSanPhamTrongGioHang(session, gioHang, chonSanPham);
                session.setAttribute("lastDonHangId", dh.getIdDonHang());
                guiEmailXacNhan(nd, dh, gioHang);
                response.sendRedirect("thanh_toan_thanh_cong.jsp");
            } else {
                request.setAttribute("error", "Lưu đơn hàng thất bại. Vui lòng thử lại!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            }
            return;
        }

        // ========= LUỒNG NGÂN HÀNG LIÊN KẾT (BANK) - CÓ OTP =========
        // Xem thử request này có mang mã OTP không
        String otpNhap = request.getParameter("otp");

        // -----------------------------------------------------------
        // BƯỚC 1: GỬI OTP (request từ trang thanh_toan.jsp, chưa có otp)
        // -----------------------------------------------------------
        if (otpNhap == null || otpNhap.isEmpty()) {

            // LẤY THÔNG TIN NGƯỜI NHẬN TỪ FORM
            String tenNguoiNhan = request.getParameter("tenNguoiNhan");
            String sdt = request.getParameter("soDienThoai");
            String tinh = request.getParameter("tinh");
            String huyen = request.getParameter("huyen");
            String xa = request.getParameter("xa");
            String duong = request.getParameter("duong");
            String diaChi = duong + ", " + xa + ", " + huyen + ", " + tinh;

            if (tenNguoiNhan == null || tenNguoiNhan.isEmpty()
                    || diaChi == null || diaChi.isEmpty()
                    || sdt == null || sdt.isEmpty()) {
                request.setAttribute("error", "Không thể lấy địa chỉ nhận hàng. Vui lòng nhập lại!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            String email = (nd.getEmail() != null ? nd.getEmail() : null);
            if (email == null) {
                email = (String) session.getAttribute("email");
            }
            if (email == null) {
                email = request.getParameter("email");
            }

            // LẤY GIỎ HÀNG VÀ SẢN PHẨM CHỌN
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
            String[] chonSanPham = request.getParameterValues("chonSP");
            if (gioHang == null || chonSanPham == null || chonSanPham.length == 0) {
                request.setAttribute("error", "Không có sản phẩm nào được chọn để thanh toán!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
                return;
            }

            // LƯU THÔNG TIN VÀO SESSION ĐỂ DÙNG LẠI SAU KHI NHẬP OTP
            session.setAttribute("tenNguoiNhan", tenNguoiNhan);
            session.setAttribute("diaChi", diaChi);
            session.setAttribute("soDienThoai", sdt);
            session.setAttribute("emailThanhToan", email);
            session.setAttribute("gioHangChon", gioHang);
            session.setAttribute("chonSP", chonSanPham);

            // TẠO OTP
            String otp = String.format("%06d", new Random().nextInt(999999));
            long otpExpire = System.currentTimeMillis() + 5 * 60 * 1000;
            session.setAttribute("otp", otp);
            session.setAttribute("otp_expire", otpExpire);

            String subject = MimeUtility.encodeText("Mã OTP xác nhận thanh toán", "UTF-8", "B");

            String message
                    = "<html>"
                    + "<body style='font-family:Arial,sans-serif; line-height:1.6; background-color:#f7f8fa; padding:20px;'>"
                    + "<div style='max-width:600px; margin:auto; background-color:#ffffff; border-radius:10px; padding:20px; box-shadow:0 2px 8px rgba(0,0,0,0.1);'>"
                    + "<h2 style='color:#4A90E2; text-align:center;'>Xác nhận thanh toán đơn hàng</h2>"
                    + "<p>Xin chào <b>" + tenNguoiNhan + "</b>,</p>"
                    + "<p>Cảm ơn bạn đã mua sắm tại <b>WEB Văn Phòng Phẩm</b>!<br>"
                    + "Dưới đây là mã xác nhận (OTP) để hoàn tất thanh toán đơn hàng của bạn:</p>"
                    + "<div style='text-align:center; margin:25px 0;'>"
                    + "<span style='font-size:26px; font-weight:bold; color:#ffffff; background:linear-gradient(135deg, #74ABE2, #5563DE); padding:12px 30px; border-radius:8px; letter-spacing:3px;'>"
                    + otp
                    + "</span>"
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
                request.setAttribute("thongBao", "Mã OTP đã gửi đến email: " + email);
                request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            } catch (MessagingException e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể gửi email OTP. Vui lòng thử lại!");
                request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            }
            return;
        }

        // -----------------------------------------------------------
        // BƯỚC 2: NGƯỜI DÙNG ĐÃ NHẬP OTP → KIỂM TRA & TẠO ĐƠN
        // -----------------------------------------------------------
        String otpSession = (String) session.getAttribute("otp");
        Long otpExpire = (Long) session.getAttribute("otp_expire");
        if (otpSession == null || otpExpire == null || System.currentTimeMillis() > otpExpire) {
            request.setAttribute("error", "OTP chưa gửi hoặc đã hết hạn!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }
        if (!otpNhap.trim().equals(otpSession.trim())) {
            request.setAttribute("error", "OTP không đúng!");
            request.getRequestDispatcher("xacnhan_otp.jsp").forward(request, response);
            return;
        }

        // OTP đúng -> xóa OTP khỏi session
        session.removeAttribute("otp");
        session.removeAttribute("otp_expire");

        // LẤY LẠI DỮ LIỆU ĐÃ LƯU TRONG SESSION LÚC GỬI OTP
        String tenNguoiNhan = (String) session.getAttribute("tenNguoiNhan");
        String diaChi = (String) session.getAttribute("diaChi");
        String sdt = (String) session.getAttribute("soDienThoai");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHangChon");
        String[] chonSanPham = (String[]) session.getAttribute("chonSP");

        if (gioHang == null || chonSanPham == null || chonSanPham.length == 0) {
            request.setAttribute("error", "Không tìm thấy thông tin giỏ hàng để tạo đơn. Vui lòng thực hiện lại!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        DonHang dh = taoDonHang(nd, gioHang, chonSanPham, diaChi, sdt, phuongThuc);
        if (dh != null) {
            xoaSanPhamTrongGioHang(session, gioHang, chonSanPham);
            session.setAttribute("lastDonHangId", dh.getIdDonHang());
            guiEmailXacNhan(nd, dh, gioHang);
            response.sendRedirect("thanh_toan_thanh_cong.jsp");
        } else {
            request.setAttribute("error", "Lưu đơn hàng thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
        }
    }

    // ================== HÀM PHỤ TRỢ ==================
    private DonHang taoDonHang(NguoiDung nd,
            List<Map<String, Object>> gioHang,
            String[] chonSanPham,
            String diaChi,
            String sdt,
            String phuongThuc) {

        DonHang dh = new DonHang();
        dh.setIdNguoiDung(nd.getId());
        dh.setDiaChi(diaChi);
        dh.setSoDienThoai(sdt);
        dh.setPhuongThuc(phuongThuc);

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
        int id = donHangDAO.themDonHang(dh);
        if (id > 0) {
            dh.setIdDonHang(id);
        } else {
            return null;
        }
        return dh;
    }

    private void xoaSanPhamTrongGioHang(HttpSession session,
            List<Map<String, Object>> gioHang,
            String[] chonSanPham) {
        List<String> chonSPList = Arrays.asList(chonSanPham);
        gioHang.removeIf(item -> {
            SanPham sp = (SanPham) item.get("sanpham");
            return chonSPList.contains(String.valueOf(sp.getId_sanpham()));
        });
        session.setAttribute("gioHang", gioHang);
    }

    private void guiEmailXacNhan(NguoiDung nd, DonHang dh,
            List<Map<String, Object>> gioHang) throws UnsupportedEncodingException {
        double phiVanChuyen = 15000;
        double tongThanhToan = dh.getTongTien() + phiVanChuyen;

        StringBuilder sb = new StringBuilder();
        sb.append("<html><body>");
        sb.append("<h2>WEB Văn Phòng Phẩm - Xác nhận đơn hàng</h2>");
        sb.append("<p>Xin chào <b>").append(nd.getHoTen()).append("</b>,</p>");
        sb.append("<p>Chi tiết đơn hàng ID: ").append(dh.getIdDonHang()).append("</p>");
        sb.append("<table border='1' cellpadding='8' cellspacing='0'>");
        sb.append("<tr><th>Mã SP</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr>");
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
            EmailUtility.sendEmail(nd.getEmail(),
                    "Đơn hàng đã đặt \n Mã đơn hàng : id" + dh.getIdDonHang(),
                    sb.toString());
                       

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xác nhận OTP và lưu đơn hàng (COD hoặc Bank)";
    }
}
