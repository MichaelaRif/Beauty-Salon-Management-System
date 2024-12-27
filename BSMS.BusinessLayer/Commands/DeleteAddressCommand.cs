using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class DeleteAddressCommand : IRequest<Unit>
    {
        public int AddressId { get; set; }
    }
}
