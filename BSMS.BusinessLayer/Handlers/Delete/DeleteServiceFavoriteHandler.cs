using BSMS.BusinessLayer.Commands.Delete;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Delete
{
    public class DeleteServiceFavoriteHandler : IRequestHandler<DeleteServiceFavoriteCommand, Unit>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IServiceFavoriteRepository _serviceFavoriteRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public DeleteServiceFavoriteHandler(
            ICustomerRepository customerRepository,
            IServiceFavoriteRepository serviceFavoriteRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _serviceFavoriteRepository = serviceFavoriteRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<Unit> Handle(DeleteServiceFavoriteCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customerId = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            await _serviceFavoriteRepository.DeleteAsync(customerId, request.ServiceId);

            return Unit.Value;
        }
    }
}