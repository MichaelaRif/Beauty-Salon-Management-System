using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class UpdateCustomerProfileCommand : IRequest<CustomerInfoDto>
    {
    }
}
