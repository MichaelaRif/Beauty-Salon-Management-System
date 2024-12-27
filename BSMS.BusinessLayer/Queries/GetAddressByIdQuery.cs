using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetAddressByIdQuery : IRequest<AddressDto>
    {
        public int AddressId { get; set; }
    }
}
