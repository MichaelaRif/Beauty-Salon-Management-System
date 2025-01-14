using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.ById
{
    public class GetBundleByIdQuery : IRequest<BundleDto>
    {
        public int BundleId { get; set; }
    }
}
