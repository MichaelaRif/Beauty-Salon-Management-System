using MediatR;

namespace BSMS.BusinessLayer.Commands
{
    public class DeleteSalonReviewCommand : IRequest<Unit>
    {
        public int SalonReviewId { get; set; }
    }
}
