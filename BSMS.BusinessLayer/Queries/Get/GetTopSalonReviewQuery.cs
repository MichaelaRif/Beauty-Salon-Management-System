using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get
{
    public class GetTopSalonReviewQuery : IRequest<IEnumerable<SalonReviewDto>>
    {
    }
}
