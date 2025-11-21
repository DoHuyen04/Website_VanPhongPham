package utils;

import java.io.UnsupportedEncodingException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtility {

    public static void sendEmail(String to, String subject, String messageText)
            throws MessagingException, UnsupportedEncodingException {

        final String from = "dohuyen34204@gmail.com";
        final String password = "sqvf qhxc jcwv xlds"; // App password Gmail

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        // props.put("mail.debug", "true"); // bật log nếu cần

        jakarta.mail.Session session = jakarta.mail.Session.getInstance(
            props,
            new jakarta.mail.Authenticator() {
                @Override
                protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new jakarta.mail.PasswordAuthentication(from, password);
                }
            }
        );

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from, "Cửa hàng Văn Phòng Phẩm"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setContent(messageText, "text/html; charset=UTF-8");

        Transport.send(message);
        System.out.println("✅ Gửi email thành công tới " + to);
    }
}