using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("salon_reviews")]
public partial class SalonReview
{
    [Key]
    [Column("salon_review_id")]
    public int SalonReviewId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("salon_stars_count")]
    public int SalonStarsCount { get; set; }

    [Column("customer_salon_review")]
    [StringLength(255)]
    public string? CustomerSalonReview { get; set; }

    [Column("customer_salon_review_date", TypeName = "timestamp without time zone")]
    public DateTime CustomerSalonReviewDate { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("SalonReviews")]
    public virtual Customer Customer { get; set; } = null!;
}
