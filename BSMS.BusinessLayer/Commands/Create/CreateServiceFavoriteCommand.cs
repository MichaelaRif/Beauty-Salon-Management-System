using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateServiceFavoriteCommand : IRequest<int>
    {
        public int ServiceId { get; set; }
    }
}
