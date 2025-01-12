using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetTopSalonReviewQuery : IRequest<IEnumerable<GetSalonReviewDto>>
    {
    }
}
