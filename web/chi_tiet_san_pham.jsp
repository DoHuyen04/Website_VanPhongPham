<%-- 
    Document   : chi_tiet_san_pham
    Created on : Oct 11, 2025, 1:55:25 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.DanhGia"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
                flex-direction: column; /* để phía dưới còn hiện phần đánh giá */
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
                margin-bottom: 24px;
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
                background: linear-gradient(135deg, #ff9800, #ff5722);
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(255, 87, 34, 0.4);
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* ========== HIỂN THỊ ĐÁNH GIÁ ========== */
            .review-wrapper{
                width: 100%;
                max-width: 900px;
                background:#ffffff;
                border-radius:16px;
                padding:20px 24px 24px;
                box-shadow:0 8px 20px rgba(0,0,0,0.06);
            }

            .review-wrapper h3{
                margin-top:0;
                margin-bottom:12px;
                font-size:20px;
                color:#1a237e;
            }

            .review-list{
                margin-top:10px;
                display:flex;
                flex-direction:column;
                gap:10px;
            }

            .review-item{
                border:1px solid #eee;
                border-radius:10px;
                padding:8px 10px;
                background:#fafafa;
            }

            .review-header{
                display:flex;
                justify-content:space-between;
                font-size:13px;
                margin-bottom:4px;
            }

            .review-header span{
                letter-spacing:1px;
            }

            .review-body p{
                margin:0 0 4px;
                font-size:14px;
            }

            .review-body small{
                font-size:12px;
                color:#666;
            }
            .review-stars{
                color:#5563DE;
                font-size: 14px;
            }
            .review-images{
                margin:8px 0;
            }

            .review-img{
                width:80px;
                height:80px;
                object-fit:cover;
                border-radius:8px;
                border:1px solid #e5e7eb;
            }
            /* ==== TỔNG QUAN ĐÁNH GIÁ (GIỐNG SHOPEE) ==== */
            .review-summary{
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:24px;
                padding:16px 18px;
                margin-bottom:12px;
                background:#fff7f3;
                border-radius:12px;
                border:1px solid #ffe0cc;
            }

            .review-summary-left{
                text-align:center;
                min-width:150px;
            }

            .review-summary-left .score-number{
                font-size:32px;
                font-weight:700;
                color:#ff4d00;
            }

            .review-summary-left .score-text{
                font-size:14px;
                color:#555;
            }

            .review-summary-left .score-stars{
                margin-top:4px;
                color:#ff9800;
                font-size:18px;
            }

            .review-summary-left .score-count{
                margin-top:4px;
                font-size:13px;
                color:#777;
            }

            .review-summary-right{
                display:flex;
                flex-wrap:wrap;
                gap:8px;
            }

            .filter-pill{
                padding:6px 10px;
                border-radius:999px;
                border:1px solid #ddd;
                background:#fff;
                font-size:13px;
                cursor:pointer;
                transition:all .2s;
            }

            .filter-pill.active{
                border-color:#ee4d2d;
                color:#ee4d2d;
                background:#fff3ee;
            }

        </style>
    </head>
    <body>

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

        <div class="review-wrapper">
            <h3>Đánh giá của khách hàng</h3>

            <c:if test="${not empty dsDanhGia}">

                <!-- ====== TỔNG QUAN ĐÁNH GIÁ (GIỐNG SHOPEE) ====== -->
                <div class="review-summary">
                    <div class="review-summary-left">
                        <div class="score-number">
                            <fmt:formatNumber value="${avgRating}" type="number"
                                              maxFractionDigits="1" minFractionDigits="1"/>
                        </div>
                        <div class="score-text">trên 5</div>

                        <!-- Shopee cũng hiển thị 5 sao đỏ luôn -->
                        <div class="score-stars">
                            ★★★★★
                        </div>

                        <div class="score-count">
                            <c:out value="${totalRating}"/> đánh giá
                        </div>
                    </div>

                    <div class="review-summary-right">
                        <span class="filter-pill active" data-filter="all">Tất cả</span>

                        <span class="filter-pill" data-filter="star" data-star="5">
                            5 Sao (<c:out value="${count5}"/>)
                        </span>
                        <span class="filter-pill" data-filter="star" data-star="4">
                            4 Sao (<c:out value="${count4}"/>)
                        </span>
                        <span class="filter-pill" data-filter="star" data-star="3">
                            3 Sao (<c:out value="${count3}"/>)
                        </span>
                        <span class="filter-pill" data-filter="star" data-star="2">
                            2 Sao (<c:out value="${count2}"/>)
                        </span>
                        <span class="filter-pill" data-filter="star" data-star="1">
                            1 Sao (<c:out value="${count1}"/>)
                        </span>

                        <span class="filter-pill" data-filter="comment">
                            Có bình luận (<c:out value="${countComment}"/>)
                        </span>
                        <span class="filter-pill" data-filter="image">
                            Có hình ảnh (<c:out value="${countImage}"/>)
                        </span>
                    </div>

                </div>

                <!-- ====== DANH SÁCH ĐÁNH GIÁ CHI TIẾT ====== -->
                <div class="review-list">
                    <c:forEach var="dg" items="${dsDanhGia}">
                        <div class="review-item"
                             data-stars="${dg.sao}"
                             data-has-comment="${not empty dg.binhLuan}"
                             data-has-image="${not empty dg.hinhAnh}">
                            <div class="review-header">
                                <strong>Người dùng #${dg.idNguoiDung}</strong>
                                <span class="review-stars">
                                    <c:forEach begin="1" end="${dg.sao}" var="i">★</c:forEach>
                                    <c:forEach begin="1" end="${5 - dg.sao}" var="i">☆</c:forEach>
                                    </span>
                                </div>

                                <div class="review-body">
                                    <p>${dg.binhLuan}</p>

                                <!-- HÌNH ẢNH ĐÁNH GIÁ (nếu có) -->
                                <c:if test="${not empty dg.hinhAnh}">
                                    <div class="review-images">
                                        <img src="uploads/review/${dg.hinhAnh}"
                                             alt="Hình ảnh đánh giá"
                                             class="review-img" />

                                    </div>
                                </c:if>

                                <small>${dg.ngay}</small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty dsDanhGia}">
                <p>Chưa có đánh giá nào cho sản phẩm này.</p>
            </c:if>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const pills = document.querySelectorAll('.filter-pill');
                const items = document.querySelectorAll('.review-item');

                function applyFilter(filter, star) {
                    items.forEach(function (item) {
                        const itemStar = item.getAttribute('data-stars');
                        const hasComment = item.getAttribute('data-has-comment') === 'true';
                        const hasImage = item.getAttribute('data-has-image') === 'true';

                        let show = true;

                        if (filter === 'star') {
                            show = (itemStar === star);
                        } else if (filter === 'comment') {
                            show = hasComment;
                        } else if (filter === 'image') {
                            show = hasImage;
                        } else {
                            // 'all'
                            show = true;
                        }

                        item.style.display = show ? 'block' : 'none';
                    });
                }

                pills.forEach(function (pill) {
                    pill.addEventListener('click', function () {
                        // đổi active
                        pills.forEach(function (p) {
                            p.classList.remove('active');
                        });
                        pill.classList.add('active');

                        const filter = pill.getAttribute('data-filter');
                        const star = pill.getAttribute('data-star');

                        applyFilter(filter, star);
                    });
                });
            });
        </script>

    </body>
</html>
