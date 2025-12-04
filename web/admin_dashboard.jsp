<%-- 
    Document   : admin_dashboard
    Created on : Nov 28, 2025, 9:41:42 AM
    Author     : asus
--%>

<<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #007BFF;
            color: white;
            padding: 15px 20px;
            text-align: center;
        }
        .container {
            width: 95%;
            margin: 20px auto;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .card {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .card h3 {
            margin: 10px 0;
            font-size: 22px;
            color: #333;
        }
        .card p {
            font-size: 18px;
            color: #555;
        }
        .table-container {
            margin-top: 30px;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:nth-child(even) { background-color: #f9f9f9; }
        h2 {
            margin-top: 0;
        }
    </style>
</head>
<body>
     <jsp:include page="header.jsp" />
<header>
    <h1>Trang quản trị Admin</h1>
    
</header>

<div class="container">

<!-- Thống kê nhanh -->
<div class="stats">
    <div class="card">
        <h3>Tổng số người dùng</h3>
        <p>${totalUsers}</p>
    </div>
    <div class="card">
        <h3>Đơn hàng đã đặt</h3>
        <p>${totalOrders}</p>
    </div>
    <div class="card">
        <h3>Sản phẩm bán chạy</h3>
        <p>${topProduct.name} (${topProduct.soldQuantity} bán)</p>
    </div>
    <div class="card">
        <h3>Sản phẩm đánh giá cao</h3>
        <p>${topRatedProduct.name} (${topRatedProduct.avgRating} ⭐)</p>
    </div>
</div>

<!-- Bảng sản phẩm bán nhiều -->
<div class="table-container">
    <h2>Top sản phẩm bán chạy</h2>
    <table>
        <thead>
            <tr>
                <th>STT</th>
                <th>Tên sản phẩm</th>
                <th>Số lượng bán</th>
                <th>Giá</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${topProducts}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${p.name}</td>
                    <td>${p.soldQuantity}</td>
                    <td>${p.price}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Bảng sản phẩm đánh giá cao -->
<div class="table-container">
    <h2>Top sản phẩm được đánh giá cao</h2>
    <table>
        <thead>
            <tr>
                <th>STT</th>
                <th>Tên sản phẩm</th>
                <th>Đánh giá trung bình</th>
                <th>Số lượng đánh giá</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${topRatedProducts}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${p.name}</td>
                    <td>${p.avgRating}</td>
                    <td>${p.reviewCount}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</div>
</body>
</html>
 <jsp:include page="footer.jsp" />