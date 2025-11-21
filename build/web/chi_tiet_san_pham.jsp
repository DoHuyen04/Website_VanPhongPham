<%-- 
    Document   : chi_tiet_san_pham
    Created on : Oct 11, 2025, 1:55:25 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Chi tiết sản phẩm</title>
        <style>
            /* ======= TRANG CHI TIẾT SẢN PHẨM ======= */
            body {
                background: linear-gradient(135deg, #f2f6ff, #e6ebff);
                font-family: "Segoe UI", sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
            }

            .product-form {
                background: #fff;
                padding: 40px 60px;
                border-radius: 20px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                max-width: 900px;
                width: 100%;
                display: flex;
                align-items: center;
                gap: 50px;
                animation: fadeIn 0.6s ease-in-out;
            }

            .product-form img {
                width: 320px;
                height: 320px;
                object-fit: contain;
                border-radius: 12px;
                border: 1px solid #eee;
                transition: transform 0.4s ease;
            }

            .product-form img:hover {
                transform: scale(1.05);
            }

            .detail-info {
                flex: 1;
                color: #333;
            }

            .detail-info h2 {
                font-size: 26px;
                margin-bottom: 10px;
                color: #1a237e;
            }

            .detail-info p {
                font-size: 16px;
                margin: 8px 0;
            }

            .detail-info b {
                color: #333;
            }

            /* Các nút hành động */
            .btn {
                background: linear-gradient(135deg, #42a5f5, #1e88e5);
                border: none;
                color: #fff;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 15px;
                margin-top: 15px;
                margin-right: 10px;
                transition: all 0.3s ease;
                box-shadow: 0 3px 8px rgba(66, 165, 245, 0.4);
            }

            .btn:hover {
                background: linear-gradient(135deg, #ff9800, #ff5722);
                transform: translateY(-2px);
                box-shadow: 0 5px 12px rgba(255, 87, 34, 0.3);
            }
            .btn-back {
                display: inline-block;
                background: linear-gradient(135deg, #42a5f5, #1e88e5);
                color: white;
                border: none;
                padding: 7px 14px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                margin-top: 6px;
                margin-left: 10px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
            }

            .btn-back:hover {
                background: linear-gradient(135deg, #ff9800, #ff5722); /* chuyển sang cam khi hover */
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(255, 87, 34, 0.4);
            }

            /* Animation mượt */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <form action="GioHangServlet" method="post" class="product-form">
            <input type="hidden" name="id" value="${sanpham.id_sanpham}">
            <input type="hidden" name="ten" value="${sanpham.ten}">
            <input type="hidden" name="gia" value="${sanpham.gia}">
            <input type="hidden" name="moTa" value="${sanpham.moTa}">
            <input type="hidden" name="soLuong" value="${sanpham.soLuong}">
            <input type="hidden" name="danhMuc" value="${sanpham.danhMuc}">
            <input type="hidden" name="loai" value="${sanpham.loai}">
            <input type="hidden" name="hinhAnh" value="${sanpham.hinhAnh}">
            <img src="hinh_anh/${sanpham.hinhAnh}" alt="${sanpham.ten}" class="detail-img">

            <div class="detail-info">
                <h2>${sanpham.ten}</h2>
                <p><b>Giá:</b> ${sanpham.gia} VNĐ</p>
                <p><b>Mô tả:</b> ${sanpham.moTa}</p>
                <p><b>Số lượng:</b> ${sanpham.soLuong}</p>
                <p><b>Danh mục:</b> ${sanpham.danhMuc}</p>
                <p><b>Loại:</b> ${sanpham.loai}</p>
                <label>Số lượng:</label>
                <input type="number" name="soluong" value="1" min="1" style="width: 60px;">

                <button type="submit" class="btn">🛒 Thêm vào giỏ hàng</button>
                <button type="button" class="btn-back" onclick="history.back()">⬅ Quay lại</button>
            </div>
        </form>
 <jsp:include page="footer.jsp" />
    </body>
</html>
