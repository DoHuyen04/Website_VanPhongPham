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

        // ✅ Lấy danh sách sản phẩm bán chạy & khuyến mãi
        List<SanPham> spBanChay = sanPhamDAO.laySanPhamTheoLoai("banchay");
        List<SanPham> spKhuyenMai = sanPhamDAO.laySanPhamTheoLoai("khuyenmai");

        request.setAttribute("spBanChay", spBanChay);
        request.setAttribute("spKhuyenMai", spKhuyenMai);

        // ✅ Lấy thông tin người dùng (nếu đã đăng nhập)
        HttpSession session = request.getSession();
        String tenDangNhap = (String) session.getAttribute("tendangnhap");
        request.setAttribute("tenDangNhap", tenDangNhap);

        // ✅ Kiểm tra nếu có tham số afterLogin=true -> hiển thị trang_chu.jsp
        String nextPage = "index.jsp";
        String afterLogin = request.getParameter("afterLogin");

        if ("true".equals(afterLogin)) {
            nextPage = "trang_chu.jsp";
        }

        request.getRequestDispatcher(nextPage).forward(request, response);
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
