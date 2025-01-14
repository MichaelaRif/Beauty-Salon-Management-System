using AutoMapper;
using BSMS.BusinessLayer.Commands.Create;
using BSMS.BusinessLayer.DTOs;
using BSMS.Data.Common.Interfaces;
using BSMS.Domain.Entities;
using MediatR;

namespace BSMS.BusinessLayer.Handlers.Create
{
    public class CreateBundleHandler : IRequestHandler<CreateBundleCommand, BundleDto>
    {
        private readonly IBundleRepository _bundleRepository;
        private readonly IMapper _mapper;

        public CreateBundleHandler(IBundleRepository bundleRepository, IMapper mapper)
        {
            _bundleRepository = bundleRepository;
            _mapper = mapper;
        }

        public async Task<BundleDto> Handle(CreateBundleCommand request, CancellationToken cancellationToken)
        {
            var bundle = new Bundle
            {
                BundleName = request.BundleName,
                BundleDescription = request.BundleDescription,
                BundlePrice = request.BundlePrice,
                CreatedAt = DateTime.Now,
                LastUpdate = DateTime.Now
            };

            var bundle_created = await _bundleRepository.AddAsync(bundle);

            var bundle_dto = _mapper.Map<BundleDto>(bundle_created);

            return bundle_dto;
        }
    }
}
