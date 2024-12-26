using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class UpdateBundleHandler : IRequestHandler<UpdateBundleCommand, Unit>
    {
        private readonly IBundleRepository _bundleRepository;

        public UpdateBundleHandler(IBundleRepository bundleRepository)
        {
            _bundleRepository = bundleRepository;
        }

        public async Task<Unit> Handle(UpdateBundleCommand request, CancellationToken cancellationToken)
        {
            var existingBundle = await _bundleRepository.GetByIdAsync(request.BundleId);

            existingBundle.BundleName = request.BundleName;
            existingBundle.BundleDescription = request.BundleDescription;
            existingBundle.BundlePrice = request.BundlePrice;
            existingBundle.LastUpdate = DateTime.Now;

            await _bundleRepository.UpdateAsync(existingBundle);

            return Unit.Value;
        }
    }
}
