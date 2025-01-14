using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateCustomerPreferenceCommand : IRequest<Unit>
    {
        public List<int> PreferenceIds { get; set; } = new();
    }
}
