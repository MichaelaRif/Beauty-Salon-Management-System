using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.ById;
using BSMS.BusinessLayer.Services.KeycloakServices;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers.Get.ById
{
    public class GetCustomerProfileHandler : IRequestHandler<GetCustomerProfileQuery, CustomerInfoDto>
    {
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserInfoService _userInfoService;

        public GetCustomerProfileHandler
            (IMapper mapper,
             IHttpContextAccessor httpContextAccessor,
             IUserInfoService userInfoService)
        {
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
            _userInfoService = userInfoService;
        }

        public async Task<CustomerInfoDto> Handle(GetCustomerProfileQuery request, CancellationToken cancellationToken)
        {
            var token = _httpContextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

            var userInfo = await _userInfoService.GetUserInfoAsync(token);

            var customerInfo = new CustomerInfoDto
            {
                Customer = _mapper.Map<CustomerDto>(userInfo),
                Address = _mapper.Map<AddressDto>(userInfo)
            };

            return customerInfo;
        }


    }

}
