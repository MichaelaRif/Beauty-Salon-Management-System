namespace BSMS.BusinessLayer.DTOs
{
    public class GetSalonReviewDto
    {
        public int SalonStarsCount { get; set; }
        public string? CustomerSalonReview { get; set; }
        public DateTime CustomerSalonReviewDate { get; set; }
        public string CustomerName { get; set; } = null!;

    }
}
