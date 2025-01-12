using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetAllProductFavoritesQuery : IRequest<IEnumerable<ProductDto>>
    {
    }
}

