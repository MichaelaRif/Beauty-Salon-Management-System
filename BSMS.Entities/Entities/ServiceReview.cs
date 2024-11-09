using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSMS.Domain.Entities;

[Table("service_reviews")]
[Index("ServiceId", Name = "idx_service_reviews_service_id")]
[Index("ServiceStarsCount", Name = "idx_service_reviews_service_stars_count")]
public partial class ServiceReview
{
    [Key]
    [Column("service_review_id")]
    public int ServiceReviewId { get; set; }

    [Column("service_id")]
    public int ServiceId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("service_stars_count")]
    public int ServiceStarsCount { get; set; }

    [Column("customer_service_review")]
    public string? CustomerServiceReview { get; set; }

    [Column("customer_service_review_date", TypeName = "timestamp(6) without time zone")]
    public DateTime CustomerServiceReviewDate { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("ServiceReviews")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("ServiceId")]
    [InverseProperty("ServiceReviews")]
    public virtual Service Service { get; set; } = null!;
}
