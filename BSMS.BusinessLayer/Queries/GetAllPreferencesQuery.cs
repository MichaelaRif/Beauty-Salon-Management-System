using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries
{
    public class GetAllPreferencesQuery : IRequest<IEnumerable<PreferenceDto>>
    {
    }
}
