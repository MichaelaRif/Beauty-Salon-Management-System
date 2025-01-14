using BSMS.BusinessLayer.Commands.Create;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Create
{
    public class CreateProductCartHandler : IRequestHandler<CreateProductCartCommand, int>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IProductCartRepository _productCartRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CreateProductCartHandler(
            ICustomerRepository customerRepository,
            IProductCartRepository productCartRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _productCartRepository = productCartRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<int> Handle(CreateProductCartCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var productCart = new ProductCart
            {
                CustomerId = customer_id,
                ProductId = request.ProductId
            };

            var favorite = await _productCartRepository.AddAsync(productCart);

            return favorite;
        }
    }
}