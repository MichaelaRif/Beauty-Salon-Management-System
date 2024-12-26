using AutoMapper;
using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class CreateBundleHandler : IRequestHandler<CreateBundleCommand, int>
    {
        private readonly IBundleRepository _bundleRepository;
        private readonly IMapper _mapper;

        public CreateBundleHandler(IBundleRepository bundleRepository, IMapper mapper)
        {
            _bundleRepository = bundleRepository;
            _mapper = mapper;
        }

        public async Task<int> Handle(CreateBundleCommand request, CancellationToken cancellationToken)
        {
            var bundle = new Bundle
            {
                BundleName = request.BundleName,
                BundleDescription = request.BundleDescription,
                BundlePrice = request.BundlePrice,
                CreatedAt = DateTime.Now,
                LastUpdate = DateTime.Now
            };

            var entity = await _bundleRepository.AddAsync(bundle);

            return entity.BundleId;
        }
    }
}
