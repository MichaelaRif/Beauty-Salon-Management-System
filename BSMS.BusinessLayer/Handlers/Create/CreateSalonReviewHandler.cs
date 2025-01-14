using BSMS.BusinessLayer.Commands.Create;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Create
{
    public class CreateSalonReviewHandler : IRequestHandler<CreateSalonReviewCommand, int>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly ISalonReviewRepository _salonReviewRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CreateSalonReviewHandler(
            ICustomerRepository customerRepository,
            ISalonReviewRepository salonReviewRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _salonReviewRepository = salonReviewRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<int> Handle(CreateSalonReviewCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customerId = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            var salonReview = new SalonReview
            {
                CustomerId = customerId,
                SalonStarsCount = request.SalonStarsCount,
                CustomerSalonReview = request.CustomerSalonReview
            };

            var salonReviewId = await _salonReviewRepository.AddAsync(salonReview);

            return salonReviewId;
        }
    }
}