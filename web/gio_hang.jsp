<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.SanPham" %>

<%
    List<Map<String,Object>> gioHang = (List<Map<String,Object>>) session.getAttribute("gioHang");
    if (gioHang == null) gioHang = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="css/kieu.css">
    <style>
        body {
            font-family: Arial;
            background: #f8f8f8;
            margin: 0; padding: 20px;
        }
        .cart-container {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #333; }
        table { width:100%; border-collapse:collapse; margin-top:15px; }
        th,td {
            border-bottom:1px solid #eee;
            padding:10px; text-align:center;
        }
        th { background:#f5f5f5; }
        img { border-radius:6px; width:70px; }
        .qty-btn {
            background:#007bff; color:white; border:none;
            border-radius:4px; padding:4px 8px;
            cursor:pointer; font-size:16px;
        }
        .qty-input { width:40px; text-align:center; border:1px solid #ccc; }
        .btn-delete { color:#fff; background:#e74c3c; padding:6px 10px; border:none; border-radius:4px; cursor:pointer; }
        .total {
            margin-top:20px; text-align:right; font-size:18px; font-weight:bold;
        }
        .btn-checkout {
            background:#28a745; color:white; padding:10px 18px;
            border:none; border-radius:6px; cursor:pointer;
            font-size:16px;
        }
        .select-all {
            margin-bottom:10px;
        }
    </style>
    <script>
    function updateQuantity(id, change) {
        const qtyInput = document.getElementById('qty-' + id);
        let value = parseInt(qtyInput.value) + change;
        if (value < 1) value = 1;
        qtyInput.value = value;

        // 🧮 Lấy giá sản phẩm
        const price = parseFloat(document.querySelector('.product-check[value="'+id+'"]').dataset.price);

        // 🧾 Cập nhật lại thành tiền từng sản phẩm
        const thanhTien = price * value;
        document.getElementById('total-' + id).innerText = thanhTien.toLocaleString() + " đ";

        // 🔁 Cập nhật tổng tiền toàn bộ giỏ
        calculateTotal();
    }

    function calculateTotal() {
        let total = 0;
        const checkboxes = document.querySelectorAll('.product-check:checked');
        checkboxes.forEach(chk => {
            const price = parseFloat(chk.dataset.price);
            const qty = parseInt(document.getElementById('qty-' + chk.value).value);
            total += price * qty;
        });
        document.getElementById('tongTien').innerText = total.toLocaleString() + " đ";
    }

    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('.product-check');
        checkboxes.forEach(chk => { chk.checked = source.checked; });
        calculateTotal();
    }

    function thanhToan() {
        const selected = Array.from(document.querySelectorAll('.product-check:checked')).map(chk => chk.value);
        if (selected.length === 0) {
            alert("Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
            return;
        }
        const form = document.getElementById("checkoutForm");
        form.submit();
    }
</script>

</head>
<body>
    <div class="cart-container">
        <h2>🛒 Giỏ hàng của bạn</h2>

        <% if (gioHang.isEmpty()) { %>
            <p>Giỏ hàng trống. <a href="SanPhamServlet">Tiếp tục mua sắm</a></p>
        <% } else { %>
        <form id="checkoutForm" action="ThanhToanServlet" method="post">
            <label class="select-all">
                <input type="checkbox" onclick="toggleAll(this)"> Chọn tất cả
            </label>
            <table>
                <tr>
                    <th>Chọn</th>
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
                %>
                <tr>
                    <td><input type="checkbox" class="product-check" name="chonSp" value="<%= sp.getId_sanpham()%>" data-price="<%= sp.getGia() %>" onchange="calculateTotal()"></td>
                    <td><img src="<%= sp.getHinhAnh() %>"></td>
                    <td><%= sp.getTen() %></td>
                    <td><%= String.format("%,.0f", sp.getGia()) %> đ</td>
                    <td>
                        <button type="button" class="qty-btn" onclick="updateQuantity(<%= sp.getId_sanpham() %>,-1)">-</button>
                        <input type="text" id="qty-<%= sp.getId_sanpham() %>" name="soLuong_<%= sp.getId_sanpham() %>" value="<%= soLuong %>" class="qty-input" onchange="calculateTotal()">
                        <button type="button" class="qty-btn" onclick="updateQuantity(<%= sp.getId_sanpham() %>,1)">+</button>
                    </td>
                    <td><span id="total-<%= sp.getId_sanpham() %>"><%= String.format("%,.0f", sp.getGia() * soLuong) %> đ</span></td>
                    <td><a href="giohang?hanhDong=xoa&id=<%= sp.getId_sanpham() %>" class="btn-delete">🗑️</a></td>
                </tr>
                <% } %>
            </table>
            <div class="total">
                Tổng tiền: <span id="tongTien">0 đ</span>
            </div>
            <div style="text-align:right; margin-top:20px;">
                <button type="button" class="btn-checkout" onclick="thanhToan()">Thanh toán</button>
            </div>
        </form>
        <% } %>
    </div>
</body>
</html>
