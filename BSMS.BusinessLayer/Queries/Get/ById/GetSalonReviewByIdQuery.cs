using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.ById
{
    public class GetSalonReviewByIdQuery : IRequest<SalonReviewDto>
    {
        public int SalonReviewId { get; set; }
    }
}
