using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers
{
    public class GetAllProductFavoritesHandler : IRequestHandler<GetAllProductFavoritesQuery, IEnumerable<ProductDto>>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IProductFavoriteRepository _productFavoriteRepository;
        private readonly IProductRepository _productRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IMapper _mapper;

        public GetAllProductFavoritesHandler(
            ICustomerRepository customerRepository,
            IProductFavoriteRepository productFavoriteRepository,
            IProductRepository productRepository,
            IHttpContextAccessor httpContextAccessor,
            IMapper mapper)
        {
            _customerRepository = customerRepository;
            _productFavoriteRepository = productFavoriteRepository;
            _productRepository = productRepository;
            _httpContextAccessor = httpContextAccessor;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ProductDto>> Handle(GetAllProductFavoritesQuery request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var productFavorites = await _productFavoriteRepository.GetAllAsync(customer_id);

            List<ProductDto> productDtos = new List<ProductDto>();

            if (productFavorites != null)
            {
                foreach (var productFavorite in productFavorites)
                {
                    var product = await _productRepository.GetByIdAsync(productFavorite.ProductId);

                    var productDto = _mapper.Map<ProductDto>(product);

                    productDtos.Add(productDto);
                }
            }

            return productDtos;
        }
    }
}
