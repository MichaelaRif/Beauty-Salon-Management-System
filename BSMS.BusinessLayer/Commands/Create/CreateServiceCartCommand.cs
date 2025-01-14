using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateServiceCartCommand : IRequest<int>
    {
        public int ServiceId { get; set; }
    }
}
