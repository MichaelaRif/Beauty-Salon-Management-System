using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.DTOs;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers
{
    public class CreateCustomerHandler : IRequestHandler<CreateCustomerCommand, CustomerDto>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor; // dependency for user claims

        public CreateCustomerHandler(ICustomerRepository customerRepository, IMapper mapper, IHttpContextAccessor httpContextAccessor) 
        {
            _customerRepository = customerRepository;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<CustomerDto> Handle(CreateCustomerCommand request, CancellationToken cancellationToken)
        {
            var user = _httpContextAccessor.HttpContext.User; 

            var firstName = user.FindFirst(ClaimTypes.GivenName)?.Value;
            var lastName = user.FindFirst(ClaimTypes.Surname)?.Value;
            var email = user.FindFirst(ClaimTypes.Email)?.Value;
            var isGoogle = user.FindFirst("idp")?.Value == "google";
            var isApple = user.FindFirst("idp")?.Value == "apple";
            var is2fa = user.FindFirst("amr")?.Value == "2fa";

            var customer = new Customer
            {
                CustomerFn = firstName ?? request.CustomerFn,
                CustomerLn = lastName ?? request.CustomerLn,
                CustomerEmail = email ?? request.CustomerEmail,
                CustomerPn = request.CustomerPn,
                IsGoogle = isGoogle,
                IsApple = isApple,
                Is2fa = is2fa,
                CustomerRegistrationDate = DateTime.UtcNow,
                CreatedAt = DateTime.UtcNow,
                LastUpdate = DateTime.UtcNow,
                CustomerLastLogin = DateTime.UtcNow,
                CustomerDob = request.CustomerDob,
                CustomerPfp = request.CustomerPfp,
                Preferences = request.Preferences,
                Promotions = request.Promotions == null ? false : true
            };

            await _customerRepository.AddAsync(customer);

            return _mapper.Map<CustomerDto>(customer);
        }
    }

}
