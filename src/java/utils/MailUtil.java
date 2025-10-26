package util;

import java.util.Properties;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class MailUtil {

    // ✅ Hàm gửi email chung
    public static boolean sendMail(String toEmail, String subject, String htmlContent) {
        final String fromEmail = "ntmhuong.dhti16a4hn@sv.uneti.edu.vn"; // Gmail của bạn
        final String password = "zupotovjjhlohggs"; // App password (16 ký tự từ Google)

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.mime.charset", "UTF-8");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "Website VPP"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("✅ Email sent successfully to " + toEmail);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("⚠️ Error sending mail: " + e.getMessage());
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("⚠️ General error: " + e.getMessage());
            return false;
        }
    }

    // ✅ Hàm gửi mã OTP (giao diện đẹp, dùng chung với sendMail)
    public static boolean sendOTP(String toEmail, String tenNguoiNhan, String otpCode) {
        String subject = "Mã xác nhận đăng ký - Website Văn Phòng Phẩm";

        String html = """
            <div style="font-family:'Segoe UI',Arial,sans-serif;background-color:#f6f8fb;padding:20px;">
                <div style="max-width:600px;margin:auto;background:white;border-radius:10px;
                            box-shadow:0 4px 10px rgba(0,0,0,0.08);padding:30px;">
                    <h2 style="color:#2563eb;text-align:center;">XÁC NHẬN ĐĂNG KÝ TÀI KHOẢN</h2>
                    <p>Xin chào <b>%s</b>,</p>
                    <p>Mã xác nhận của bạn là:</p>
                    <div style="font-size:30px;font-weight:bold;color:#111;background:#f1f5f9;
                                text-align:center;letter-spacing:4px;padding:12px;border-radius:8px;
                                border:1px dashed #93c5fd;margin:15px 0;">
                        %s
                    </div>
                    <p>Mã OTP này có hiệu lực trong vòng <b>5 phút</b>.</p>
                    <hr style="margin:25px 0;border:none;border-top:1px solid #ddd;">
                    <p style="font-size:13px;color:#777;text-align:center;">
                        — Trân trọng,<br>
                        <b>Đội ngũ Website Văn Phòng Phẩm</b><br>
                        <a href="#" style="color:#3b82f6;text-decoration:none;">www.vanphongpham.vn</a>
                    </p>
                </div>
            </div>
            """.formatted(tenNguoiNhan, otpCode);

        return sendMail(toEmail, subject, html);
    }
}