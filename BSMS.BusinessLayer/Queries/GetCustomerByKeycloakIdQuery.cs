using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetCustomerByKeycloakIdQuery : IRequest<CustomerInfoDto>
    {
    }
}
