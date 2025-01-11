using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Services;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;

namespace BSMS.BusinessLayer.Handlers
{
    public class CreateCustomerHandler : IRequestHandler<CreateCustomerCommand, string>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IAddressRepository _addressRepository;
        private readonly IPronounRepository _pronounRepository;
        private readonly ICityRepository _cityRepository;
        private readonly ICustomerAddressRepository _customerAddressRepository;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserInfoService _userInfoService;

        public CreateCustomerHandler
            (ICustomerRepository customerRepository,
             IAddressRepository addressRepository,
             IPronounRepository pronounRepository,
             ICityRepository cityRepository,
             ICustomerAddressRepository customerAddressRepository,
             IMapper mapper, 
             IHttpContextAccessor httpContextAccessor,
             IUserInfoService userInfoService)
        {
            _customerRepository = customerRepository;
            _addressRepository = addressRepository;
            _pronounRepository = pronounRepository;
            _cityRepository = cityRepository;
            _customerAddressRepository = customerAddressRepository;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
            _userInfoService = userInfoService;
        }

        public async Task<string> Handle(CreateCustomerCommand request, CancellationToken cancellationToken)
        {
            var token = _httpContextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");

            var userInfo = await _userInfoService.GetUserInfoAsync(token);

            var customer = _mapper.Map<Customer>(userInfo);

            customer.CustomerPronounId = await _pronounRepository.GetIdByNameAsync(userInfo.PronounName);

            var address = _mapper.Map<Address>(userInfo);

            var customer_id = await _customerRepository.AddAsync(customer);

            address.AddressCityId = await _cityRepository.GetIdByNameAsync(userInfo.CityName);

            var address_id = await _addressRepository.AddAsync(address);

            var customer_address = new CustomerAddress
            {
                CustomerId = customer_id,
                AddressId = address_id
            };

            await _customerAddressRepository.AddAsync(customer_address);

            return userInfo.Sub;
        }

    }

}
