using MediatR;

namespace BSMS.BusinessLayer.Commands.Delete
{
    public class DeleteSalonReviewCommand : IRequest<Unit>
    {
        public int SalonReviewId { get; set; }
    }
}
