using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace BSMS.Domain.Entities;

[Table("service_cart")]
public partial class ServiceCart
{
    [Key]
    [Column("service_cart_id")]
    public int ServiceCartId { get; set; }

    [Column("customer_id")]
    public int CustomerId { get; set; }

    [Column("service_id")]
    public int ServiceId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("last_update", TypeName = "timestamp without time zone")]
    public DateTime LastUpdate { get; set; }

    [ForeignKey("CustomerId")]
    [InverseProperty("ServiceCarts")]
    public virtual Customer Customer { get; set; } = null!;
}
