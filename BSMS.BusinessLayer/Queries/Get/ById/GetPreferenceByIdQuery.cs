using BSMS.BusinessLayer.DTOs;
using MediatR;

namespace BSMS.BusinessLayer.Queries.Get.ById
{
    public class GetPreferenceByIdQuery : IRequest<PreferenceDto>
    {
        public int PreferenceId { get; set; }
    }
}
