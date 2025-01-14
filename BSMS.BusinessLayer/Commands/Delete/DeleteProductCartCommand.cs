using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteProductCartCommand : IRequest<Unit>
    {
        public int ProductId { get; set; }
    }
}
