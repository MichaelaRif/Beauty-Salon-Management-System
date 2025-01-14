using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateProductCartCommand : IRequest<int>
    {
        public int ProductId { get; set; }
    }
}
