/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DBUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/CapNhatThongTinServlet")
public class CapNhatThongTinServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession ses = request.getSession(false);

        // Lấy username: ưu tiên từ hidden input, fallback từ session
        String tenDangNhap = request.getParameter("tenDangNhap");
        if ((tenDangNhap == null || tenDangNhap.isBlank()) && ses != null) {
            Object obj = ses.getAttribute("tenDangNhap");
            if (obj instanceof String) tenDangNhap = (String) obj;
        }

        if (tenDangNhap == null || tenDangNhap.isBlank()) {
            if (ses != null) ses.setAttribute("msgCapNhat", "Phiên đăng nhập hết hạn.");
           RequestDispatcher rd = request.getRequestDispatcher("thong_tin_ca_nhan.jsp");
rd.forward(request, response);

            return;
        }

        String hoTen = request.getParameter("hoten");
        String email = request.getParameter("email");
        String sdt   = request.getParameter("sodienthoai");

        // --- Validate rất nhẹ, không ảnh hưởng flow cũ ---
        if (hoTen == null) hoTen = "";
        if (email == null) email = "";
        if (sdt == null) sdt = "";

        if (email.length() > 150 || hoTen.length() > 150 || sdt.length() > 20) {
            if (ses != null) ses.setAttribute("msgCapNhat", "Dữ liệu quá dài, vui lòng kiểm tra lại.");
          RequestDispatcher rd = request.getRequestDispatcher("thong_tin_ca_nhan.jsp");
rd.forward(request, response);

            return;
        }

        // --- Update DB ---
        String sql = "UPDATE nguoidung SET hoten=?, email=?, sodienthoai=? WHERE tendangnhap=?";

        try (Connection cn = DBUtil.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, hoTen);
            ps.setString(2, email);
            ps.setString(3, sdt);
            ps.setString(4, tenDangNhap);

            int row = ps.executeUpdate();
            if (ses != null) {
                ses.setAttribute("msgCapNhat", row == 1 ? "Đã cập nhật hồ sơ." : "Không tìm thấy tài khoản để cập nhật.");
                // Cập nhật lại họ tên trong session nếu bạn đang hiển thị trên header
                ses.setAttribute("hoTen", hoTen);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (ses != null) ses.setAttribute("msgCapNhat", "Có lỗi khi lưu. Vui lòng thử lại.");
        }

        // Quay lại trang thông tin để load dữ liệu mới
       RequestDispatcher rd = request.getRequestDispatcher("thong_tin_ca_nhan.jsp");
rd.forward(request, response);

    }

    // Nếu ai đó truy cập GET nhầm, đưa về trang thông tin
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect("thong_tin_ca_nhan.jsp");
    }
}
