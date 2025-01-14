using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteServiceCartCommand : IRequest<Unit>
    {
        public int ServiceId { get; set; }
    }
}
