using BSMS.BusinessLayer.Commands.Create;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Create
{
    public class CreateProductFavoriteHandler : IRequestHandler<CreateProductFavoriteCommand, int>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IProductFavoriteRepository _productFavoriteRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CreateProductFavoriteHandler(
            ICustomerRepository customerRepository,
            IProductFavoriteRepository productFavoriteRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _productFavoriteRepository = productFavoriteRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<int> Handle(CreateProductFavoriteCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var productFavorite = new ProductFavorite
            {
                CustomerId = customer_id,
                ProductId = request.ProductId
            };

            var favorite = await _productFavoriteRepository.AddAsync(productFavorite);

            return favorite;
        }
    }
}