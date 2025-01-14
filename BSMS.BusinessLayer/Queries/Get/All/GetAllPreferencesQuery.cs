using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.All
{
    public class GetAllPreferencesQuery : IRequest<IEnumerable<PreferenceDto>>
    {
    }
}
