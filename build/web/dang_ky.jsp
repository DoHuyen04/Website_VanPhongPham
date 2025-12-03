<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo tài khoản</title>

    <style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #cce8ff, #90c8ff);
    
    display: flex;
    justify-content: center;
    align-items: flex-start;   /* căn từ trên xuống */
    
    min-height: 100vh;         /* cho phép cuộn ngoài */
    padding: 40px 0;           /* cách trên dưới */
}

/* KHUNG TRẮNG LỚN – KHÔNG CÒN THANH CUỘN TRONG */
.container {
    width: 520px;              /* rộng hơn → form không dài */
    min-height: 85vh;          /* khung cao → chứa được hết */
    background: #fff;
    padding: 40px;
    border-radius: 22px;
    box-shadow: 0 6px 22px rgba(0,0,0,0.18);

    overflow: visible !important; /* bỏ cuộn trong */
}


/* TIÊU ĐỀ */
h2 {
    text-align: center;
    margin-top: 0;
    color: #003366;
}

/* INPUT + SELECT */
input, select {
    width: 100%;
    padding: 12px;
    margin: 6px 0 16px 0;
    font-size: 15px;
    border-radius: 10px;
    border: 1px solid #d0d7e2;
    outline: none;
}

input:focus, select:focus {
    border-color: #4b8dff;
    box-shadow: 0 0 6px rgba(75, 141, 255, 0.4);
}

/* NÚT */
.btn {
    width: 100%;
    background: #ffcc00;
    color: #000;
    font-size: 16px;
    font-weight: bold;
    padding: 12px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
}

.btn:hover {
    background: #e6b800;
}

/* LINK */
.bottom-text {
    text-align: center;
    margin-top: 10px;
}

a {
    color: #005bbb;
    font-weight: bold;
}

    </style>
</head>

<body>

<div class="container">
    <h2>Tạo tài khoản</h2>

    <form action="DangKyServlet" method="post">

    <label>Tên đăng nhập *</label>
    <input type="text" name="tenDangNhap" required>

    <label>Mật khẩu *</label>
    <input type="password" name="matKhau" required>

    <label>Xác nhận mật khẩu *</label>
    <input type="password" name="xacNhanMatKhau" required>

    <label>Họ và tên *</label>
    <input type="text" name="hoTen" required>

    <label>Email *</label>
    <input type="email" name="email" required>

    <label>Số điện thoại *</label>
    <input type="text" name="soDienThoai" required>

    <label>Giới tính</label>
    <select name="gioiTinh">
        <option value="">-- Chọn --</option>
        <option value="Nam">Nam</option>
        <option value="Nữ">Nữ</option>
        <option value="Khác">Khác</option>
    </select>

    <label>Ngày sinh</label>
    <input type="date" name="ngaySinh">

    <button type="submit" class="btn">Đăng ký</button>

    <div class="bottom-text">
        Bạn đã có tài khoản?
        <a href="dang_nhap.jsp">Đăng nhập</a>
    </div>

</form>
        </div>
    </body>
</html>