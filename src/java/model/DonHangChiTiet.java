package model;

public class DonHangChiTiet {
    private int id_donhangchitiet;
    private int id_sanpham;
    private int soLuong;
    private double gia;

    public DonHangChiTiet() {
    }

    public DonHangChiTiet(int id_donhangchitiet, int id_sanpham, int soLuong, double gia) {
        this.id_donhangchitiet = id_donhangchitiet;
        this.id_sanpham = id_sanpham;
        this.soLuong = soLuong;
        this.gia = gia;
    }

    public int getId_donhangchitiet() {
        return id_donhangchitiet;
    }

    public void setId_donhangchitiet(int id_donhangchitiet) {
        this.id_donhangchitiet = id_donhangchitiet;
    }

    public int getId_sanpham() {
        return id_sanpham;
    }

    public void setId_sanpham(int id_sanpham) {
        this.id_sanpham = id_sanpham;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getGia() {
        return gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }
}