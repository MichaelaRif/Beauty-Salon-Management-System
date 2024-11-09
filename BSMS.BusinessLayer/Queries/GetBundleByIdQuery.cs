using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetBundleByIdQuery : IRequest<BundleDto>
    {
        public int BundleId { get; set; }
    }
}
