using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class DeleteServiceFavoriteCommand : IRequest<Unit>
    {
        public int ServiceId { get; set; }
    }
}
