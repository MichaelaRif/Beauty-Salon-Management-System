using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateContactUsCommand : IRequest<Unit>
    {
        public string Email { get; set; } = null!;
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public string Message { get; set; } = null!;
    }
}
