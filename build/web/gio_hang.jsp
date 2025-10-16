<%-- 
    Document   : gio_hang
    Created on : Oct 11, 2025, 1:55:37 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.SanPham" %>

<%
    List<Map<String,Object>> gioHang = (List<Map<String,Object>>) session.getAttribute("gioHang");
    if (gioHang == null) gioHang = new ArrayList<>();
    double tongTien = 0;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>🛍️ Giỏ hàng</title>
    <link rel="stylesheet" href="css/kieu.css">
    <style>
       body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        th {
            background: #f0f0f0;
        }
        img {
            border-radius: 6px;
        }
        .btn {
            padding: 4px 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            color: #fff;
        }
        .btn-update {
            background-color: #4CAF50;
        }
        .btn-delete {
            background-color: #e74c3c;
        }
        .btn-delete:hover {
            background-color: #c0392b;
        }
        .btn-update:hover {
            background-color: #388e3c;
        }
        .total {
            margin-top: 15px;
            text-align: right;
            font-size: 18px;
            font-weight: bold;
        }
        .empty-cart {
            color: #555;
            font-size: 18px;
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #333;
            border: 1px solid #ccc;
            padding: 6px 10px;
            border-radius: 4px;
        }
        .back-btn:hover {
            background: #f8f8f8;
        }
    </style>
</head>

<body>
    <h2>🛍️ Giỏ hàng của bạn</h2>

    <% if (gioHang.isEmpty()) { %>
        <p class="empty-cart">Giỏ hàng của bạn đang trống.</p>
        <a href="content.jsp" class="back-btn">⬅️ Tiếp tục mua sắm</a>
    <% } else { %>
        <form action="giohang" method="get">
            <input type="hidden" name="hanhDong" value="capnhatTatCa">
            <table>
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                    <th>Hành động</th>
                </tr>

                <% for (Map<String,Object> item : gioHang) {
                    SanPham sp = (SanPham) item.get("sanpham");
                    int soLuong = (int) item.get("soluong");
                    double thanhTien = sp.getGia() * soLuong;
                    tongTien += thanhTien;
                %>
                <tr>
                    <td><img src="<%= sp.getHinhAnh() %>" width="70"></td>
                    <td><%= sp.getTen() %></td>
                    <td><%= String.format("%,.0f", sp.getGia()) %> đ</td>
                    <td>
                        <form action="giohang" method="get" style="display:inline;">
                            <input type="hidden" name="hanhDong" value="capnhat">
                            <input type="hidden" name="id" value="<%= sp.getId() %>">
                            <input type="number" name="soLuong" value="<%= soLuong %>" min="1" style="width:60px;">
                            <button type="submit" class="btn btn-update">Cập nhật</button>
                        </form>
                    </td>
                    <td><%= String.format("%,.0f", thanhTien) %> đ</td>
                    <td>
                        <a href="giohang?hanhDong=xoa&id=<%= sp.getId() %>" class="btn btn-delete">Xóa</a>
                    </td>
                </tr>
                <% } %>
            </table>
        </form>

        <div class="total">
            Tổng cộng: <%= String.format("%,.0f", tongTien) %> đ
        </div>

        <a href="san_pham.jsp" class="back-btn">⬅️ Tiếp tục mua sắm</a>
    <% } %>

</body>
</html>
