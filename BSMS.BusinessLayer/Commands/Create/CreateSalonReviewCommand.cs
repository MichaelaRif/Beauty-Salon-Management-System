using MediatR;

namespace BSMS.BusinessLayer.Commands.Create
{
    public class CreateSalonReviewCommand : IRequest<int>
    {
        public int SalonStarsCount { get; set; }
        public string? CustomerSalonReview { get; set; }
    }
}
