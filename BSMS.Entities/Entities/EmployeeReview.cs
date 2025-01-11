using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("employee_reviews")]
[Index("EmployeeId", Name = "idx_employee_reviews_employee_id")]
[Index("EmployeeStarsCount", Name = "idx_employee_reviews_employee_stars_count")]
public partial class EmployeeReview
{
    [Key]
    [Column("employee_review_id")]
    public int EmployeeReviewId { get; set; }

    [Column("employee_id")]
    public int EmployeeId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("employee_stars_count")]
    public int EmployeeStarsCount { get; set; }

    [Column("customer_employee_review")]
    [StringLength(255)]
    public string? CustomerEmployeeReview { get; set; }

    [Column("customer_employee_review_date", TypeName = "timestamp without time zone")]
    public DateTime CustomerEmployeeReviewDate { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("EmployeeReviews")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("EmployeeId")]
    [InverseProperty("EmployeeReviews")]
    public virtual Employee Employee { get; set; } = null!;
}
