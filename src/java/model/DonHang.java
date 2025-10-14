package model;

import java.util.*;

public class DonHang {
    private int id;
    private int maNguoiDung;
    private String diaChi;
    private String soDienThoai;
    private String phuongThuc;
    private double tongTien;
    private Date ngayLap;
    private List<DonHangChiTiet> chiTiet = new ArrayList<>();

    public DonHang() {}

    // getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(int maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }
    public String getPhuongThuc() { return phuongThuc; }
    public void setPhuongThuc(String phuongThuc) { this.phuongThuc = phuongThuc; }
    public double getTongTien() { return tongTien; }
    public void setTongTien(double tongTien) { this.tongTien = tongTien; }
    public Date getNgayLap() { return ngayLap; }
    public void setNgayLap(Date ngayLap) { this.ngayLap = ngayLap; }
    public List<DonHangChiTiet> getChiTiet() { return chiTiet; }
    public void setChiTiet(List<DonHangChiTiet> chiTiet) { this.chiTiet = chiTiet; }
    public void themChiTiet(DonHangChiTiet ct) { this.chiTiet.add(ct); }
}
