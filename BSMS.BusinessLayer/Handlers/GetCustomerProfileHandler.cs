﻿using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.BusinessLayer.Services;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers
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

            var customerInfo = _mapper.Map<CustomerInfoDto>(userInfo);

            return customerInfo;
        }


    }

}
