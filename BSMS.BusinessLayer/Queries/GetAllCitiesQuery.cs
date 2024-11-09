using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetAllCitiesQuery : IRequest<IEnumerable<CityDto>>
    {
    }
}
