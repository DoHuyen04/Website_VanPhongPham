package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
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
import java.io.UnsupportedEncodingException;
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

        NguoiDung nd = (NguoiDung) session.getAttribute("nguoiDung");

        // LẤY THÔNG TIN NGƯỜI NHẬN
        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        String sdt = request.getParameter("soDienThoai");
        String tinh = request.getParameter("tinh");
        String huyen = request.getParameter("huyen");
        String xa = request.getParameter("xa");
        String duong = request.getParameter("duong");
        String diaChi = duong + ", " + xa + ", " + huyen + ", " + tinh;
        String phuongThuc = request.getParameter("phuongThuc");
        session.setAttribute("phuongThuc", phuongThuc);

        if (tenNguoiNhan == null || tenNguoiNhan.isEmpty()
                || diaChi == null || diaChi.isEmpty()
                || sdt == null || sdt.isEmpty()) {
            request.setAttribute("error", "Không thể lấy địa chỉ nhận hàng. Vui lòng nhập lại!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        String email = (nd != null ? nd.getEmail() : null);
        if (email == null) email = (String) session.getAttribute("email");
        if (email == null) email = request.getParameter("email");

        // Lấy giỏ hàng
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> gioHang = (List<Map<String, Object>>) session.getAttribute("gioHang");
        String[] chonSanPham = request.getParameterValues("chonSP");
        if (gioHang == null || chonSanPham == null || chonSanPham.length == 0) {
            request.setAttribute("error", "Không có sản phẩm nào được chọn để thanh toán!");
            request.getRequestDispatcher("thanh_toan.jsp").forward(request, response);
            return;
        }

        // LUỒNG COD: lưu ngay
        if ("COD".equalsIgnoreCase(phuongThuc)) {
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

        // LUỒNG BANK: xử lý OTP
        String otpNhap = request.getParameter("otp");

        if (otpNhap == null || otpNhap.isEmpty()) {
            // lưu session thông tin
            session.setAttribute("tenNguoiNhan", tenNguoiNhan);
            session.setAttribute("diaChi", diaChi);
            session.setAttribute("soDienThoai", sdt);
            session.setAttribute("emailThanhToan", email);
            session.setAttribute("gioHangChon", gioHang);
            session.setAttribute("chonSP", chonSanPham);

            // tạo OTP
            String otp = String.format("%06d", new Random().nextInt(999999));
            long otpExpire = System.currentTimeMillis() + 5 * 60 * 1000;
            session.setAttribute("otp", otp);
            session.setAttribute("otp_expire", otpExpire);

            String subject = "Mã OTP xác nhận thanh toán";
            String message = "<html><body>"
                    + "<h3>Xin chào " + tenNguoiNhan + "</h3>"
                    + "<p>Mã OTP của bạn là: <b>" + otp + "</b> (hết hạn 5 phút)</p>"
                    + "<p>Không chia sẻ mã này với người khác.</p>"
                    + "</body></html>";
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

        // xác nhận OTP
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

        // OTP đúng -> xóa session và lưu đơn hàng
        session.removeAttribute("otp");
        session.removeAttribute("otp_expire");
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

    private DonHang taoDonHang(NguoiDung nd, List<Map<String,Object>> gioHang, String[] chonSanPham, String diaChi, String sdt, String phuongThuc) {
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
        if (id > 0) dh.setIdDonHang(id);
        else return null;
        return dh;
    }

    private void xoaSanPhamTrongGioHang(HttpSession session, List<Map<String,Object>> gioHang, String[] chonSanPham) {
        List<String> chonSPList = Arrays.asList(chonSanPham);
        gioHang.removeIf(item -> {
            SanPham sp = (SanPham) item.get("sanpham");
            return chonSPList.contains(String.valueOf(sp.getId_sanpham()));
        });
        session.setAttribute("gioHang", gioHang);
    }

    private void guiEmailXacNhan(NguoiDung nd, DonHang dh, List<Map<String,Object>> gioHang) throws UnsupportedEncodingException {
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
            sb.append("<td>").append(String.format("%,.0f VNĐ", ct.getGia()*ct.getSoLuong())).append("</td>");
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
            EmailUtility.sendEmail(nd.getEmail(), "Xác nhận đơn hàng #" + dh.getIdDonHang(), sb.toString());
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xác nhận OTP và lưu đơn hàng (COD hoặc Bank)";
    }
}
