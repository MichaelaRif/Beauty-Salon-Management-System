using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteServiceFavoriteCommand : IRequest<Unit>
    {
        public int ServiceId { get; set; }
    }
}
