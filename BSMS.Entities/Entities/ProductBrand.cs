using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("product_brands")]
public partial class ProductBrand
{
    [Key]
    [Column("product_brand_id")]
    public int ProductBrandId { get; set; }

    [Column("product_brand")]
    [StringLength(255)]
    public string ProductBrand1 { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("ProductBrand")]
    public virtual ICollection<Product> Products { get; set; } = new List<Product>();
}
