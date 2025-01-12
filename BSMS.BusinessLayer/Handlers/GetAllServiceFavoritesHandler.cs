using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers
{
    public class GetAllServiceFavoritesHandler : IRequestHandler<GetAllServiceFavoritesQuery, IEnumerable<ServiceDto>>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IServiceFavoriteRepository _serviceFavoriteRepository;
        private readonly IServiceRepository _serviceRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IMapper _mapper;

        public GetAllServiceFavoritesHandler (
            ICustomerRepository customerRepository,
            IServiceFavoriteRepository serviceFavoriteRepository,
            IServiceRepository serviceRepository,
            IHttpContextAccessor httpContextAccessor,
            IMapper mapper)
        {
            _customerRepository = customerRepository;
            _serviceFavoriteRepository = serviceFavoriteRepository;
            _serviceRepository = serviceRepository;
            _httpContextAccessor = httpContextAccessor;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ServiceDto>> Handle(GetAllServiceFavoritesQuery request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var serviceIdFavorites = await _serviceFavoriteRepository.GetAllAsync(customer_id);

            List<ServiceDto> serviceDtos = new List<ServiceDto>();

            if (serviceIdFavorites != null)
            {
                foreach (var serviceIdFavorite in serviceIdFavorites)
                {
                    var service = await _serviceRepository.GetByIdAsync(serviceIdFavorite);

                    var serviceDto = _mapper.Map<ServiceDto>(service);

                    serviceDtos.Add(serviceDto);
                }
            }

            return serviceDtos;
        }
    }
}
