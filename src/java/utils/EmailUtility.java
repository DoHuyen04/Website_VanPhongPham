package utils;

import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtility {
    public static void sendEmail(String to, String subject, String messageText) throws MessagingException, UnsupportedEncodingException {
        final String from = "dohuyen34204@gmail.com"; // Gmail của bạn
        final String password = "sqvf qhxc jcwv xlds"; // Mật khẩu ứng dụng Gmail

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });
        
        Message message = new MimeMessage(session);
 message.setFrom(new InternetAddress(from, "Cửa hàng Văn Phòng Phẩm"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);

        // ✅ gửi email HTML đẹp
        message.setContent(messageText, "text/html; charset=UTF-8");

        Transport.send(message);
        System.out.println("✅ Gửi email thành công tới " + to);
    }
}
