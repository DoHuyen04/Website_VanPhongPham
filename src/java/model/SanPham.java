package model;

public class SanPham {
    private int id_sanpham;
    private String ten;
    private String moTa;
    private double gia;
    private String danhMuc;
    private int soLuong;
    private String hinhAnh;
   private String loai; 

    public SanPham() {}

    public SanPham(int id, String ten, String moTa, double gia, String danhMuc, int soLuong, String hinhAnh, String loai) {
        this.id_sanpham = id; this.ten = ten; this.moTa = moTa; this.gia = gia; this.danhMuc = danhMuc; this.soLuong = soLuong; this.hinhAnh = hinhAnh;this.loai = loai;
    }

    // getters & setters
    public int getId_sanpham() { return id_sanpham; }
    public void setId_sanpham(int id) { this.id_sanpham = id; }
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
    public String getLoai() { return  loai;}
    public void setLoai(String loai) { this.loai = loai; }
}
