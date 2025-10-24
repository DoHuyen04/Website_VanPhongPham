package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/web_vanphongpham?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root"; // nếu tài khoản khác thì sửa lại
    private static final String PASSWORD = "140304"; // nếu MySQL có mật khẩu thì điền vào

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Dòng này phải có để load driver JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Kết nối MySQL thành công!");
        } catch (Exception e) {
            System.err.println("❌ Lỗi kết nối CSDL: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}
