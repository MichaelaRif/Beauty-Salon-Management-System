using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("product_categories")]
public partial class ProductCategory
{
    [Key]
    [Column("product_category_id")]
    public int ProductCategoryId { get; set; }

    [Column("product_category")]
    [StringLength(255)]
    public string ProductCategory1 { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("ProductCategory")]
    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
