using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.ById
{
    public class GetCustomerByKeycloakIdQuery : IRequest<CustomerInfoDto>
    {
    }
}
