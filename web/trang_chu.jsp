<%@page import="model.SanPham"%>
<%@page import="java.util.List"%>
<%
    // Nếu chưa có dữ liệu từ TrangChuServlet thì tự động forward
    if (request.getAttribute("spBanChay") == null && request.getAttribute("spKhuyenMai") == null) {
        RequestDispatcher rd = request.getRequestDispatcher("TrangChuServlet");
        rd.forward(request, response);
        return;
    }
%>
<%
    String message = (String) session.getAttribute("message");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ page contentType="text/html; charset=UTF-8" %>
    <title>Trang chủ - Cửa hàng Văn phòng phẩm</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSS chung của m -->
    <link rel="stylesheet" href="css/kieu.css">

    <style>
        body{
            margin:0;
            background:#f7fbff;
            font-family:"Segoe UI",sans-serif;
        }

        /* ============ KHUNG CHUNG TRANG CHỦ ============ */
        .page-wrapper{
            max-width:1400px;
            margin:0 auto;
            padding:0 16px 40px;
        }

        /* ============ BANNER HERO SLIDER ============ */
        .hero-section{
            margin-top:20px;
        }
        .hero-slider{
            position:relative;
            width:100%;
            height:500px;
            overflow:hidden;
            border-radius:30px;
            box-shadow:0 12px 30px rgba(0,0,0,0.15);
            background:#004aad;
        }
        .hero-slide{
            position:absolute;
            inset:0;
            opacity:0;
            transition:opacity .6s ease;
            background-size:cover;
            background-position:center;
        }
        .hero-slide.active{
            opacity:1;
        }
        .hero-nav-btn{
            position:absolute;
            top:50%;
            transform:translateY(-50%);
            width:42px;
            height:42px;
            border-radius:50%;
            background:rgba(255,255,255,0.9);
            border:none;
            cursor:pointer;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:20px;
            box-shadow:0 4px 10px rgba(0,0,0,0.25);
        }
        .hero-nav-btn:hover{
            background:#ffd54f;
        }
        .hero-prev{ left:16px; }
        .hero-next{ right:16px; }

        .hero-dots{
            position:absolute;
            left:50%;
            bottom:16px;
            transform:translateX(-50%);
            display:flex;
            gap:8px;
        }
        .hero-dot{
            width:10px;
            height:10px;
            border-radius:50%;
            background:rgba(255,255,255,0.5);
            cursor:pointer;
        }
        .hero-dot.active{
            background:#ffffff;
        }

        /* ============ DANH MỤC ICON – CAROUSEL ============ */
        .category-section{
            margin-top:26px;
            background:#ffffff;
            border-radius:20px;
            padding:14px 10px;
            box-shadow:0 8px 20px rgba(0,0,0,0.06);
        }
        .category-header{
            font-weight:700;
            margin:0 0 8px 10px;
            color:#1a365d;
        }
        .category-carousel{
            display:flex;
            align-items:center;
            gap:10px;
        }
        .cat-nav-btn{
            border:none;
            background:#edf2f7;
            width:34px;
            height:34px;
            border-radius:50%;
            cursor:pointer;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:18px;
        }
        .cat-nav-btn:hover{
            background:#cbd5f5;
        }
        .category-track-wrapper{
            overflow:hidden;
            flex:1;
        }
        .category-track{
            display:flex;
            gap:12px;
            scroll-behavior:smooth;
        }
        .category-item{
            min-width:140px;
            max-width:140px;
            background:#f7fafc;
            border-radius:16px;
            padding:10px 8px;
            text-align:center;
            box-shadow:0 4px 10px rgba(0,0,0,0.05);
            cursor:pointer;
            transition:transform .2s, box-shadow .2s, background .2s;
        }
        .category-item:hover{
            transform:translateY(-3px);
            box-shadow:0 8px 18px rgba(0,0,0,0.12);
            background:#ebf8ff;
        }
        .cat-icon{
            font-size:26px;
            margin-bottom:6px;
        }
        .cat-name{
            font-size:14px;
            font-weight:600;
            color:#2d3748;
        }

        /* ============ FLASH SALE BANNER ============ */
        .flash-sale-section{
            margin-top:26px;
        }
        .flash-sale-banner{
            width:100%;
            border-radius:22px;
            overflow:hidden;
            box-shadow:0 10px 25px rgba(0,0,0,0.18);
        }
        .flash-sale-banner img{
            width:100%;
            display:block;
        }

        /* ============ MAIN GRID (SIDEBAR + SẢN PHẨM) ============ */
        .main-grid{
            display:grid;
            grid-template-columns:260px 1fr;
            gap:20px;
            align-items:flex-start;
            margin-top:32px;
        }

        @media (max-width:900px){
            .main-grid{
                grid-template-columns:1fr;
            }
        }

        .left-menu{
            background:#ffffff;
            border-radius:16px;
            padding:16px;
            box-shadow:0 6px 18px rgba(0,0,0,0.06);
        }

        .left-menu h4{
            margin-top:10px;
            margin-bottom:6px;
            color:#2b6cb0;
        }

        .left-menu ul{
            list-style:none;
            padding-left:0;
            margin:0 0 4px 0;
        }

        .left-menu li{
            margin-bottom:4px;
            font-size:14px;
        }

        .btn-loc{
            margin-top:10px;
            width:100%;
            padding:10px;
            border:none;
            border-radius:20px;
            background:#2b6cb0;
            color:#fff;
            font-weight:600;
            cursor:pointer;
        }
        .btn-loc:hover{
            background:#1e4f86;
        }

        .right-content{
            display:flex;
            flex-direction:column;
            gap:28px;
        }

        /* Thanh tìm kiếm phụ (thanh_timkiem.jsp) bao trong card */
        .search-panel-wrapper{
            background:#ffffff;
            border-radius:18px;
            padding:14px 18px;
            box-shadow:0 6px 18px rgba(0,0,0,0.06);
        }

        /* ====== CARD SẢN PHẨM ====== */
        .product-grid{
            display:grid;
            grid-template-columns:repeat(auto-fill,minmax(180px,1fr));
            gap:20px;
            margin-top:15px;
        }

        .product-card{
            background:#ffffff;
            border-radius:18px;
            padding:12px;
            text-align:center;
            box-shadow:0 4px 14px rgba(0,0,0,0.08);
            transition:transform .2s, box-shadow .2s;
        }
        .product-card:hover{
            transform:translateY(-4px);
            box-shadow:0 8px 22px rgba(0,0,0,0.15);
        }
        .product-card img{
            width:100%;
            height:160px;
            object-fit:contain;
            border-radius:12px;
            margin-bottom:8px;
        }
        .product-name{
            font-size:15px;
            font-weight:600;
            color:#1a202c;
            margin:6px 0 4px;
        }
        .product-price{
            color:#e53e3e;
            font-weight:700;
            margin-bottom:8px;
        }
        .btn-xemchitiet{
            display:inline-block;
            padding:8px 18px;
            border-radius:999px;
            background:#3182ce;
            color:#fff;
            font-size:14px;
            text-decoration:none;
            font-weight:600;
        }
        .btn-xemchitiet:hover{
            background:#225ea8;
        }

        .section-title{
            font-size:20px;
            font-weight:700;
            color:#1a202c;
            margin-bottom:6px;
        }
        .nos-product,.no-product{
            font-size:14px;
            color:#4a5568;
        }

        /* Thông báo message */
        .message-box{
            background-color:#f0f8ff;
            color:#333;
            padding:10px;
            margin:10px 0;
            border-left:5px solid #007bff;
            border-radius:6px;
        }
        .carousel-wrapper {
    width: 100%;
    max-width: 1400px;
    margin: 40px auto;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
}

