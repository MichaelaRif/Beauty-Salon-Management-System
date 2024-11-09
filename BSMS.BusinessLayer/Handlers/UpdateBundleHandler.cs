using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.DTOs;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class UpdateBundleHandler : IRequestHandler<UpdateBundleWithIdCommand, BundleDto>
    {
        private readonly IBundleRepository _bundleRepository;

        public UpdateBundleHandler(IBundleRepository bundleRepository)
        {
            _bundleRepository = bundleRepository;
        }

        public async Task<BundleDto> Handle(UpdateBundleWithIdCommand request, CancellationToken cancellationToken)
        {
            var existingBundle = await _bundleRepository.GetByIdAsync(request.BundleId);

            existingBundle.BundleName = request.Command.BundleName;
            existingBundle.BundleDescription = request.Command.BundleDescription;
            existingBundle.BundlePrice = request.Command.BundlePrice;
            existingBundle.LastUpdate = DateTime.Now;

            await _bundleRepository.UpdateAsync(existingBundle);

            var updatedBundleDto = new BundleDto
            {
                BundleName = existingBundle.BundleName,
                BundleDescription = existingBundle.BundleDescription,
                BundlePrice = existingBundle.BundlePrice
            };

            return updatedBundleDto;
        }
    }
}
