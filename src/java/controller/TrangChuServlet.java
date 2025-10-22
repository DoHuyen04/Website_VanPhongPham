package controller;

import dao.SanPhamDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.SanPham;

@WebServlet("/TrangChuServlet")
public class TrangChuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO;

    @Override
    public void init() throws ServletException {
        sanPhamDAO = new SanPhamDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String loai = request.getParameter("loai");

        // 🔹 Nếu có tham số "loai" -> chỉ hiển thị loại đó
        if (loai != null && !loai.isEmpty()) {
            List<SanPham> dsTheoLoai = sanPhamDAO.laySanPhamTheoLoai(loai);
            request.setAttribute("dsSanPham", dsTheoLoai);
            request.setAttribute("loaiHienTai", loai); // Gửi tên loại để hiển thị tiêu đề

        } else {
            // 🔹 Nếu không có tham số "loai" -> hiển thị cả 2 loại (bán chạy + khuyến mại)
            List<SanPham> spBanChay = sanPhamDAO.laySanPhamTheoLoai("banchay");
            List<SanPham> spKhuyenMai = sanPhamDAO.laySanPhamTheoLoai("khuyenmai");

            request.setAttribute("spBanChay", spBanChay);
            request.setAttribute("spKhuyenMai", spKhuyenMai);
        }

        // 🔹 Lấy thông tin người dùng từ session (nếu có)
        HttpSession session = request.getSession();
        String tenDangNhap = (String) session.getAttribute("tendangnhap");
        request.setAttribute("tenDangNhap", tenDangNhap);

        // 🔹 Chuyển hướng đến trang index.jsp
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Trang chủ - Hiển thị sản phẩm bán chạy và khuyến mại";
    }
}
