
<aside class="left-menu">
    <form action="SanPhamServlet" method="get">
        <h4>Danh mục sản phẩm</h4>
        <ul>
            <li><label><input type="checkbox" name="danhmuc" value="kynangsong"> Kỹ năng sống</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="sachtiengviet"> Sách tiếng Việt</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="sachgiaokhoa"> Sách giáo khoa - tham khảo</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="ngoai_ngu"> Sách ngoại ngữ</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="dungcu_hocsinh"> Dụng cụ học sinh</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="vanphongpham"> Văn phòng phẩm</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="quatang"> Quà tặng</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="dochoi"> Đồ chơi</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="tramhuong"> Sản phẩm trầm hương</label></li>
            <li><label><input type="checkbox" name="danhmuc" value="vanhocnuocngoai"> Văn học nước ngoài</label></li>
        </ul>

        <h4>Mức giá</h4>
        <ul>
            <li><label><input type="checkbox" name="gia" value="duoi100"> Dưới 100.000đ</label></li>
            <li><label><input type="checkbox" name="gia" value="100-200"> 100.000đ - 200.000đ</label></li>
            <li><label><input type="checkbox" name="gia" value="200-300"> 200.000đ - 300.000đ</label></li>
            <li><label><input type="checkbox" name="gia" value="300-500"> 300.000đ - 500.000đ</label></li>
            <li><label><input type="checkbox" name="gia" value="500-1000"> 500.000đ - 1.000.000đ</label></li>
            <li><label><input type="checkbox" name="gia" value="tren1000"> Trên 1.000.000đ</label></li>
        </ul>

        <h4>Sản phẩm</h4>
        <ul>
            <li><label><input type="checkbox" name="loai" value="banchay"> Bán chạy</label></li>
            <li><label><input type="checkbox" name="loai" value="khuyenmai"> Khuyến mại - Giảm giá</label></li>
        </ul>

        <button type="submit" class="btn-loc">Lọc sản phẩm</button>
    </form>
</aside>
