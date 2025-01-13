namespace BSMS.BusinessLayer.Services.EmailServices
{
    public interface IEmailSender
    {
        Task SendEmailAsync(string email, string firstName, string lastName, string phoneNumber, string message);
    }
}
