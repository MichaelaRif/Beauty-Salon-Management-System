using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Services;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers
{
    public class UpdateCustomerProfileHandler : IRequestHandler<UpdateCustomerProfileCommand, CustomerInfoDto>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IPronounRepository _pronounRepository;
        private readonly IAddressRepository _addressRepository;
        private readonly ICityRepository _cityRepository;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserInfoService _userInfoService;

        public UpdateCustomerProfileHandler
            (ICustomerRepository customerRepository,
             IPronounRepository pronounRepository,
             IAddressRepository addressRepository,
             ICityRepository cityRepository,
             IMapper mapper,
             IHttpContextAccessor httpContextAccessor,
             IUserInfoService userInfoService)
        {
            _customerRepository = customerRepository;
            _pronounRepository = pronounRepository;
            _addressRepository = addressRepository;
            _cityRepository = cityRepository;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
            _userInfoService = userInfoService;
        }


        public async Task<CustomerInfoDto> Handle(UpdateCustomerProfileCommand request, CancellationToken cancellationToken)
        {
            var token = _httpContextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

            var updatedUserInfo = await _userInfoService.GetUserInfoAsync(token);

            var updatedPronounId = await _pronounRepository.GetIdByNameAsync(updatedUserInfo.PronounName);

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(updatedUserInfo.Sub);

            var updatedCustomer = new Customer
            {
                CustomerId = customer_id,
                CustomerFn = updatedUserInfo.GivenName,
                CustomerLn = updatedUserInfo.FamilyName,
                CustomerEmail = updatedUserInfo.Email,
                CustomerPn = updatedUserInfo.PhoneNumber,
                CustomerDob = updatedUserInfo.DateOfBirth,
                CustomerPronounId = updatedPronounId
            };

            var updatedCustomerAddress = _mapper.Map<Address>(updatedUserInfo);

            var updatedCustomerInfo = await _customerRepository.UpdateAsync(updatedCustomer);

            updatedCustomerAddress.AddressCityId = await _cityRepository.GetIdByNameAsync(updatedUserInfo.CityName);

            var updatedCustomerAddressInfo = await _addressRepository.UpdateAsync(updatedCustomerAddress, customer_id);


            var customerProfileDto = new CustomerInfoDto
            {
                Customer = _mapper.Map<CustomerDto>(updatedUserInfo),
                Address = _mapper.Map<AddressDto>(updatedUserInfo)
            };

            return customerProfileDto;
        }
    }
}
