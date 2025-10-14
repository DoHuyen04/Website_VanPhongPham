// Cập nhật số lượng giỏ hàng (nếu muốn sử dụng JS/AJAX)
document.addEventListener('DOMContentLoaded', function(){
  // ví dụ: highlight menu active
  var menuItems = document.querySelectorAll('.top-menu .menu-item');
  menuItems.forEach(function(a){
    a.addEventListener('mouseover', function(){ this.style.opacity = 0.85; });
    a.addEventListener('mouseout', function(){ this.style.opacity = 1; });
  });
});
