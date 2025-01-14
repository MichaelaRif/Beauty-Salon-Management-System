using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateProductFavoriteCommand : IRequest<int>
    {
        public int ProductId { get; set; }
    }
}
