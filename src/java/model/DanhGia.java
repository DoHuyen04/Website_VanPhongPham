package model;

import java.util.Date;

public class DanhGia {
    private int id;
    private int maNguoiDung;
    private int maSanPham;
    private int sao;
    private String binhLuan;
    private Date ngay;

    public DanhGia() {}
    // getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(int maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public int getMaSanPham() { return maSanPham; }
    public void setMaSanPham(int maSanPham) { this.maSanPham = maSanPham; }
    public int getSao() { return sao; }
    public void setSao(int sao) { this.sao = sao; }
    public String getBinhLuan() { return binhLuan; }
    public void setBinhLuan(String binhLuan) { this.binhLuan = binhLuan; }
    public Date getNgay() { return ngay; }
    public void setNgay(Date ngay) { this.ngay = ngay; }
}
