/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class TKNganHang {
    private int id_TkNganHang;
    private int id_nguoidung;
    private String tenNganHang;
    private String soTaiKhoan;
    private String chuTaiKhoan;
    private String chiNhanh;
    private boolean macDinh;
    private String trangThai;

    public int getId_TkNganHang() { return id_TkNganHang; }
    public void setId_TkNganHang(int id_TkNganHang) { this.id_TkNganHang = id_TkNganHang; }

    public int getId_nguoidung() { return id_nguoidung; }
    public void setId_nguoidung(int id_nguoidung) { this.id_nguoidung = id_nguoidung; }

    public String getTenNganHang() { return tenNganHang; }
    public void setTenNganHang(String tenNganHang) { this.tenNganHang = tenNganHang; }

    public String getSoTaiKhoan() { return soTaiKhoan; }
    public void setSoTaiKhoan(String soTaiKhoan) { this.soTaiKhoan = soTaiKhoan; }

    public String getChuTaiKhoan() { return chuTaiKhoan; }
    public void setChuTaiKhoan(String chuTaiKhoan) { this.chuTaiKhoan = chuTaiKhoan; }

    public String getChiNhanh() { return chiNhanh; }
    public void setChiNhanh(String chiNhanh) { this.chiNhanh = chiNhanh; }

    public boolean isMacDinh() { return macDinh; }
    public void setMacDinh(boolean macDinh) { this.macDinh = macDinh; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public int getIdTkNganHang() { return id_TkNganHang; }
    public void setIdTkNganHang(int id) { this.id_TkNganHang = id; }

    public int getIdNguoiDung() { return id_nguoidung; }
    public void setIdNguoiDung(int id) { this.id_nguoidung = id; }
}

