using BSMS.BusinessLayer.Commands;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers
{
    public class DeleteBundleHandler : IRequestHandler<DeleteBundleCommand, bool>
    {
        private readonly IBundleRepository _bundleRepository;

        public DeleteBundleHandler(IBundleRepository bundleRepository)
        {
            _bundleRepository = bundleRepository;
        }

        public async Task<bool> Handle(DeleteBundleCommand request, CancellationToken cancellationToken)
        {
            var deleted = await _bundleRepository.DeleteAsync(request.BundleId);

            return deleted; 
        }
    }
}
