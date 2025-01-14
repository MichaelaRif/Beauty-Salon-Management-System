using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateCustomerAddressCommand : IRequest<int>
    {
        public int AddressId { get; set; }
    }
}
