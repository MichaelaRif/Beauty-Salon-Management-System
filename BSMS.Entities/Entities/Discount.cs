using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("discounts")]
public partial class Discount
{
    [Key]
    [Column("discount_id")]
    public int DiscountId { get; set; }

    [Column("product_id")]
    public int ProductId { get; set; }

    [Column("discount_value")]
    [Precision(10, 2)]
    public decimal DiscountValue { get; set; }

    [Column("discount_start_date", TypeName = "timestamp without time zone")]
    public DateTime DiscountStartDate { get; set; }

    [Column("discount_end_date", TypeName = "timestamp without time zone")]
    public DateTime DiscountEndDate { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("ProductId")]
    [InverseProperty("Discounts")]
    public virtual Product Product { get; set; } = null!;
}
