using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.ById;
using BSMS.Data.Common.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Get.ById
{
    public class GetSalonReviewByIdHandler : IRequestHandler<GetSalonReviewByIdQuery, SalonReviewDto>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly ISalonReviewRepository _salonReviewRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IMapper _mapper;

        public GetSalonReviewByIdHandler(
            ICustomerRepository customerRepository,
            ISalonReviewRepository salonReviewRepository,
            IHttpContextAccessor httpContextAccessor,
            IMapper mapper)
        {
            _customerRepository = customerRepository;
            _salonReviewRepository = salonReviewRepository;
            _httpContextAccessor = httpContextAccessor;
            _mapper = mapper;
        }

        public async Task<SalonReviewDto> Handle(GetSalonReviewByIdQuery request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customerId = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var salonReview = await _salonReviewRepository.GetByIdAsync(request.SalonReviewId);

            return _mapper.Map<SalonReviewDto>(salonReview);
        }
    }
}
