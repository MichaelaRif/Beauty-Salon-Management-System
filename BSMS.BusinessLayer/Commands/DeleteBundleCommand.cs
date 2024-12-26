using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class DeleteBundleCommand : IRequest<Unit>
    {
        public int BundleId { get; set; }
    }
}
