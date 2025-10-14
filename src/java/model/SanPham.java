package model;

public class SanPham {
    private int id;
    private String ten;
    private String moTa;
    private double gia;
    private String danhMuc;
    private int soLuong;
    private String hinhAnh;

    public SanPham() {}

    public SanPham(int id, String ten, String moTa, double gia, String danhMuc, int soLuong, String hinhAnh) {
        this.id = id; this.ten = ten; this.moTa = moTa; this.gia = gia; this.danhMuc = danhMuc; this.soLuong = soLuong; this.hinhAnh = hinhAnh;
    }

    // getters & setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTen() { return ten; }
    public void setTen(String ten) { this.ten = ten; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
    public String getDanhMuc() { return danhMuc; }
    public void setDanhMuc(String danhMuc) { this.danhMuc = danhMuc; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
}
