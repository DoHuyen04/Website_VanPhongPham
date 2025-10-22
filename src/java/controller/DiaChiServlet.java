/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DiaChiDAO;
import dao.NguoiDungDAO;
import model.DiaChi;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;
import model.NguoiDung;

@WebServlet("/DiaChiServlet")
public class DiaChiServlet extends HttpServlet {

    private final DiaChiDAO dao = new DiaChiDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ses = req.getSession(false);
        Integer userId = (ses != null) ? (Integer) ses.getAttribute("userId") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
            return;
        }

        // === BỔ SUNG
        NguoiDung nd = (ses != null) ? (NguoiDung) ses.getAttribute("nguoiDung") : null;
        if (nd == null) {
            nd = new NguoiDungDAO().layTheoIdDayDu(userId);
        }
        req.setAttribute("nguoiDung", nd);
        // === HẾT BỔ SUNG

        String tab = req.getParameter("tab");      // ?tab=address
        String action = req.getParameter("action");// ?action=showAdd

        if ("address".equals(tab) && action == null) {
            List<DiaChi> ds = dao.findByUser(userId);
            req.setAttribute("tab", "address");
            req.setAttribute("dsDiaChi", ds);
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
            return;
        }

        if ("showAdd".equals(action)) {
            List<DiaChi> ds = dao.findByUser(userId);
            req.setAttribute("tab", "address");
            req.setAttribute("mode", "add");
            req.setAttribute("dsDiaChi", ds);
            req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
            return;
        }

        List<DiaChi> ds = dao.findByUser(userId);
        req.setAttribute("tab", "address");
        req.setAttribute("dsDiaChi", ds);
        req.getRequestDispatcher("/thong_tin_ca_nhan.jsp").forward(req, resp);
    }

    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws IOException, ServletException {

    req.setCharacterEncoding("UTF-8");

    HttpSession ses = req.getSession(false);
    Integer userId = (ses != null) ? (Integer) ses.getAttribute("userId") : null;
    if (userId == null) {
        resp.sendRedirect(req.getContextPath() + "/dang_nhap.jsp");
        return;
    }

    // lấy action từ query (form) hoặc từ JSON body (nếu là fetch)
    String action = req.getParameter("action");
    boolean isAjax = "1".equals(req.getParameter("ajax"));

    org.json.JSONObject jsonBody = null;
    if (action == null) { // có thể là fetch JSON như Bước 3
        String raw = req.getReader().lines().reduce("", (a, b) -> a + b);
        if (!raw.isEmpty()) {
            try { 
                jsonBody = new org.json.JSONObject(raw);
                action = jsonBody.optString("action", jsonBody.optString("hanhDong", null));
            } catch (Exception ignore) {}
        }
    }

    try {
        // ================= THÊM MỚI (form submit) =================
        if ("add".equals(action)) {
            DiaChi d = new DiaChi();
            d.setUserId(userId);
            d.setHoTen(req.getParameter("hoTen"));
            d.setSoDienThoai(req.getParameter("soDienThoai"));
            d.setDiaChiDuong(req.getParameter("diaChiDuong"));
            d.setXaPhuong(req.getParameter("xaPhuong"));
            d.setQuanHuyen(req.getParameter("quanHuyen"));
            d.setTinhThanh(req.getParameter("tinhThanh"));
            d.setMacDinh("on".equals(req.getParameter("macDinh")));

            int newId = dao.addAndReturnId(d); // INSERT ... RETURN_GENERATED_KEYS
            d.setId(newId);

            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().printf(
                    "{\"success\":true,\"item\":{\"id\":%d,\"hoTen\":\"%s\",\"soDienThoai\":\"%s\",\"diaChiDuong\":\"%s\",\"xaPhuong\":\"%s\",\"quanHuyen\":\"%s\",\"tinhThanh\":\"%s\",\"macDinh\":%s}}",
                    d.getId(), esc(d.getHoTen()), esc(d.getSoDienThoai()),
                    esc(d.getDiaChiDuong()), esc(d.getXaPhuong()),
                    esc(d.getQuanHuyen()), esc(d.getTinhThanh()),
                    d.isMacDinh() ? "true" : "false"
                );
                return;
            } else {
                resp.sendRedirect(req.getContextPath() + "/DiaChiServlet?tab=address");
                return;
            }
        }

        // ================= CẬP NHẬT ĐỊA CHỈ (fetch JSON — KHÔNG có 'loai') =================
        if ("capnhat_dia_chi".equals(action)) {
            resp.setContentType("application/json;charset=UTF-8");

            if (jsonBody == null) {
                resp.getWriter().write("{\"ok\":false,\"message\":\"Thiếu dữ liệu JSON\"}");
                return;
            }

            int id = jsonBody.getInt("id");
            String hoTen = jsonBody.getString("ten");
            String sdt = jsonBody.getString("sdt");
            String kv = jsonBody.getString("kv"); // "Tỉnh/Thành, Quận/Huyện, Xã/Phường"
            String[] parts = kv.split("\\s*,\\s*");
            String tinhThanh = parts.length > 0 ? parts[0] : "";
            String quanHuyen = parts.length > 1 ? parts[1] : "";
            String xaPhuong = parts.length > 2 ? parts[2] : "";
            String diaChiDuong = jsonBody.getString("diachi");
            boolean macDinh = jsonBody.optInt("macdinh", 0) == 1;

            DiaChi d = new DiaChi();
            d.setId(id);
            d.setUserId(userId);                 // map theo cột user_id
            d.setHoTen(hoTen);                   // ho_ten
            d.setSoDienThoai(sdt);               // so_dien_thoai
            d.setDiaChiDuong(diaChiDuong);       // dia_chi_duong
            d.setXaPhuong(xaPhuong);             // xa_phuong
            d.setQuanHuyen(quanHuyen);           // quan_huyen
            d.setTinhThanh(tinhThanh);           // tinh_thanh
            d.setMacDinh(macDinh);               // mac_dinh

            boolean ok = dao.updateForUser(d, userId);   // WHERE id=? AND user_id=?
            if (ok && macDinh) {
                dao.clearDefaultOthers(userId, id);      // bỏ mặc định các dòng khác của user
            }

            if (ok) {
                org.json.JSONObject out = new org.json.JSONObject();
                org.json.JSONObject a = new org.json.JSONObject();
                a.put("id", d.getId());
                a.put("hoTen", d.getHoTen());
                a.put("soDienThoai", d.getSoDienThoai());
                a.put("diaChiDuong", d.getDiaChiDuong());
                a.put("xaPhuong", d.getXaPhuong());
                a.put("quanHuyen", d.getQuanHuyen());
                a.put("tinhThanh", d.getTinhThanh());
                a.put("macDinh", d.isMacDinh());

                out.put("ok", true);
                out.put("address", a);
                resp.getWriter().write(out.toString());
            } else {
                resp.getWriter().write("{\"ok\":false,\"message\":\"Không cập nhật được địa chỉ\"}");
            }
            return;
        }

        // ================= THIẾT LẬP MẶC ĐỊNH =================
        if ("setDefault".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.setDefault(userId, id); // UPDATE ... SET mac_dinh=1; clearDefaultOthers(...)
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print("{\"success\":true}");
            return;
        }

        // ================= XÓA =================
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.delete(userId, id); // DELETE FROM dia_chi WHERE id=? AND user_id=?
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print("{\"success\":true}");
            return;
        }

    } catch (Exception ex) {
        if (isAjax || "capnhat_dia_chi".equals(action)) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().printf("{\"success\":false,\"message\":\"%s\"}", esc(ex.getMessage()));
            return;
        }
        throw new ServletException(ex);
    }
    resp.sendRedirect(req.getContextPath() + "/DiaChiServlet?tab=address");
}
    private String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
