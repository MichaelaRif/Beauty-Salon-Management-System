using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteProductFavoriteCommand : IRequest<Unit>
    {
        public int ProductId { get; set; }
    }
}
