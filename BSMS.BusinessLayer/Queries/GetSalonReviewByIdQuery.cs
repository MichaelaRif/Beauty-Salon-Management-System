using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetSalonReviewByIdQuery : IRequest<SalonReviewDto>
    {
        public int SalonReviewId { get; set; }
    }
}
