using System.Net;
using System.Net.Mail;
using Microsoft.Extensions.Configuration;

namespace BSMS.BusinessLayer.Services.EmailServices
{
    public class EmailSender : IEmailSender
    {
        private readonly IConfiguration _configuration;

        public EmailSender()
        {
            _configuration = new ConfigurationBuilder()
                .AddUserSecrets<EmailSender>() 
                .Build();
        }

        public async Task SendEmailAsync(string email, string firstName, string lastName, string phoneNumber, string message)
        {
            var senderEmail = _configuration["SMTP_USERNAME"];
            var senderPassword = _configuration["SMTP_PASSWORD"];

            if (string.IsNullOrEmpty(senderEmail) || string.IsNullOrEmpty(senderPassword))
            {
                throw new InvalidOperationException("SMTP credentials are not configured.");
            }

            var smtpClient = new SmtpClient("smtp.gmail.com")
            {
                Port = 587,
                Credentials = new NetworkCredential(senderEmail, senderPassword),
                EnableSsl = true
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress(senderEmail),
                Subject = "BSMS - Contact Us",
                Body = $"Name: {firstName} {lastName}\n" +
                       $"Email: {email}\n" +
                       $"Phone Number: {phoneNumber}\n" +
                       $"Message: {message}"
            };

            mailMessage.To.Add(new MailAddress(senderEmail));

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}
