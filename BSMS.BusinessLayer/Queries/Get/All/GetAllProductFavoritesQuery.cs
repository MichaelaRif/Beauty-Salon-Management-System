using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.All
{
    public class GetAllProductFavoritesQuery : IRequest<IEnumerable<ProductDto>>
    {
    }
}

