using BSMS.BusinessLayer.Commands.Delete;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace BSMS.BusinessLayer.Handlers.Delete
{
    public class DeleteSalonReviewHandler : IRequestHandler<DeleteSalonReviewCommand, Unit>
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly ISalonReviewRepository _salonReviewRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public DeleteSalonReviewHandler(
            ICustomerRepository customerRepository,
            ISalonReviewRepository salonReviewRepository,
            IHttpContextAccessor httpContextAccessor)
        {
            _customerRepository = customerRepository;
            _salonReviewRepository = salonReviewRepository;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<Unit> Handle(DeleteSalonReviewCommand request, CancellationToken cancellationToken)
        {
            var keycloakId = _httpContextAccessor.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var customerId = await _customerRepository.GetByKeycloakIdAsync(keycloakId);

            await _salonReviewRepository.DeleteAsync(customerId, request.SalonReviewId);

            return Unit.Value;
        }
    }
}