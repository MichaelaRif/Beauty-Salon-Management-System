using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Services.KeycloakServices;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers
{
    public class DeleteCustomerHandler : IRequestHandler<DeleteCustomerCommand, Unit>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserInfoService _userInfoService;

        public DeleteCustomerHandler(
             ICustomerRepository customerRepository,
             IHttpContextAccessor httpContextAccessor,
             IUserInfoService userInfoService)
        {
            _customerRepository = customerRepository;
            _httpContextAccessor = httpContextAccessor;
            _userInfoService = userInfoService;
        }

        public async Task<Unit> Handle(DeleteCustomerCommand request, CancellationToken cancellationToken)
        {
            var token = _httpContextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

            var userInfo = await _userInfoService.GetUserInfoAsync(token);

            await _customerRepository.DeleteAsync(userInfo.Sub);

            return Unit.Value;
        }
    }
}
