using BSMS.BusinessLayer.Commands.Create;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

public class CreateCustomerPreferenceHandler : IRequestHandler<CreateCustomerPreferenceCommand, Unit>
{
    private readonly ICustomerRepository _customerRepository;
    private readonly ICustomerPreferenceRepository _customerPreferenceRepository;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CreateCustomerPreferenceHandler(
        ICustomerRepository customerRepository,
        ICustomerPreferenceRepository customerPreferenceRepository,
        IHttpContextAccessor httpContextAccessor)
    {
        _customerRepository = customerRepository;
        _customerPreferenceRepository = customerPreferenceRepository;
        _httpContextAccessor = httpContextAccessor;
    }

    public async Task<Unit> Handle(CreateCustomerPreferenceCommand request, CancellationToken cancellationToken)
    {
        var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

        foreach (var preferenceId in request.PreferenceIds)
        {
            var customerPreference = new CustomerPreference
            {
                CustomerId = customer_id, 
                PreferenceId = preferenceId
            };

            await _customerPreferenceRepository.AddAsync(customerPreference);
        }

        return Unit.Value;
    }
}