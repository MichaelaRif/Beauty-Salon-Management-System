using BSMS.BusinessLayer.Commands.Create;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Create
{
    public class CreateServiceCartHandler : IRequestHandler<CreateServiceCartCommand, int>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IServiceCartRepository _serviceCartRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CreateServiceCartHandler(
            ICustomerRepository customerRepository,
            IServiceCartRepository serviceCartRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _serviceCartRepository = serviceCartRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<int> Handle(CreateServiceCartCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var serviceCart = new ServiceCart
            {
                CustomerId = customer_id,
                ServiceId = request.ServiceId
            };

            var favorite = await _serviceCartRepository.AddAsync(serviceCart);

            return favorite;
        }
    }
}