using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("product_favorites")]
public partial class ProductFavorite
{
    [Key]
    [Column("product_favorite_id")]
    public int ProductFavoriteId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("product_id")]
    public int ProductId { get; set; }

    [Column("favorited_at", TypeName = "timestamp(6) without time zone")]
    public DateTime FavoritedAt { get; set; }

    [Column("unfavorited_at", TypeName = "timestamp(6) without time zone")]
    public DateTime? UnfavoritedAt { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("ProductFavorites")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("ProductId")]
    [InverseProperty("ProductFavorites")]
    public virtual Product Product { get; set; } = null!;
}
