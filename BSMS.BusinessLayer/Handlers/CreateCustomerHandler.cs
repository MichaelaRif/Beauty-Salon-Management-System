using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Services;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers
{
    public class CreateCustomerHandler : IRequestHandler<CreateCustomerCommand, int>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IPronounRepository _pronounRepository;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserInfoService _userInfoService;

        public CreateCustomerHandler
            (ICustomerRepository customerRepository,
            IPronounRepository pronounRepository,
            IMapper mapper, IHttpContextAccessor httpContextAccessor,
            IUserInfoService userInfoService)
        {
            _customerRepository = customerRepository;
            _pronounRepository = pronounRepository;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
            _userInfoService = userInfoService;
        }

        public async Task<int> Handle(CreateCustomerCommand request, CancellationToken cancellationToken)
        {
            var token = _httpContextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

            var userInfo = await _userInfoService.GetUserInfoAsync(token);

            var customer = new Customer
            {
                CustomerKeycloakId = userInfo.Sub,
                CustomerFn = userInfo.GivenName,
                CustomerLn = userInfo.FamilyName,
                CustomerEmail = userInfo.Email,
                CustomerPn = userInfo.PhoneNumber,
                CustomerDob = userInfo.DateOfBirth,
                CustomerPronounId = await _pronounRepository.GetIdByNameAsync(userInfo.Pronoun),
                Promotions = userInfo.Promotions,
                CustomerRegistrationDate = DateTime.Now,
                CustomerLastLogin = DateTime.Now,
                CreatedAt = DateTime.Now,
                LastUpdate = DateTime.Now
            };

            var entity = await _customerRepository.AddAsync(customer);

            return entity.CustomerId;
        }

    }

}
