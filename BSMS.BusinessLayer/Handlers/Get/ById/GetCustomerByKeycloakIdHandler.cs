using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.ById;
using BSMS.BusinessLayer.Services.KeycloakServices;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers.Get.ById
{
    public class GetCustomerByKeycloakIdHandler : IRequestHandler<GetCustomerByKeycloakIdQuery, CustomerInfoDto>
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserInfoService _userInfoService;
        private readonly IMapper _mapper;

        public GetCustomerByKeycloakIdHandler(
            IHttpContextAccessor httpContextAccessor,
            IUserInfoService userInfoService,
            IMapper mapper
        )
        {
            _httpContextAccessor = httpContextAccessor;
            _userInfoService = userInfoService;
            _mapper = mapper;
        }

        public async Task<CustomerInfoDto> Handle(GetCustomerByKeycloakIdQuery request, CancellationToken cancellationToken)
        {
            var token = _httpContextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

            var userInfo = await _userInfoService.GetUserInfoAsync(token);

            return _mapper.Map<CustomerInfoDto>(userInfo);
        }
    }
}
