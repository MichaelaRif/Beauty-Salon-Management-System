using BSMS.BusinessLayer.Commands.Delete;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Delete
{
    public class DeleteProductFavoriteHandler : IRequestHandler<DeleteProductFavoriteCommand, Unit>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IProductFavoriteRepository _productFavoriteRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public DeleteProductFavoriteHandler(
            ICustomerRepository customerRepository,
            IProductFavoriteRepository productFavoriteRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _productFavoriteRepository = productFavoriteRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<Unit> Handle(DeleteProductFavoriteCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customerId = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            await _productFavoriteRepository.DeleteAsync(customerId, request.ProductId);

            return Unit.Value;
        }
    }
}