.carousel-container {
    width: 100%;
    overflow: hidden;
    padding: 20px 0;
}

.carousel-track {
    display: flex;
    align-items: center;
    transition: transform 0.5s ease;
}

.carousel-item {
    min-width: 33%;
    opacity: 0.5;
    transform: scale(0.85);
    transition: 0.5s ease;
    display: flex;
    justify-content: center;
}

.carousel-item img {
    width: 95%;
    border-radius: 20px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.15);
}

.carousel-item.center {
    min-width: 34%;
    opacity: 1;
    transform: scale(1);
}

.carousel-btn {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    border: none;
    background: white;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    font-size: 26px;
    cursor: pointer;
    transition: 0.2s;
    position: absolute;
    z-index: 99;
}

.carousel-btn:hover {
    background: #f5f5f5;
}

.carousel-btn.left {
    left: 20px;
}

.carousel-btn.right {
    right: 20px;
}

    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="page-wrapper">

        <% if (message != null) { %>
            <div class="message-box"><%= message %></div>
            <%
                session.removeAttribute("message");
            %>
        <% } %>

        <!-- ================= BANNER SLIDER ================= -->
        <section class="hero-section">
            <div class="carousel-wrapper">
    <button class="carousel-btn left">❮</button>

    <div class="carousel-container">
        <div class="carousel-track">
            <!-- Slide 1 -->
            <div class="carousel-item">
                <img src="images/banner_docquyen.png" alt="">
            </div>

            <!-- Slide 2 -->
            <div class="carousel-item center">
                <img src="images/banner_sanphammoi.png" alt="">
            </div>

            <!-- Slide 3 -->
            <div class="carousel-item">
                <img src="images/banner.jpeg" alt="">
            </div>
        </div>
    </div>
    <button class="carousel-btn right">❯</button>
