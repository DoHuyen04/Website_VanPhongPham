package model;

import java.util.*;

public class DonHang {
    private int id_donhang;
    private int id_nguoidung;
    private String diaChi;
    private String soDienThoai;
    private String phuongThuc;
    private double tongTien;
    private Date ngayDat;
    private List<DonHangChiTiet> chiTiet = new ArrayList<>();

    // --- NEW: trạng thái đơn hàng: 'dadat' | 'dahuy' | 'hoantien'
    private String trangthai;

    public DonHang() {}

    public int getIdDonHang() {
        return id_donhang;
    }

    public void setIdDonHang(int idDonHang) {
        this.id_donhang = idDonHang;
    }

    public int getIdNguoiDung() {
        return id_nguoidung;
    }

    public void setIdNguoiDung(int idNguoiDung) {
        this.id_nguoidung = idNguoiDung;
    }

    // Giữ nguyên các getter/setter hiện có
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

    public Date getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(Date ngayDat) {
        this.ngayDat = ngayDat;
    }

    public List<DonHangChiTiet> getChiTiet() {
        return chiTiet;
    }

    public void setChiTiet(List<DonHangChiTiet> chiTiet) {
        this.chiTiet = chiTiet;
    }

    // --- FIX: không còn ném exception, trả về id_nguoidung
    public int getMaNguoiDung() {
        return id_nguoidung;
    }

    // --- NEW: getter/setter cho trạng thái
    public String getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(String trangthai) {
        this.trangthai = trangthai;
    }
}
