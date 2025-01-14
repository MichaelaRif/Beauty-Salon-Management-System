using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.All;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Get.All
{
    public class GetAllServiceCartsHandler : IRequestHandler<GetAllServiceCartsQuery, IEnumerable<ServiceDto>>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IServiceCartRepository _serviceCartRepository;
        private readonly IServiceRepository _serviceRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IMapper _mapper;

        public GetAllServiceCartsHandler(
            ICustomerRepository customerRepository,
            IServiceCartRepository serviceCartRepository,
            IServiceRepository serviceRepository,
            IHttpContextAccessor httpContextAccessor,
            IMapper mapper)
        {
            _customerRepository = customerRepository;
            _serviceCartRepository = serviceCartRepository;
            _serviceRepository = serviceRepository;
            _httpContextAccessor = httpContextAccessor;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ServiceDto>> Handle(GetAllServiceCartsQuery request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customer_id = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var serviceIdCarts = await _serviceCartRepository.GetAllAsync(customer_id);

            List<ServiceDto> serviceDtos = new List<ServiceDto>();

            if (serviceIdCarts != null)
            {
                foreach (var serviceIdCart in serviceIdCarts)
                {
                    var service = await _serviceRepository.GetByIdAsync(serviceIdCart);

                    var serviceDto = _mapper.Map<ServiceDto>(service);

                    serviceDtos.Add(serviceDto);
                }
            }

            return serviceDtos;
        }
    }
}
