using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class DeleteBundleCommand : IRequest<bool>
    {
        public int BundleId { get; set; }
    }
}
