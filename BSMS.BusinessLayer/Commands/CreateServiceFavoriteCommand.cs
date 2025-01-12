using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateServiceFavoriteCommand : IRequest<int>
    {
        public int ServiceId { get; set; }
    }
}
