using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers
{
    public class CreateServiceFavoriteHandler : IRequestHandler<CreateServiceFavoriteCommand, int>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IServiceFavoriteRepository _serviceFavoriteRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CreateServiceFavoriteHandler(
            ICustomerRepository customerRepository,
            IServiceFavoriteRepository serviceFavoriteRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _serviceFavoriteRepository = serviceFavoriteRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<int> Handle(CreateServiceFavoriteCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var serviceFavorite = new ServiceFavorite
            {
                CustomerId = customer_id,
                ServiceId = request.ServiceId
            };

            var favorite = await _serviceFavoriteRepository.AddAsync(serviceFavorite);

            return favorite;
        }
    }
}