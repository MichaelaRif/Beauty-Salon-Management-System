using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class UpdateBundleCommand : IRequest<Unit>
    {
        public int BundleId { get; set; }
        public string BundleName { get; set; } = null!;
        public string? BundleDescription { get; set; }
        public decimal BundlePrice { get; set; }
    }
}
