using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class CreateProductFavoriteCommand : IRequest<int>
    {
        public int ProductId { get; set; }
    }
}
