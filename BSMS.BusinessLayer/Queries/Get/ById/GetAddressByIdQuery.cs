using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.ById
{
    public class GetAddressByIdQuery : IRequest<AddressDto>
    {
        public int AddressId { get; set; }
    }
}
