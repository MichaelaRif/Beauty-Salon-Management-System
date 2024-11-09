using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetCityByIdQuery : IRequest<CityDto>
    {
        public int CityId { get; set; }
    }
}
