using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

public class CreateCustomerPreferenceHandler : IRequestHandler<CreateCustomerPreferenceCommand, Unit>
{
    private readonly ICustomerRepository _customerRepository;
    private readonly IPreferenceRepository _preferenceRepository;
    private readonly ICustomerPreferenceRepository _customerPreferenceRepository;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CreateCustomerPreferenceHandler(
        ICustomerRepository customerRepository,
        IPreferenceRepository preferenceRepository,
        ICustomerPreferenceRepository customerPreferenceRepository,
        IHttpContextAccessor httpContextAccessor)
    {
        _customerRepository = customerRepository;
        _preferenceRepository = preferenceRepository;
        _customerPreferenceRepository = customerPreferenceRepository;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<Unit> Handle(CreateCustomerPreferenceCommand request, CancellationToken cancellationToken)
    {
        var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;


        var customer = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

    
        foreach (var preferenceId in request.PreferenceIds)
        {
            var preference = await _preferenceRepository.GetByIdAsync(preferenceId);

            var customerPreference = new CustomerPreference
            {
                CustomerId = customer.CustomerId, 
                PreferenceId = preferenceId,
                CreatedAt = DateTime.Now,
                LastUpdate = DateTime.Now
            };

            await _customerPreferenceRepository.AddAsync(customerPreference);
        }

        return Unit.Value;
    }
}