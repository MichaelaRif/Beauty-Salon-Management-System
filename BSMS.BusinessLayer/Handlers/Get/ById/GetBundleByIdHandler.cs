using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Queries.Get.ById;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers.Get.ById
{
    public class GetBundleByIdHandler : IRequestHandler<GetBundleByIdQuery, BundleDto>
    {
        private readonly IBundleRepository _bundleRepository;
        private readonly IMapper _mapper;

        public GetBundleByIdHandler(IBundleRepository bundleRepository, IMapper mapper)
        {
            _bundleRepository = bundleRepository;
            _mapper = mapper;
        }

        public async Task<BundleDto> Handle(GetBundleByIdQuery request, CancellationToken cancellationToken)
        {
            var cities = await _bundleRepository.GetByIdAsync(request.BundleId);

            return _mapper.Map<BundleDto>(cities);
        }
    }
}
