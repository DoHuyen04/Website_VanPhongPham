// 🟡 Hiệu ứng menu chính
document.addEventListener('DOMContentLoaded', function () {
  const menuItems = document.querySelectorAll('.top-menu a');
  menuItems.forEach(function (item) {
    item.addEventListener('mouseover', function () {
      this.style.opacity = 0.85;
    });
    item.addEventListener('mouseout', function () {
      this.style.opacity = 1;
    });
  });
});

// 🧑‍💼 Toggle menu tài khoản
function toggleAccountMenu() {
  const menu = document.getElementById('accountMenu');
  if (menu) {
    if (menu.style.display === 'block') {
      menu.style.display = 'none';
    } else {
      menu.style.display = 'block';
    }
  }
}

// 🖱️ Ẩn menu khi click ra ngoài
window.addEventListener('click', function (e) {
  const dropdown = document.querySelector('.account-dropdown');
  const menu = document.getElementById('accountMenu');
  if (menu && dropdown && !dropdown.contains(e.target)) {
    menu.style.display = 'none';
  }
});
// ✅ GIỎ HÀNG LƯU TRONG LOCALSTORAGE
let gioHang = [];

function themGioHang(btn) {
  const card = btn.closest('.card');
  const id = card.dataset.id;
  const ten = card.dataset.ten;
  const gia = parseFloat(card.dataset.gia);
  const anh = card.dataset.anh;

  const sp = gioHang.find(x => x.id === id);
  if (sp) {
    sp.soLuong++;
  } else {
    gioHang.push({ id, ten, gia, anh, soLuong: 1 });
  }

  localStorage.setItem('gioHang', JSON.stringify(gioHang));
  capNhatSoLuongGioHang();
  alert('Đã thêm sản phẩm vào giỏ hàng!');
}

function capNhatSoLuongGioHang() {
  const count = gioHang.reduce((t, sp) => t + sp.soLuong, 0);
  const cartEl = document.querySelector('.cart');
  if (cartEl) cartEl.textContent = `🛒 Giỏ hàng (${count})`;
}

document.addEventListener('DOMContentLoaded', function() {
  const saved = localStorage.getItem('gioHang');
  if (saved) gioHang = JSON.parse(saved);
  capNhatSoLuongGioHang();
});
