package controller;

import dao.DonHangDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DonHang;

@WebServlet(name = "ShipperDonHang", urlPatterns = {"/ShipperDonHang"})
public class ShipperDonHang extends HttpServlet {

    private DonHangDAO dhDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<DonHang> dsDonHang = dhDAO.layTatCaDonHang();
        request.setAttribute("dsDonHang", dsDonHang);
        request.getRequestDispatcher("shipper_dashboard.jsp").forward(request, response);
    }
}