</div>

        </section>

        <!-- ================= DANH MỤC ICON CAROUSEL ================= -->
        <section class="category-section">
            <p class="category-header">Danh mục nổi bật</p>
            <div class="category-carousel">
                <button class="cat-nav-btn" id="catPrev">&#10094;</button>

                <div class="category-track-wrapper">
                    <div class="category-track" id="catTrack">
                        <div class="category-item">
                            <div class="cat-icon">🌱</div>
                            <div class="cat-name">Kỹ năng sống</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">📘</div>
                            <div class="cat-name">Sách tiếng Việt</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">📚</div>
                            <div class="cat-name">Sách giáo khoa</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">🌍</div>
                            <div class="cat-name">Sách ngoại ngữ</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">✏️</div>
                            <div class="cat-name">Dụng cụ học sinh</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">📑</div>
                            <div class="cat-name">Văn phòng phẩm</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">🎁</div>
                            <div class="cat-name">Quà tặng</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">🧸</div>
                            <div class="cat-name">Đồ chơi</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">🕯️</div>
                            <div class="cat-name">Trầm hương</div>
                        </div>
                        <div class="category-item">
                            <div class="cat-icon">📙</div>
                            <div class="cat-name">Văn học nước ngoài</div>
                        </div>
                    </div>
                </div>

                <button class="cat-nav-btn" id="catNext">&#10095;</button>
            </div>
        </section>

        <!-- ================= FLASH SALE BANNER ================= -->
        <section class="flash-sale-section">
            <div class="flash-sale-banner">
                <!-- Có thể thay bằng ảnh Flash Sale thật của m -->
                <img src="hinh_anh/banner.jpeg" alt="Flash Sale - Giảm sốc đến 50%">
            </div>
        </section>

        <!-- ================= MAIN: SIDEBAR + SẢN PHẨM ================= -->
        <main class="main-grid">

            <!-- LEFT MENU -->
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

            <!-- RIGHT CONTENT -->
            <section class="right-content">

                <!-- Thanh tìm kiếm phụ -->
                <div class="search-panel-wrapper">
                    <jsp:include page="thanh_timkiem.jsp" />
                </div>

                <!-- SẢN PHẨM BÁN CHẠY -->
                <section class="best-seller-section">
                    <h2 class="section-title">🔥 Sản phẩm bán chạy</h2>
                    <div class="product-grid">
                        <%
                            List<SanPham> dsBanChay = (List<SanPham>) request.getAttribute("spBanChay");
                            if (dsBanChay != null && !dsBanChay.isEmpty()) {
                                for (SanPham sp : dsBanChay) {
                        %>
                        <div class="product-card">
                            <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                            <h3 class="product-name"><%= sp.getTen()%></h3>
                            <p class="product-price"><%= sp.getGia()%> đ</p>
                            <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham()%>" class="btn-xemchitiet">Detail</a>
                        </div>
                        <%
                                }
                            } else {
                        %>
                        <p class="nos-product">Không có sản phẩm bán chạy nào.</p>
                        <%
                            }
                        %>
                    </div>
                </section>

                <!-- SẢN PHẨM KHUYẾN MẠI -->
                <section class="sale-section">
                    <h2 class="section-title">🎁 Sản phẩm khuyến mại</h2>
                    <div class="product-grid">
                        <%
                            List<SanPham> dsKhuyenMai = (List<SanPham>) request.getAttribute("spKhuyenMai");
                            if (dsKhuyenMai != null && !dsKhuyenMai.isEmpty()) {
                                for (SanPham sp : dsKhuyenMai) {
                        %>
                        <div class="product-card">
                            <img src="hinh_anh/<%= sp.getHinhAnh()%>" alt="<%= sp.getTen()%>">
                            <h3 class="product-name"><%= sp.getTen()%></h3>
                            <p class="product-price"><%= sp.getGia()%> đ</p>
                            <a href="ChiTietSanPhamServlet?id=<%= sp.getId_sanpham()%>" class="btn-xemchitiet">Detail</a>
                        </div>
                        <%
                                }
                            } else {
                        %>
                        <p class="no-product">Không có sản phẩm khuyến mại nào.</p>
                        <%
                            }
                        %>
                    </div>
                </section>

            </section>
        </main>
    </div>

    <jsp:include page="footer.jsp" />

    <!-- ========= JS: HERO SLIDER + CATEGORY CAROUSEL ========= -->
    <script>
        // HERO SLIDER
        (function () {
            const slides = document.querySelectorAll('.hero-slide');
            const dots = document.querySelectorAll('.hero-dot');
            const prev = document.getElementById('heroPrev');
            const next = document.getElementById('heroNext');
            let current = 0;
            let timer;

            function showSlide(index) {
                slides.forEach((s, i) => s.classList.toggle('active', i === index));
                dots.forEach((d, i) => d.classList.toggle('active', i === index));
                current = index;
            }

            function nextSlide() {
                const idx = (current + 1) % slides.length;
                showSlide(idx);
            }

            function prevSlide() {
                const idx = (current - 1 + slides.length) % slides.length;
                showSlide(idx);
            }

            function startAuto() {
                timer = setInterval(nextSlide, 5000);
            }
            function stopAuto() {
                clearInterval(timer);
            }

            next.addEventListener('click', () => { stopAuto(); nextSlide(); startAuto(); });
            prev.addEventListener('click', () => { stopAuto(); prevSlide(); startAuto(); });

            dots.forEach(dot => {
                dot.addEventListener('click', () => {
                    stopAuto();
                    const idx = parseInt(dot.dataset.index, 10);
                    showSlide(idx);
                    startAuto();
                });
            });

            startAuto();
        })();

        // CATEGORY CAROUSEL
        (function () {
            const track = document.getElementById('catTrack');
            const prev = document.getElementById('catPrev');
            const next = document.getElementById('catNext');

            prev.addEventListener('click', () => {
                track.scrollBy({left: -180, behavior: 'smooth'});
            });

            next.addEventListener('click', () => {
                track.scrollBy({left: 180, behavior: 'smooth'});
            });
        })();
    </script>

    <script src="js/script.js"></script>
    <script>
    let index = 1;
    const track = document.querySelector(".carousel-track");
    const items = document.querySelectorAll(".carousel-item");

    function renderCarousel() {
        items.forEach((el, i) => {
            el.classList.remove("center");
            if (i === index) {
                el.classList.add("center");
            }
        });

        track.style.transform = `translateX(calc(-${index} * 33.33%))`;
    }

    document.querySelector(".left").onclick = () => {
        index = (index === 0) ? items.length - 1 : index - 1;
        renderCarousel();
    };

    document.querySelector(".right").onclick = () => {
        index = (index === items.length - 1) ? 0 : index + 1;
        renderCarousel();
    };

    // Auto slide every 4 sec
    setInterval(() => {
        index = (index === items.length - 1) ? 0 : index + 1;
        renderCarousel();
    }, 4000);
</script>
</body>
</html>
