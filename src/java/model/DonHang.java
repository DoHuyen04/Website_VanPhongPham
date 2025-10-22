package model;

import java.util.*;

public class DonHang {
    private int id_donhang;
    private int id_nguoidung;
    private String diaChi;
    private String soDienThoai;
    private String phuongThuc;
    private double tongTien;
    private Date ngayLap;
    private List<DonHangChiTiet> chiTiet = new ArrayList<>();

    public DonHang() {}

    public int getId_donhang() {
        return id_donhang;
    }

    public void setId_donhang(int id_donhang) {
        this.id_donhang = id_donhang;
    }

    public int getId_nguoidung() {
        return id_nguoidung;
    }

    public void setId_nguoidung(int id_nguoidung) {
        this.id_nguoidung = id_nguoidung;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getPhuongThuc() {
        return phuongThuc;
    }

    public void setPhuongThuc(String phuongThuc) {
        this.phuongThuc = phuongThuc;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public Date getNgayLap() {
        return ngayLap;
    }

    public void setNgayLap(Date ngayLap) {
        this.ngayLap = ngayLap;
    }

    public List<DonHangChiTiet> getChiTiet() {
        return chiTiet;
    }

    public void setChiTiet(List<DonHangChiTiet> chiTiet) {
        this.chiTiet = chiTiet;
    }

    public int getMaNguoiDung() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    
}
