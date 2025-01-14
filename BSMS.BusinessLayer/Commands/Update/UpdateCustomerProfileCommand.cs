using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Commands.Update
{
    public class UpdateCustomerProfileCommand : IRequest<CustomerInfoDto>
    {
    }
}
