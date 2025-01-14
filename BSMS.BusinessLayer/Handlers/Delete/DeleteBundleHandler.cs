using BSMS.BusinessLayer.Commands.Delete;
using BSMS.Data.Common.Interfaces;
using MediatR;

namespace BSMS.BusinessLayer.Handlers.Delete
{
    public class DeleteBundleHandler : IRequestHandler<DeleteBundleCommand, Unit>
    {
        private readonly IBundleRepository _bundleRepository;

        public DeleteBundleHandler(IBundleRepository bundleRepository)
        {
            _bundleRepository = bundleRepository;
        }

        public async Task<Unit> Handle(DeleteBundleCommand request, CancellationToken cancellationToken)
        {
            await _bundleRepository.DeleteAsync(request.BundleId);

            return Unit.Value;
        }
    }
}
