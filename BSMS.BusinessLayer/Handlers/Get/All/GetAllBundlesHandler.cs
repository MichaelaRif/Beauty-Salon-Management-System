using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.All;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers.Get.All
{
    public class GetAllBundlesHandler : IRequestHandler<GetAllBundlesQuery, IEnumerable<BundleDto>>
    {
        private readonly IBundleRepository _bundleRepository;
        private readonly IMapper _mapper;

        public GetAllBundlesHandler(IBundleRepository bundleRepository, IMapper mapper)
        {
            _bundleRepository = bundleRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<BundleDto>> Handle(GetAllBundlesQuery request, CancellationToken cancellationToken)
        {
            var bundles = await _bundleRepository.GetAllAsync();

            return _mapper.Map<IEnumerable<BundleDto>>(bundles);
        }
    }
}
