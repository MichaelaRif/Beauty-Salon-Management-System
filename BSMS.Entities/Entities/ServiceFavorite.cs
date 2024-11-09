using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("service_favorites")]
public partial class ServiceFavorite
{
    [Key]
    [Column("service_favorite_id")]
    public int ServiceFavoriteId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("service_id")]
    public int ServiceId { get; set; }

    [Column("favorited_at", TypeName = "timestamp(6) without time zone")]
    public DateTime FavoritedAt { get; set; }

    [Column("unfavorited_at", TypeName = "timestamp(6) without time zone")]
    public DateTime? UnfavoritedAt { get; set; }

    [Column("created_at", TypeName = "timestamp(6) without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp(6) without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("ServiceFavorites")]
    public virtual Customer Customer { get; set; } = null!;

    [ForeignKey("ServiceId")]
    [InverseProperty("ServiceFavorites")]
    public virtual Service Service { get; set; } = null!;
}
