using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetAllBundlesQuery : IRequest<IEnumerable<BundleDto>>
    {
    }
}
