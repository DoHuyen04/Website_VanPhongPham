/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class DiaChi {
    private int id;
    private int userId;
    private String hoTen;
    private String soDienThoai;
    private String diaChiDuong;
    private String xaPhuong;
    private String quanHuyen;
    private String tinhThanh;
    private boolean macDinh;

    // Getters + Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getDiaChiDuong() { return diaChiDuong; }
    public void setDiaChiDuong(String diaChiDuong) { this.diaChiDuong = diaChiDuong; }

    public String getXaPhuong() { return xaPhuong; }
    public void setXaPhuong(String xaPhuong) { this.xaPhuong = xaPhuong; }

    public String getQuanHuyen() { return quanHuyen; }
    public void setQuanHuyen(String quanHuyen) { this.quanHuyen = quanHuyen; }

    public String getTinhThanh() { return tinhThanh; }
    public void setTinhThanh(String tinhThanh) { this.tinhThanh = tinhThanh; }

    public boolean isMacDinh() { return macDinh; }
    public void setMacDinh(boolean macDinh) { this.macDinh = macDinh; }
}

