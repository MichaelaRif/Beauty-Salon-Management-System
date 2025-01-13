using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class DeleteProductFavoriteCommand : IRequest<Unit>
    {
        public int ProductId { get; set; }
    }
}
