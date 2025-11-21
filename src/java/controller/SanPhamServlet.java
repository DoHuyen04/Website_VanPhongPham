package controller;

import dao.SanPhamDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import model.SanPham;

@WebServlet("/SanPhamServlet")
public class SanPhamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO;

    @Override
    public void init() throws ServletException {
        sanPhamDAO = new SanPhamDAO();
    }

    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");

    String tuKhoa = req.getParameter("tuKhoa");
    String sapXep = req.getParameter("sapXep");
    String[] danhMucs = req.getParameterValues("danhmuc");
    String[] gias = req.getParameterValues("gia");
    String[] loais = req.getParameterValues("loai");

    // 🔹 Lấy toàn bộ sản phẩm
    List<SanPham> ds = sanPhamDAO.layTatCa();

    // ✅ Nếu có từ khóa → tìm trên toàn bộ sản phẩm, bỏ qua filter
    if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
        ds = ds.stream()
                .filter(sp -> sp.getTen().toLowerCase().contains(tuKhoa.toLowerCase()))
                .collect(Collectors.toList());
    } else {
        // --- Chỉ áp dụng filter khi không có từ khóa ---
        // Lọc theo danh mục
        if (danhMucs != null && danhMucs.length > 0) {
            ds = ds.stream()
                    .filter(sp -> Arrays.asList(danhMucs).contains(sp.getDanhMuc()))
                    .collect(Collectors.toList());
        }

        // Lọc theo giá
        if (gias != null && gias.length > 0) {
            ds = ds.stream().filter(sp -> {
                double gia = sp.getGia();
                boolean hopLe = false;
                for (String g : gias) {
                    switch (g) {
                        case "duoi100": if (gia < 100000) hopLe = true; break;
                        case "100-200": if (gia >= 100000 && gia <= 200000) hopLe = true; break;
                        case "200-300": if (gia >= 200000 && gia <= 300000) hopLe = true; break;
                        case "300-500": if (gia >= 300000 && gia <= 500000) hopLe = true; break;
                        case "500-1000": if (gia >= 500000 && gia <= 1000000) hopLe = true; break;
                        case "tren1000": if (gia > 1000000) hopLe = true; break;
                    }
                }
                return hopLe;
            }).collect(Collectors.toList());
        }

        // Lọc theo loại
        if (loais != null && loais.length > 0) {
            List<String> danhSachLoai = Arrays.asList(loais);
            ds = ds.stream()
                    .filter(sp -> danhSachLoai.contains(sp.getLoai()) || danhSachLoai.contains("khuyenmai"))
                    .collect(Collectors.toList());
        }
    }

    // --- Sắp xếp ---
    if (sapXep != null) {
        switch (sapXep) {
            case "tang": ds.sort(Comparator.comparingDouble(SanPham::getGia)); break;
            case "giam": ds.sort(Comparator.comparingDouble(SanPham::getGia).reversed()); break;
            case "az": ds.sort(Comparator.comparing(SanPham::getTen, String.CASE_INSENSITIVE_ORDER)); break;
            case "za": ds.sort(Comparator.comparing(SanPham::getTen, String.CASE_INSENSITIVE_ORDER).reversed()); break;
        }
    }

    // ======================== PHÂN TRANG ========================
    int pageSize = 14;
    int page = 1;
    String pageParam = req.getParameter("page");
    if (pageParam != null) {
        try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
    }

    int totalProducts = ds.size();
    int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
    int start = (page - 1) * pageSize;
    int end = Math.min(start + pageSize, totalProducts);
    List<SanPham> sanPhamTrang = ds.subList(start, end);

    // Truyền sang JSP
    req.setAttribute("danhSachSanPham", sanPhamTrang);
    req.setAttribute("currentPage", page);
    req.setAttribute("totalPages", totalPages);
    req.setAttribute("tuKhoa", tuKhoa == null ? "" : tuKhoa);
    req.setAttribute("sapXepHienTai", sapXep == null ? "" : sapXep);

    RequestDispatcher rd = req.getRequestDispatcher("san_pham.jsp");
    rd.forward(req, resp);
}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
