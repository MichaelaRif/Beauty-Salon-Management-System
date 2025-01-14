using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteAddressCommand : IRequest<Unit>
    {
        public int AddressId { get; set; }
    }
}
