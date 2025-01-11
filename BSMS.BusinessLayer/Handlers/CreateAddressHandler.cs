using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;

public class CreateAddressHandler : IRequestHandler<CreateAddressCommand, int>
{
    private readonly IAddressRepository _addressRepository;
    private readonly IMapper _mapper;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CreateAddressHandler(
        IAddressRepository addressRepository,
        IMapper mapper,
        IHttpContextAccessor httpContextAccessor)
    {
        _addressRepository = addressRepository;
        _mapper = mapper;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<int> Handle(CreateAddressCommand request, CancellationToken cancellationToken)
    {
        var address = new Address
        {
            AddressStreet = request.AddressStreet,
            AddressBuilding = request.AddressBuilding,
            AddressFloor = request.AddressFloor,
            AddressNotes = request.AddressNotes,
            AddressCityId = request.City,
            CreatedAt = DateTime.Now,
            LastUpdate = DateTime.Now
        };

        var address_id = await _addressRepository.AddAsync(address);

        return address_id;
    }
}