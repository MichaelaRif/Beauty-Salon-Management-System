using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("product_reviews")]
public partial class ProductReview
{
    [Key]
    [Column("product_review_id")]
    public int ProductReviewId { get; set; }

    [Column("product_id")]
    public int ProductId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("product_stars_count")]
    public int ProductStarsCount { get; set; }

    [Column("customer_product_review")]
    public string? CustomerProductReview { get; set; }

    [Column("customer_product_review_date", TypeName = "timestamp without time zone")]
    public DateTime CustomerProductReviewDate { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("ProductReviews")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("ProductId")]
    [InverseProperty("ProductReviews")]
    public virtual Product Product { get; set; } = null!;
}
