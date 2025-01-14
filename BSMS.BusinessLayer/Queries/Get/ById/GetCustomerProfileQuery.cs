using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.ById
{
    public class GetCustomerProfileQuery : IRequest<CustomerInfoDto>
    {
    }
}
