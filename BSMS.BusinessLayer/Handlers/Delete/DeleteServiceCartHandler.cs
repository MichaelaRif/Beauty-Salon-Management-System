using BSMS.BusinessLayer.Commands.Delete;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Delete
{
    public class DeleteServiceCartHandler : IRequestHandler<DeleteServiceCartCommand, Unit>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IServiceCartRepository _serviceCartRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public DeleteServiceCartHandler(
            ICustomerRepository customerRepository,
            IServiceCartRepository serviceCartRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _serviceCartRepository = serviceCartRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<Unit> Handle(DeleteServiceCartCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customerId = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            await _serviceCartRepository.DeleteAsync(customerId, request.ServiceId);

            return Unit.Value;
        }
    }
}