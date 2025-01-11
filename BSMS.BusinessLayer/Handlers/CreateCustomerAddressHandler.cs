using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

public class CreateCustomerAddressHandler : IRequestHandler<CreateCustomerAddressCommand, int>
{
    private readonly ICustomerRepository _customerRepository;
    private readonly IAddressRepository _addressRepository;
    private readonly ICustomerAddressRepository _customerAddressRepository;
    private readonly IMapper _mapper;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CreateCustomerAddressHandler(
        ICustomerRepository customerRepository,
        IAddressRepository addressRepository,
        ICustomerAddressRepository customerAddressRepository,
        IMapper mapper,
        IHttpContextAccessor httpContextAccessor)
    {
        _customerRepository = customerRepository;
        _addressRepository = addressRepository;
        _customerAddressRepository = customerAddressRepository;
        _mapper = mapper;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<int> Handle(CreateCustomerAddressCommand request, CancellationToken cancellationToken)
    {
        var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

        var address = await _addressRepository.GetByIdAsync(request.AddressId);

        var customerAddress = new CustomerAddress
        {
            CustomerId = customer_id,
            AddressId = address.AddressId,
            CreatedAt = DateTime.Now,
            LastUpdate = DateTime.Now
        };

        var customer_address_id = await _customerAddressRepository.AddAsync(customerAddress);

        return customer_id;
    }
}