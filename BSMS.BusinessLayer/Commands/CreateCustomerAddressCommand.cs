using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateCustomerAddressCommand : IRequest<int>
    {
        public int AddressId { get; set; }
    }
}
