using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class GetTopSalonReviewHandler : IRequestHandler<GetTopSalonReviewQuery, IEnumerable<GetSalonReviewDto>>
    {
        private readonly ISalonReviewRepository _salonReviewRepository;
        private readonly IMapper _mapper;

        public GetTopSalonReviewHandler(ISalonReviewRepository salonReviewRepository, IMapper mapper)
        {
            _salonReviewRepository = salonReviewRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<GetSalonReviewDto>> Handle(GetTopSalonReviewQuery request, CancellationToken cancellationToken)
        {
            var salonReviews = await _salonReviewRepository.GetTopAsync();

            return _mapper.Map<IEnumerable<GetSalonReviewDto>> (salonReviews);
        }
    }
}