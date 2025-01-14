using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteBundleCommand : IRequest<Unit>
    {
        public int BundleId { get; set; }
    }
}
