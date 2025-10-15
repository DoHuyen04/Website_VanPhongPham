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
