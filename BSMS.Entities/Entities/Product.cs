using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("products")]
public partial class Product
{
    [Key]
    [Column("product_id")]
    public int ProductId { get; set; }

    [Column("product_name")]
    [StringLength(255)]
    public string ProductName { get; set; } = null!;

    [Column("product_description")]
    [StringLength(255)]
    public string? ProductDescription { get; set; }

    [Column("product_price", TypeName = "money")]
    public decimal ProductPrice { get; set; }

    [Column("product_brand_id")]
    public int ProductBrandId { get; set; }

    [Column("product_category_id")]
    public int ProductCategoryId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [InverseProperty("Product")]
    public virtual ICollection<BundleItem> BundleItems { get; set; } = new List<BundleItem>();

    [InverseProperty("Product")]
    public virtual ICollection<Discount> Discounts { get; set; } = new List<Discount>();

    [InverseProperty("Product")]
    public virtual ICollection<Inventory> Inventories { get; set; } = new List<Inventory>();

    [ForeignKey("ProductBrandId")]
    [InverseProperty("Products")]
    public virtual ProductBrand ProductBrand { get; set; } = null!;

    [InverseProperty("Product")]
    public virtual ICollection<ProductCart> ProductCarts { get; set; } = new List<ProductCart>();

    [ForeignKey("ProductCategoryId")]
    [InverseProperty("Products")]
    public virtual ProductCategory ProductCategory { get; set; } = null!;

    [InverseProperty("Product")]
    public virtual ICollection<ProductFavorite> ProductFavorites { get; set; } = new List<ProductFavorite>();

    [InverseProperty("Product")]
    public virtual ICollection<ProductReview> ProductReviews { get; set; } = new List<ProductReview>();
}
