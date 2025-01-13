using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Services.EmailServices;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class CreateContactUsHandler : IRequestHandler<CreateContactUsCommand, Unit>
    {
        private readonly IEmailSender _emailSender;

        public CreateContactUsHandler(IEmailSender emailSender)
        {
            _emailSender = emailSender;
        }

        public async Task<Unit> Handle(CreateContactUsCommand request, CancellationToken cancellationToken)
        {
            var email = request.Email;
            var firstName = request.FirstName;
            var lastName = request.LastName;
            var phoneNumber = request.PhoneNumber;
            var message = request.Message;

            await _emailSender.SendEmailAsync(email, firstName, lastName, phoneNumber, message);

            return Unit.Value;
        }
    }

}
