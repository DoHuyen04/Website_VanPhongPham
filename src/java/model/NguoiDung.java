package model;

public class NguoiDung {
    private int id;
    private String tenDangNhap;
    private String matKhau;
    private String hoTen;
    private String email;
    private String soDienThoai;
    private String gioiTinh;
    private String ngaySinh;     // ✔ String
    private boolean trangThai;
    private String avatarUrl;

    public NguoiDung() {}

    public NguoiDung(String username, String password, String hoten, String email, String sdt) {
        this.tenDangNhap = username;
        this.matKhau = password;
        this.hoTen = hoten;
        this.email = email;
        this.soDienThoai = sdt;
    }

    // ===== Getter – Setter =====
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTenDangNhap() { return tenDangNhap; }
    public void setTenDangNhap(String tenDangNhap) { this.tenDangNhap = tenDangNhap; }

    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public String getNgaySinh() { return ngaySinh; }           // ✔ String
    public void setNgaySinh(String ngaySinh) { this.ngaySinh = ngaySinh; }  // ✔ String

    public boolean isTrangThai() { return trangThai; }
    public void setTrangThai(boolean trangThai) { this.trangThai = trangThai; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
}
