package model;

public class DonHangChiTiet {
    private int id;
    private int maSanPham;
    private int soLuong;
    private double gia;

    public DonHangChiTiet() {}
    public DonHangChiTiet(int maSanPham, int soLuong, double gia) {
        this.maSanPham = maSanPham; this.soLuong = soLuong; this.gia = gia;
    }
    // getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMaSanPham() { return maSanPham; }
    public void setMaSanPham(int maSanPham) { this.maSanPham = maSanPham; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
}
