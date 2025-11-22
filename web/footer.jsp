<%@ page contentType="text/html; charset=UTF-8" %>
<style>
.footer {
    background: linear-gradient(135deg, #74ABE2, #5563DE);
    color: #fff;
    padding: 30px 0;
    margin-top: 30px;
}

.footer-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    text-align: center;
    background: none; 
}

.member h4 {
    margin-bottom: 8px;
    font-size: 18px;
    font-weight: bold;
}

.member p {
    margin: 4px 0;
    font-size: 14px;
}

/* Responsive cho màn hình nhỏ */
@media (max-width: 768px) {
    .footer-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<footer class="footer">
    <div class="container footer-grid">
        <div class="member">
            <h4>Đỗ Thị Huyền</h4>
            <p>📅 03/04/2004</p>
            <p>📞 033 7949 703</p>
            <p>✉️ dohuyen34204@gmail.com</p>
        </div>

        <div class="member">
            <h4>Đậu Thị Mai</h4>
            <p>📅 (26/12/2004)</p>
            <p>📞 0966 478 623 </p>
            <p>✉️ dauthimai2014@gmail.com</p>
        </div>

        <div class="member">
            <h4>Nông Thị Mai Hương</h4>
            <p>📅 14/03/2004</p>
            <p>📞 0374 805 997</p>
            <p>✉️ ntmhuong.dhti16a4hn@sv.uneti.vn.edu</p>
        </div>
        <style>
            /* ========== FOOTER ========== */
            .footer {
                background: linear-gradient(135deg, #74ABE2, #5563DE);
                color: #fff;
                padding: 30px 0;
                margin-top: 30px;
            }

            .footer-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                text-align: center;
            }

            .member h4 {
                margin-bottom: 8px;
                font-size: 18px;
                font-weight: bold;
            }

            .member p {
                margin: 4px 0;
                font-size: 14px;
            }
    <div class="member">
      <h4>Đậu Thị Mai</h4>
      <p>📅 26/12/2004</p>
      <p>📞 0966 478 623 </p>
      <p>✉️ dauthimai2014@gmail.com</p>
    </div>

            /* Responsive cho màn hình nhỏ */
            @media (max-width: 768px) {
                .footer-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </div>

</footer>

