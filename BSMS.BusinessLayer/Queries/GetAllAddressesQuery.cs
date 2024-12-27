using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetAllAddressesQuery : IRequest<IEnumerable<AddressDto>>
    {
    }
}
