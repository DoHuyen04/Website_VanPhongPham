package model;

public class TKNganHang {
    private int id_TkNganHang;
    private int id_nguoidung;
    private String tenNganHang;
    private String soTaiKhoan;
    private String chuTaiKhoan;
    private String chiNhanh;
    private boolean macDinh;
    private String trangThai; // pending / approved

    public TKNganHang() {}

    // Getter và Setter
    public int getIdTkNganHang() {
        return id_TkNganHang;
    }

    public void setIdTkNganHang(int idTkNganHang) {
        this.id_TkNganHang = idTkNganHang;
    }

    public int getIdNguoiDung() {
        return id_nguoidung;
    }

    public void setIdNguoiDung(int idNguoiDung) {
        this.id_nguoidung = idNguoiDung;
    }

    public String getTenNganHang() {
        return tenNganHang;
    }

    public void setTenNganHang(String tenNganHang) {
        this.tenNganHang = tenNganHang;
    }

    public String getSoTaiKhoan() {
        return soTaiKhoan;
    }

    public void setSoTaiKhoan(String soTaiKhoan) {
        this.soTaiKhoan = soTaiKhoan;
    }

    public String getChuTaiKhoan() {
        return chuTaiKhoan;
    }

    public void setChuTaiKhoan(String chuTaiKhoan) {
        this.chuTaiKhoan = chuTaiKhoan;
    }

    public String getChiNhanh() {
        return chiNhanh;
    }

    public void setChiNhanh(String chiNhanh) {
        this.chiNhanh = chiNhanh;
    }

    public boolean isMacDinh() {
        return macDinh;
    }

    public void setMacDinh(boolean macDinh) {
        this.macDinh = macDinh;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
