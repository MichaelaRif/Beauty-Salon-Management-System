using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.All;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Get.All
{
    public class GetAllProductCartHandler : IRequestHandler<GetAllProductCartQuery, IEnumerable<ProductDto>>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IProductCartRepository _productCartRepository;
        private readonly IProductRepository _productRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IMapper _mapper;

        public GetAllProductCartHandler(
            ICustomerRepository customerRepository,
            IProductCartRepository productCartRepository,
            IProductRepository productRepository,
            IHttpContextAccessor httpContextAccessor,
            IMapper mapper)
        {
            _customerRepository = customerRepository;
            _productCartRepository = productCartRepository;
            _productRepository = productRepository;
            _httpContextAccessor = httpContextAccessor;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ProductDto>> Handle(GetAllProductCartQuery request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var productCarts = await _productCartRepository.GetAllAsync(customer_id);

            List<ProductDto> productDtos = new List<ProductDto>();

            if (productCarts != null)
            {
                foreach (var productCart in productCarts)
                {
                    var product = await _productRepository.GetByIdAsync(productCart.ProductId);

                    var productDto = _mapper.Map<ProductDto>(product);

                    productDtos.Add(productDto);
                }
            }

            return productDtos;
        }
    }
}
